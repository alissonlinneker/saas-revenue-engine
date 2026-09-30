# Security Policy

## Scope

SaaS Revenue Engine is a content repository: Markdown instructions, YAML templates, and SQL examples that coding agents load and act on. It ships no runtime service. Security issues here are mostly about content that could lead an agent or a user to do something unsafe.

In scope:

- Content that is prone to prompt injection, for example instructions that tell an agent to ignore the user, exfiltrate data, disable safeguards, or fetch and execute remote code.
- Unsafe commands or code in examples, such as destructive shell commands, SQL that drops or mutates data without clear warning, or snippets that expose secrets.
- Guidance that would lead to insecure handling of customer, billing, or personal data.
- Vulnerabilities in `scripts/validate.py` or the CI workflows.

Out of scope:

- Security of third party tools, billing providers, or agent hosts that use this skill.
- Disagreements about business advice that carry no security impact (open a regular issue instead).

## Supported versions

Only the latest release on the `main` branch receives fixes.

## Reporting a vulnerability

Report privately through GitHub private vulnerability reporting:

1. Go to the repository's **Security** tab.
2. Click **Report a vulnerability**.
3. Describe the file and line, the risk, and a suggested fix if you have one.

Please do not open a public issue for security reports. You should receive an acknowledgement within 7 days. Once a fix is merged, the advisory will be published with credit to the reporter unless you prefer to stay anonymous.
