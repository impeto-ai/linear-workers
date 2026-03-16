#!/bin/bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  Linear x Claude Code — Installer
#  Impeto AI
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# Instala as skills Linear no PROJETO ATUAL (.claude/skills/)
# Rode na raiz do projeto onde voce quer usar o Linear.
#
# Uso:
#   curl -sL https://raw.githubusercontent.com/impeto-ai/linear-setup/main/install.sh | bash
#
# Funciona em: macOS, Linux, Windows (Git Bash / WSL)
#
# Pre-requisito:
#   Ter LINEAR_API_KEY no .env do projeto

set -e

REPO_BASE="https://raw.githubusercontent.com/impeto-ai/linear-setup/main"
SKILLS_DEST=".claude/skills"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Linear x Claude Code — Installer"
echo "  Impeto AI"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── Verificar se esta na raiz de um projeto ──

if [ ! -d ".git" ] && [ ! -f "package.json" ] && [ ! -f "pyproject.toml" ] && [ ! -f "go.mod" ]; then
    echo "  AVISO: Nao parece ser a raiz de um projeto."
    echo "  Certifique-se de rodar este script na raiz do seu projeto."
    echo ""
    read -p "  Continuar mesmo assim? (s/n): " CONTINUE
    if [ "$CONTINUE" != "s" ] && [ "$CONTINUE" != "S" ]; then
        echo "  Abortado. Navegue ate a raiz do projeto e rode novamente."
        exit 1
    fi
fi

# ── Verificar curl ────────────────────────

if ! command -v curl &> /dev/null; then
    echo "  ERRO: curl nao encontrado."
    echo "  Instale o curl e rode novamente."
    exit 1
fi

# ── Instalar skills no projeto ────────────

echo "  Instalando skills em .claude/skills/..."
echo ""

mkdir -p "$SKILLS_DEST/linear-init"
mkdir -p "$SKILLS_DEST/linear-work"

# linear-init
HTTP_CODE=$(curl -s -w "%{http_code}" -o "$SKILLS_DEST/linear-init/SKILL.md" "$REPO_BASE/skills/linear-init/SKILL.md")
if [ "$HTTP_CODE" = "200" ]; then
    echo "    linear-init .... OK"
else
    echo "    linear-init .... FALHOU (HTTP $HTTP_CODE)"
    echo "    Verifique sua conexao e tente novamente."
    exit 1
fi

# linear-work
HTTP_CODE=$(curl -s -w "%{http_code}" -o "$SKILLS_DEST/linear-work/SKILL.md" "$REPO_BASE/skills/linear-work/SKILL.md")
if [ "$HTTP_CODE" = "200" ]; then
    echo "    linear-work .... OK"
else
    echo "    linear-work .... FALHOU (HTTP $HTTP_CODE)"
    echo "    Verifique sua conexao e tente novamente."
    exit 1
fi

# ── Verificar .env ────────────────────────

echo ""
if [ -f ".env" ] && grep -q "LINEAR_API_KEY" .env 2>/dev/null; then
    echo "  LINEAR_API_KEY encontrada no .env"
else
    echo "  AVISO: LINEAR_API_KEY nao encontrada no .env"
    echo "  Adicione ao .env do projeto: LINEAR_API_KEY=lin_api_XXXXX"
    echo "  Peca sua key ao manager (Joao - joao@impeto.ai)"
fi

# ── Verificar .gitignore ─────────────────

if [ -f ".gitignore" ]; then
    if ! grep -q "^\.env$" .gitignore 2>/dev/null; then
        echo ".env" >> .gitignore
        echo "  .env adicionado ao .gitignore"
    fi
else
    echo ".env" > .gitignore
    echo "  .gitignore criado com .env"
fi

# ── Done ──────────────────────────────────

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Instalacao completa!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  Skills instaladas em: .claude/skills/"
echo "  Visiveis no seu editor e no Claude Code."
echo ""
echo "  Comandos disponiveis:"
echo ""
echo "    /linear-init   Carregar contexto e ver tasks"
echo "    /linear-work   Operar tasks (mover, criar, comentar)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
