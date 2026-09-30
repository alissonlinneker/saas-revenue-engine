#!/usr/bin/env python3
"""Repository linter for SaaS Revenue Engine.

Checks:
  1. Every skill directory under skills/ has a SKILL.md with YAML frontmatter
     containing `name` (matches the directory, lowercase letters, digits and
     hyphens, at most 64 chars) and `description` (at most 1024 chars).
  2. Every relative Markdown link resolves to an existing file or directory.
  3. No em dash (U+2014) or en dash (U+2013) characters in text files
     (md, yaml, yml, sql, py, json).
  4. YAML files parse (only when PyYAML is installed; skipped otherwise).
  5. SQL files are not empty.
  6. Numbered reference files (references/NN-*.md) contain an
     "## Audit checklist" section.

Usage:
  python3 scripts/validate.py [repo_root]

Exits with status 1 and prints file:line messages when any check fails.
Requires Python 3.9+ and the standard library only.
"""

from __future__ import annotations

import os
import re
import subprocess
import sys
from pathlib import Path
from typing import Dict, List, Optional, Tuple

try:
    import yaml  # type: ignore

    HAVE_YAML = True
except ImportError:  # pragma: no cover
    yaml = None
    HAVE_YAML = False

TEXT_EXTENSIONS = {".md", ".yaml", ".yml", ".sql", ".py", ".json", ".jsonc"}
# Built from code points so this file never contains the characters it bans.
FORBIDDEN_CHARS = {
    chr(0x2014): "em dash (U+2014)",
    chr(0x2013): "en dash (U+2013)",
}
SKIP_DIRS = {".git", "node_modules", "__pycache__", ".venv", "venv", ".claude", ".memory-bank"}
NAME_RE = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
NUMBERED_REFERENCE_RE = re.compile(r"^\d{2}-.+\.md$")
AUDIT_HEADING_RE = re.compile(r"^##\s+Audit checklist\s*$", re.IGNORECASE)
FENCE_RE = re.compile(r"^\s*(```|~~~)")
INLINE_CODE_RE = re.compile(r"`[^`]*`")
INLINE_LINK_RE = re.compile(r"!?\[(?:[^\]\\]|\\.)*\]\(\s*<?([^)\s>]+)>?(?:\s+\"[^\"]*\")?\s*\)")
REF_DEF_RE = re.compile(r"^\s{0,3}\[[^\]]+\]:\s*<?(\S+?)>?(?:\s+.*)?$")
SCHEME_RE = re.compile(r"^[a-zA-Z][a-zA-Z0-9+.-]*:")


class Report:
    def __init__(self) -> None:
        self.errors: List[str] = []
        self.warnings: List[str] = []

    def error(self, path: Path, line: Optional[int], message: str) -> None:
        location = f"{path}:{line}" if line else f"{path}"
        self.errors.append(f"{location}: error: {message}")

    def warn(self, message: str) -> None:
        self.warnings.append(f"warning: {message}")


def rel(root: Path, path: Path) -> Path:
    try:
        return path.relative_to(root)
    except ValueError:
        return path


def list_files(root: Path) -> List[Path]:
    """Return tracked plus untracked, non-ignored files; fall back to a walk."""
    try:
        out = subprocess.run(
            ["git", "ls-files", "--cached", "--others", "--exclude-standard", "-z"],
            cwd=root,
            capture_output=True,
            check=True,
        ).stdout.decode("utf-8", "replace")
        files = [root / p for p in out.split("\0") if p]
        return sorted(
            f for f in files if f.is_file() and not (set(f.relative_to(root).parts) & SKIP_DIRS)
        )
    except (OSError, subprocess.CalledProcessError):
        pass
    files = []
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
        for name in filenames:
            files.append(Path(dirpath) / name)
    return sorted(files)


def read_text(path: Path, report: Report, root: Path) -> Optional[str]:
    try:
        return path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        report.error(rel(root, path), None, "file is not valid UTF-8")
    except OSError as exc:
        report.error(rel(root, path), None, f"cannot read file: {exc}")
    return None


# ---------------------------------------------------------------- frontmatter


def parse_frontmatter(text: str) -> Tuple[Optional[Dict[str, str]], Optional[str]]:
    """Return (fields, error). Uses PyYAML when available, else a minimal parser."""
    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        return None, "missing YAML frontmatter (file must start with '---')"
    end = None
    for i in range(1, len(lines)):
        if lines[i].strip() == "---":
            end = i
            break
    if end is None:
        return None, "unterminated YAML frontmatter (no closing '---')"
    block = "\n".join(lines[1:end])

    if HAVE_YAML:
        try:
            data = yaml.safe_load(block) or {}
        except yaml.YAMLError as exc:  # type: ignore[union-attr]
            return None, f"frontmatter is not valid YAML: {exc}"
        if not isinstance(data, dict):
            return None, "frontmatter must be a YAML mapping"
        return {str(k): "" if v is None else str(v) for k, v in data.items()}, None

    fields: Dict[str, str] = {}
    key: Optional[str] = None
    buf: List[str] = []

    def flush() -> None:
        if key is not None:
            value = " ".join(s.strip() for s in buf if s.strip())
            fields[key] = value.strip().strip("\"'")

    for raw in lines[1:end]:
        top = re.match(r"^([A-Za-z0-9_-]+):\s*(.*)$", raw)
        if top and not raw.startswith((" ", "\t")):
            flush()
            key, value = top.group(1), top.group(2)
            is_block_scalar = value in {"|", ">", "|-", ">-", "|+", ">+"}
            buf = [] if is_block_scalar else [value]
        elif key is not None and (raw.startswith((" ", "\t")) or not raw.strip()):
            buf.append(raw)
    flush()
    return fields, None


def check_skills(root: Path, report: Report) -> None:
    skills_dir = root / "skills"
    if not skills_dir.is_dir():
        report.error(Path("skills"), None, "skills/ directory not found")
        return
    skill_dirs = sorted(p for p in skills_dir.iterdir() if p.is_dir() and not p.name.startswith("."))
    if not skill_dirs:
        report.error(Path("skills"), None, "no skill directories found")
    for skill in skill_dirs:
        skill_md = skill / "SKILL.md"
        shown = rel(root, skill_md)
        if not skill_md.is_file():
            report.error(shown, None, "missing SKILL.md")
            continue
        text = read_text(skill_md, report, root)
        if text is None:
            continue
        fields, err = parse_frontmatter(text)
        if err or fields is None:
            report.error(shown, 1, err or "cannot parse frontmatter")
            continue
        name = fields.get("name", "").strip()
        description = fields.get("description", "").strip()
        if not name:
            report.error(shown, 1, "frontmatter is missing 'name'")
        else:
            if name != skill.name:
                report.error(shown, 1, f"name '{name}' does not match directory '{skill.name}'")
            if not NAME_RE.match(name):
                report.error(shown, 1, f"name '{name}' must be lowercase letters, digits and single hyphens")
            if len(name) > 64:
                report.error(shown, 1, f"name is {len(name)} chars (max 64)")
        if not description:
            report.error(shown, 1, "frontmatter is missing 'description'")
        elif len(description) > 1024:
            report.error(shown, 1, f"description is {len(description)} chars (max 1024)")


# ---------------------------------------------------------------- links


def iter_markdown_links(text: str):
    """Yield (line_number, target) for links outside fenced and inline code."""
    in_fence = False
    fence_marker = ""
    for lineno, line in enumerate(text.splitlines(), start=1):
        fence = FENCE_RE.match(line)
        if fence:
            marker = fence.group(1)
            if not in_fence:
                in_fence, fence_marker = True, marker
            elif marker == fence_marker:
                in_fence = False
            continue
        if in_fence:
            continue
        stripped = INLINE_CODE_RE.sub("", line)
        for match in INLINE_LINK_RE.finditer(stripped):
            yield lineno, match.group(1)
        ref = REF_DEF_RE.match(stripped)
        if ref:
            yield lineno, ref.group(1)


def check_links(root: Path, md_files: List[Path], report: Report) -> None:
    for path in md_files:
        text = read_text(path, report, root)
        if text is None:
            continue
        for lineno, target in iter_markdown_links(text):
            if SCHEME_RE.match(target) or target.startswith(("#", "//")):
                continue
            target_path = target.split("#", 1)[0].split("?", 1)[0]
            if not target_path:
                continue
            if target_path.startswith("/"):
                resolved = root / target_path.lstrip("/")
            else:
                resolved = (path.parent / target_path).resolve()
            if not resolved.exists():
                report.error(rel(root, path), lineno, f"broken relative link: {target}")


# ---------------------------------------------------------------- characters, yaml, sql, audit


def check_forbidden_chars(root: Path, files: List[Path], report: Report) -> None:
    for path in files:
        text = read_text(path, report, root)
        if text is None:
            continue
        for lineno, line in enumerate(text.splitlines(), start=1):
            for char, label in FORBIDDEN_CHARS.items():
                col = line.find(char)
                if col != -1:
                    report.error(rel(root, path), lineno, f"forbidden {label} at column {col + 1}")


def check_yaml(root: Path, files: List[Path], report: Report) -> None:
    if not HAVE_YAML:
        if files:
            report.warn("PyYAML not installed; YAML parse check skipped (pip install pyyaml)")
        return
    for path in files:
        text = read_text(path, report, root)
        if text is None:
            continue
        try:
            list(yaml.safe_load_all(text))  # type: ignore[union-attr]
        except yaml.YAMLError as exc:  # type: ignore[union-attr]
            mark = getattr(exc, "problem_mark", None)
            line = mark.line + 1 if mark is not None else None
            problem = getattr(exc, "problem", None) or str(exc).splitlines()[0]
            report.error(rel(root, path), line, f"invalid YAML: {problem}")


def check_sql(root: Path, files: List[Path], report: Report) -> None:
    for path in files:
        text = read_text(path, report, root)
        if text is None:
            continue
        meaningful = [ln for ln in text.splitlines() if ln.strip() and not ln.strip().startswith("--")]
        if not meaningful:
            report.error(rel(root, path), None, "SQL file is empty (only whitespace or comments)")


def check_audit_sections(root: Path, md_files: List[Path], report: Report) -> None:
    for path in md_files:
        if path.parent.name != "references" or not NUMBERED_REFERENCE_RE.match(path.name):
            continue
        text = read_text(path, report, root)
        if text is None:
            continue
        in_fence = False
        found = False
        for line in text.splitlines():
            if FENCE_RE.match(line):
                in_fence = not in_fence
                continue
            if not in_fence and AUDIT_HEADING_RE.match(line):
                found = True
                break
        if not found:
            report.error(rel(root, path), None, "missing '## Audit checklist' section")


# ---------------------------------------------------------------- main


def main(argv: Optional[List[str]] = None) -> int:
    argv = sys.argv[1:] if argv is None else argv
    root = Path(argv[0]).resolve() if argv else Path(__file__).resolve().parent.parent
    report = Report()

    files = list_files(root)
    text_files = [f for f in files if f.suffix.lower() in TEXT_EXTENSIONS]
    md_files = [f for f in files if f.suffix.lower() == ".md"]
    yaml_files = [f for f in files if f.suffix.lower() in {".yaml", ".yml"}]
    sql_files = [f for f in files if f.suffix.lower() == ".sql"]

    check_skills(root, report)
    check_links(root, md_files, report)
    check_forbidden_chars(root, text_files, report)
    check_yaml(root, yaml_files, report)
    check_sql(root, sql_files, report)
    check_audit_sections(root, md_files, report)

    for warning in report.warnings:
        print(warning, file=sys.stderr)
    for error in report.errors:
        print(error)

    summary = (
        f"checked {len(text_files)} text files ({len(md_files)} markdown, "
        f"{len(yaml_files)} yaml, {len(sql_files)} sql)"
    )
    if report.errors:
        print(f"\nFAILED: {len(report.errors)} error(s); {summary}")
        return 1
    print(f"OK: {summary}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
