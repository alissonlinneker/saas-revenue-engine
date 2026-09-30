# SaaS Revenue Engine

[English](README.md)

Uma skill para agentes que ajuda quem constrói SaaS a implementar e auditar boas práticas de vendas e receita em todo o ciclo de vida do cliente.

[![Licença: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Validate](https://img.shields.io/github/actions/workflow/status/alissonlinneker/saas-revenue-engine/validate.yml?branch=main&label=validate)](https://github.com/alissonlinneker/saas-revenue-engine/actions/workflows/validate.yml)

## O que ela faz

O SaaS Revenue Engine dá ao seu agente de código um conhecimento prático de como empresas SaaS adquirem, convertem, integram, retêm e expandem clientes, além das métricas, do pricing, dos dados e das operações que sustentam tudo isso. Ela funciona em três modos:

| Modo | O que você recebe |
| --- | --- |
| **Aconselhar** | Respostas baseadas na prática: qual métrica acompanhar, como estruturar um trial, quando montar um time de vendas, como precificar um novo plano. |
| **Auditar** | Uma revisão ponta a ponta de um projeto SaaS inteiro (código, schema, eventos, cobrança, documentação) contra um checklist pontuado, gravada em `docs/revenue-audit.md` com evidência e severidade para cada achado. |
| **Implementar** | Constrói as peças que faltam na sua stack: estágios do ciclo de vida no schema, plano de tracking e eventos, consultas de métricas, dunning, fluxos de ativação, gatilhos de expansão. |

A cobertura inclui aquisição, vendas, onboarding e ativação, retenção e expansão, métricas, pricing e empacotamento, instrumentação de dados, operações de receita, estágios de crescimento e melhoria contínua.

## O que tem dentro

```text
skills/saas-revenue-engine/
  SKILL.md          ponto de entrada, sempre carregado
  AUDIT.md          protocolo para auditar um projeto SaaS de ponta a ponta
  IMPLEMENT.md      protocolo para implementar capacidades ausentes
  references/       carregados sob demanda
  templates/        dicionário de métricas, plano de tracking, relatório de auditoria, SQL
```

### Arquivos de referência

| Arquivo | Tema |
| --- | --- |
| [01-customer-lifecycle.md](skills/saas-revenue-engine/references/01-customer-lifecycle.md) | Estágios do ciclo de vida, definições, conversão e velocidade entre estágios |
| [02-metrics.md](skills/saas-revenue-engine/references/02-metrics.md) | MRR, ARR, churn, retenção, NRR, CAC, LTV, payback e como calculá-los |
| [03-pricing-and-packaging.md](skills/saas-revenue-engine/references/03-pricing-and-packaging.md) | Métricas de valor, planos, trials, freemium, descontos, mudanças de preço |
| [04-go-to-market-motions.md](skills/saas-revenue-engine/references/04-go-to-market-motions.md) | Self-serve, product-led, inside sales, field sales, enterprise, modelos híbridos |
| [05-demand-and-acquisition.md](skills/saas-revenue-engine/references/05-demand-and-acquisition.md) | Canais, qualificação de leads, atribuição, economia de aquisição |
| [06-sales-process.md](skills/saas-revenue-engine/references/06-sales-process.md) | Estágios do pipeline, qualificação, discovery, forecast, higiene de negócios |
| [07-onboarding-and-activation.md](skills/saas-revenue-engine/references/07-onboarding-and-activation.md) | Métricas de ativação, tempo até o valor, fluxos de onboarding, passagens de bastão |
| [08-retention-and-expansion.md](skills/saas-revenue-engine/references/08-retention-and-expansion.md) | Health score, prevenção de churn, dunning, renovações, upsell e cross-sell |
| [09-data-and-instrumentation.md](skills/saas-revenue-engine/references/09-data-and-instrumentation.md) | Design de eventos, planos de tracking, identidade, modelo de dados, warehouse |
| [10-revenue-operations.md](skills/saas-revenue-engine/references/10-revenue-operations.md) | Sistemas, responsabilidade por processos, governança de dados, cadência de relatórios |
| [11-growth-stages.md](skills/saas-revenue-engine/references/11-growth-stages.md) | O que priorizar dos primeiros clientes até a escala |
| [12-continuous-improvement.md](skills/saas-revenue-engine/references/12-continuous-improvement.md) | Experimentos, revisões, ciclos de feedback, ritmo operacional |

Também em `references/`: [cheatsheet.md](skills/saas-revenue-engine/references/cheatsheet.md) (resumo de uma página) e [glossary.md](skills/saas-revenue-engine/references/glossary.md) (definições).

### Templates

| Arquivo | Finalidade |
| --- | --- |
| [metrics-dictionary.yaml](skills/saas-revenue-engine/templates/metrics-dictionary.yaml) | Definições canônicas de métricas, fórmulas, responsáveis e granularidade |
| [tracking-plan.yaml](skills/saas-revenue-engine/templates/tracking-plan.yaml) | Eventos do ciclo de vida, propriedades e regras de identidade |
| [audit-report.md](skills/saas-revenue-engine/templates/audit-report.md) | Estrutura do relatório de auditoria pontuado |
| [sql/](skills/saas-revenue-engine/templates/sql/) | Schema de referência e consultas de métricas em PostgreSQL |

## Instalação

### Com a CLI de skills

```bash
npx skills add https://github.com/alissonlinneker/saas-revenue-engine --skill saas-revenue-engine
```

### Instalação manual

Clone o repositório e copie ou crie um link simbólico da pasta da skill no local de onde o seu agente lê skills.

```bash
git clone https://github.com/alissonlinneker/saas-revenue-engine.git
cd saas-revenue-engine
```

| Host | Local no nível do usuário |
| --- | --- |
| Claude Code | `~/.claude/skills/` |
| Codex, Amp, Copilot CLI, OpenCode | `~/.agents/skills/` |

```bash
# Claude Code
mkdir -p ~/.claude/skills
ln -s "$(pwd)/skills/saas-revenue-engine" ~/.claude/skills/saas-revenue-engine

# Codex, Amp, Copilot CLI, OpenCode
mkdir -p ~/.agents/skills
ln -s "$(pwd)/skills/saas-revenue-engine" ~/.agents/skills/saas-revenue-engine
```

Use `cp -R` em vez de `ln -s` se preferir uma cópia congelada.

### Instalação local no projeto

Para compartilhar a skill com todos que trabalham em um repositório, coloque-a dentro dele:

```bash
# escolha a pasta que o seu host lê
mkdir -p .claude/skills     # ou .github/skills
cp -R /caminho/para/saas-revenue-engine/skills/saas-revenue-engine .claude/skills/
```

## Uso

Peça ao seu agente em linguagem natural. Os prompts abaixo estão em inglês, mas você pode escrever em português. Exemplos:

```text
Audit this project with saas-revenue-engine.
Implement the top 3 gaps from docs/revenue-audit.md.
Define our activation metric.
Design a tracking plan for our trial to paid funnel.
Write the SQL for net revenue retention by monthly cohort.
We sell to SMBs with a free trial. Should we add a sales-assisted tier?
```

### Exemplo de saída

Trecho ilustrativo do scorecard produzido por uma auditoria (projeto hipotético, números redondos):

```text
Revenue audit scorecard (illustrative)

Area                          Score   High   Medium   Low
Customer lifecycle            2 / 4      2        1     0
Metrics                       2 / 4      1        2     1
Pricing and packaging         3 / 4      0        1     1
Onboarding and activation     1 / 4      3        0     0
Retention and expansion       2 / 4      1        2     0
Data and instrumentation      2 / 4      2        1     1

Top gaps
1. ON-01  No activation event defined; trial conversion cannot be measured.
2. DI-05  Signup and subscription events lack a stable account identifier.
3. RE-08  Failed payments are not retried; no dunning emails.
```

## Princípios de design

- **Ação acima de teoria.** Toda referência inclui um checklist de auditoria com a evidência a procurar e uma severidade.
- **Medir antes de otimizar.** As métricas vêm com fórmula, unidade, granularidade e erros comuns.
- **Divulgação progressiva.** O `SKILL.md` fica pequeno; os arquivos de referência só são carregados quando a tarefa precisa deles.
- **Neutra em relação à stack.** As orientações valem para qualquer provedor de cobrança, CRM ou ferramenta de analytics; o SQL usa PostgreSQL como base legível.
- **Benchmarks honestos.** Apenas faixas amplamente publicadas, apresentadas como ponto de partida a calibrar para o seu segmento.
- **Neutra em relação a fornecedores e metodologias.** Construída a partir de práticas SaaS gerais e publicamente conhecidas, não de um framework proprietário específico.

## Perguntas frequentes

**Serve só para B2B?**
Não. O material sobre ciclo de vida, métricas, retenção e pricing também se aplica a assinaturas B2C e prosumer. As seções sobre processo de vendas e gestão de contas importam mais para B2B, e a skill as ignora quando não se encaixam no seu modelo.

**Funciona com Stripe ou outros provedores de cobrança?**
Sim. As orientações são escritas sobre conceitos (assinaturas, faturas, falhas de pagamento, mudanças de plano) e não sobre uma API específica. Quando o seu código usa Stripe, Paddle, Chargebee ou um sistema de cobrança próprio, o agente adapta as recomendações ao que encontrar.

**E se não houver time de vendas?**
Esse é um caso de primeira classe. Os modelos self-serve e product-led são tratados em profundidade, e a auditoria marca as verificações exclusivas de vendas como não aplicáveis em vez de reprová-las. A referência de estágios de crescimento também explica os sinais que indicam quando vale a pena adicionar assistência de vendas.

**Ela altera o meu código sem perguntar?**
O modo de auditoria apenas lê o projeto e grava o relatório. A implementação acontece quando você pede, uma lacuna por vez, para que você possa revisar cada mudança.

## Como contribuir

Contribuições são bem-vindas. Leia o [CONTRIBUTING.md](CONTRIBUTING.md) e o [guia de autoria](docs/AUTHORING.md) antes de abrir um pull request e rode `python3 scripts/validate.py` localmente.

## Licença

[MIT](LICENSE), copyright 2026 Alisson Linneker.
