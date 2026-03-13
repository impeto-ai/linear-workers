#!/bin/bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  Linear x Claude Code — Setup Script
#  Impeto AI
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# Uso: ./linear-setup.sh
#
# O que faz:
#   1. Pede a LINEAR_API_KEY (ou usa a do argumento)
#   2. Cria .env no projeto atual com a key
#   3. Copia as skills linear-init e linear-work para ~/.claude/skills/
#   4. Garante .gitignore inclui .env
#   5. Pronto para usar!

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SOURCE="$SCRIPT_DIR/skills"
SKILLS_DEST="$HOME/.claude/skills"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Linear x Claude Code — Setup"
echo "  Impeto AI"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── Step 1: API Key ──────────────────────

API_KEY="${1:-}"

if [ -z "$API_KEY" ]; then
    # Check if .env already exists
    if [ -f ".env" ] && grep -q "LINEAR_API_KEY" .env 2>/dev/null; then
        EXISTING_KEY=$(grep "LINEAR_API_KEY" .env | cut -d'=' -f2)
        echo "  API key encontrada no .env atual: ${EXISTING_KEY:0:20}..."
        echo ""
        read -p "  Usar essa key? (s/n): " USE_EXISTING
        if [ "$USE_EXISTING" = "s" ] || [ "$USE_EXISTING" = "S" ] || [ "$USE_EXISTING" = "" ]; then
            API_KEY="$EXISTING_KEY"
        fi
    fi

    if [ -z "$API_KEY" ]; then
        echo "  Voce precisa da sua API key do Linear."
        echo "  Se nao tem, peca ao seu manager (Joao - joao@impeto.ai)."
        echo ""
        read -p "  Cole sua LINEAR_API_KEY: " API_KEY

        if [ -z "$API_KEY" ]; then
            echo ""
            echo "  ⚠️  Nenhuma key fornecida. Abortando."
            echo "  Peca sua key ao manager e rode novamente."
            exit 1
        fi
    fi
fi

# ── Step 2: Criar .env ──────────────────

echo ""
echo "  [1/4] Configurando .env..."

if [ -f ".env" ]; then
    if grep -q "LINEAR_API_KEY" .env 2>/dev/null; then
        # Update existing key
        sed -i.bak "s|LINEAR_API_KEY=.*|LINEAR_API_KEY=$API_KEY|" .env && rm -f .env.bak
        echo "        LINEAR_API_KEY atualizada no .env"
    else
        # Append to existing .env
        echo "LINEAR_API_KEY=$API_KEY" >> .env
        echo "        LINEAR_API_KEY adicionada ao .env"
    fi
else
    echo "LINEAR_API_KEY=$API_KEY" > .env
    echo "        .env criado com LINEAR_API_KEY"
fi

# ── Step 3: Copiar skills ───────────────

echo "  [2/4] Instalando skills..."

mkdir -p "$SKILLS_DEST"

# linear-init
if [ -d "$SKILLS_SOURCE/linear-init" ]; then
    mkdir -p "$SKILLS_DEST/linear-init"
    cp "$SKILLS_SOURCE/linear-init/SKILL.md" "$SKILLS_DEST/linear-init/SKILL.md"
    echo "        linear-init instalada em $SKILLS_DEST/linear-init/"
else
    echo "        ⚠️  Pasta skills/linear-init nao encontrada em $SKILLS_SOURCE"
fi

# linear-work
if [ -d "$SKILLS_SOURCE/linear-work" ]; then
    mkdir -p "$SKILLS_DEST/linear-work"
    cp "$SKILLS_SOURCE/linear-work/SKILL.md" "$SKILLS_DEST/linear-work/SKILL.md"
    echo "        linear-work instalada em $SKILLS_DEST/linear-work/"
else
    echo "        ⚠️  Pasta skills/linear-work nao encontrada em $SKILLS_SOURCE"
fi

# ── Step 4: .gitignore ─────────────────

echo "  [3/4] Verificando .gitignore..."

if [ -f ".gitignore" ]; then
    if ! grep -q "^\.env$" .gitignore 2>/dev/null; then
        echo ".env" >> .gitignore
        echo "        .env adicionado ao .gitignore"
    else
        echo "        .env ja esta no .gitignore"
    fi
else
    echo ".env" > .gitignore
    echo "        .gitignore criado com .env"
fi

# ── Step 5: Validar API Key ────────────

echo "  [4/4] Validando API key..."

RESPONSE=$(curl -s -X POST https://api.linear.app/graphql \
    -H "Content-Type: application/json" \
    -H "Authorization: $API_KEY" \
    -d '{"query": "{ viewer { name email } }"}' 2>/dev/null)

if echo "$RESPONSE" | grep -q '"name"'; then
    USER_NAME=$(echo "$RESPONSE" | grep -o '"name":"[^"]*"' | head -1 | cut -d'"' -f4)
    USER_EMAIL=$(echo "$RESPONSE" | grep -o '"email":"[^"]*"' | head -1 | cut -d'"' -f4)
    echo "        Conectado como: $USER_NAME ($USER_EMAIL)"
else
    echo "        ⚠️  API key invalida ou sem conexao."
    echo "        Verifique a key e tente novamente."
    exit 1
fi

# ── Done ────────────────────────────────

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Setup completo!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  Comandos disponiveis no Claude Code:"
echo ""
echo "    /linear-init   Carregar contexto e ver suas tasks"
echo "    /linear-work   Operar tasks (mover, criar, comentar)"
echo ""
echo "  Comece com: /linear-init"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
