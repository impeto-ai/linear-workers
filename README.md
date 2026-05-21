# ⚠️ DEPRECATED — Repositório descontinuado

Este repositório foi **descontinuado em 2026-05-21**.

As skills de integração Linear x Claude Code (`linear-init`, `linear-pm`, `linear-work`, `_linear-shared`) foram **migradas e consolidadas** em:

## 👉 https://github.com/impeto-ai/claude-skills-impeto

Aquele repositório agora é a **fonte única** de todas as skills do time Impeto AI — incluindo as do Linear, mais 40+ skills de outras áreas (Obsidian, Excalidraw, agents, observability, etc).

---

## Como migrar

Se você instalou as skills via este repositório (`linear-workers`):

```bash
# 1. Clone o novo repo
cd ~/Work
git clone https://github.com/impeto-ai/claude-skills-impeto.git

# 2. Rode o installer (instala as skills essenciais, incluindo Linear)
cd claude-skills-impeto
./install.sh
```

O installer detecta o seu projeto atual e instala apenas as skills necessárias.

---

## O que mudou nas skills do Linear

A versão mais recente (v2.2+, em `claude-skills-impeto`) traz:

- **`_linear-shared/`** — fonte única de IDs de times, usuários, states e templates (sem duplicação entre skills)
- **`linear-work/git-workflow.md`** — workflow padronizado **issue → branch → PR → merge** com placeholders dinâmicos (zero hardcode)
- **`linear-work/templates/pr-body.md`** — template de PR com magic words (`Closes IA-XXX`)
- **Solicitante no texto do description** (não em label `Source/*`)
- **Templates Linear obrigatórios** + checkbox "Reportar" pra rastreabilidade

A skill `linear-teams` foi removida (não era usada).

---

## Histórico

Este repositório foi mantido entre **2026-03 e 2026-05** como kit standalone de integração Linear. Foi descontinuado quando o time consolidou todo o universo de skills em `claude-skills-impeto` para simplificar manutenção.

O histórico de commits permanece acessível para referência.
