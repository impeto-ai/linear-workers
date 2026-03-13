#!/bin/bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  Linear x Claude Code — Installer
#  Impeto AI
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# Uso:
#   curl -sL https://raw.githubusercontent.com/impeto-ai/linear-setup/main/install.sh | bash
#
# Pre-requisito:
#   Ter LINEAR_API_KEY no .env do projeto ou em ~/.claude/.env

set -e

REPO_BASE="https://raw.githubusercontent.com/impeto-ai/linear-setup/main"
SKILLS_DEST="$HOME/.claude/skills"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Linear x Claude Code — Installer"
echo "  Impeto AI"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── Instalar skills ─────────────────────

echo "  Instalando skills em ~/.claude/skills/..."

mkdir -p "$SKILLS_DEST/linear-init"
mkdir -p "$SKILLS_DEST/linear-work"

curl -s "$REPO_BASE/skills/linear-init/SKILL.md" -o "$SKILLS_DEST/linear-init/SKILL.md"
echo "    linear-init instalada"

curl -s "$REPO_BASE/skills/linear-work/SKILL.md" -o "$SKILLS_DEST/linear-work/SKILL.md"
echo "    linear-work instalada"

# ── Done ────────────────────────────────

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Skills instaladas!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  Certifique-se de ter LINEAR_API_KEY"
echo "  no .env do projeto ou em ~/.claude/.env"
echo ""
echo "  Comandos no Claude Code:"
echo ""
echo "    /linear-init   Carregar contexto e ver suas tasks"
echo "    /linear-work   Operar tasks (mover, criar, comentar)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
