#!/bin/bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  Linear x Claude Code — Remote Installer
#  Impeto AI
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# Uso:
#   curl -sL https://raw.githubusercontent.com/impeto-ai/linear-setup/main/install.sh | bash -s -- SUA_API_KEY
#
# Ou:
#   curl -sL https://raw.githubusercontent.com/impeto-ai/linear-setup/main/install.sh | bash
#   (vai pedir a key interativamente)

set -e

REPO_BASE="https://raw.githubusercontent.com/impeto-ai/linear-setup/main"
SKILLS_DEST="$HOME/.claude/skills"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Linear x Claude Code — Installer"
echo "  Impeto AI"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── Step 1: API Key ──────────────────────

API_KEY="${1:-}"

if [ -z "$API_KEY" ]; then
    echo "  Voce precisa da sua API key do Linear."
    echo "  Se nao tem, peca ao seu manager (Joao - joao@impeto.ai)."
    echo ""
    read -p "  Cole sua LINEAR_API_KEY: " API_KEY

    if [ -z "$API_KEY" ]; then
        echo ""
        echo "  Nenhuma key fornecida. Abortando."
        echo "  Peca sua key ao manager e rode novamente."
        exit 1
    fi
fi

# ── Step 2: Validar API Key ─────────────

echo "  [1/3] Validando API key..."

RESPONSE=$(curl -s -X POST https://api.linear.app/graphql \
    -H "Content-Type: application/json" \
    -H "Authorization: $API_KEY" \
    -d '{"query": "{ viewer { name email } }"}' 2>/dev/null)

if echo "$RESPONSE" | grep -q '"name"'; then
    USER_NAME=$(echo "$RESPONSE" | grep -o '"name":"[^"]*"' | head -1 | cut -d'"' -f4)
    USER_EMAIL=$(echo "$RESPONSE" | grep -o '"email":"[^"]*"' | head -1 | cut -d'"' -f4)
    echo "        Conectado como: $USER_NAME ($USER_EMAIL)"
else
    echo "        API key invalida ou sem conexao."
    echo "        Verifique a key e tente novamente."
    exit 1
fi

# ── Step 3: Instalar skills ─────────────

echo "  [2/3] Instalando skills em ~/.claude/skills/..."

mkdir -p "$SKILLS_DEST/linear-init"
mkdir -p "$SKILLS_DEST/linear-work"

curl -s "$REPO_BASE/skills/linear-init/SKILL.md" -o "$SKILLS_DEST/linear-init/SKILL.md"
echo "        linear-init instalada"

curl -s "$REPO_BASE/skills/linear-work/SKILL.md" -o "$SKILLS_DEST/linear-work/SKILL.md"
echo "        linear-work instalada"

# ── Step 4: Configurar .env global ──────

echo "  [3/3] Configurando API key..."

CLAUDE_DIR="$HOME/.claude"
mkdir -p "$CLAUDE_DIR"

ENV_FILE="$CLAUDE_DIR/.env"

if [ -f "$ENV_FILE" ]; then
    if grep -q "LINEAR_API_KEY" "$ENV_FILE" 2>/dev/null; then
        sed -i.bak "s|LINEAR_API_KEY=.*|LINEAR_API_KEY=$API_KEY|" "$ENV_FILE" && rm -f "$ENV_FILE.bak"
        echo "        LINEAR_API_KEY atualizada em ~/.claude/.env"
    else
        echo "LINEAR_API_KEY=$API_KEY" >> "$ENV_FILE"
        echo "        LINEAR_API_KEY adicionada em ~/.claude/.env"
    fi
else
    echo "LINEAR_API_KEY=$API_KEY" > "$ENV_FILE"
    echo "        ~/.claude/.env criado com LINEAR_API_KEY"
fi

# ── Done ────────────────────────────────

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Instalacao completa!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  Usuario: $USER_NAME ($USER_EMAIL)"
echo "  Skills:  ~/.claude/skills/linear-{init,work}/"
echo "  API Key: ~/.claude/.env"
echo ""
echo "  Abra o Claude Code em qualquer projeto e use:"
echo ""
echo "    /linear-init   Carregar contexto e ver suas tasks"
echo "    /linear-work   Operar tasks (mover, criar, comentar)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
