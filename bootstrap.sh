#!/bin/bash
# vim-o-shrimp 🦐 bootstrap
# Usage: ./bootstrap.sh          # Full deploy: symlink vimrc, install plugins, compile YCM
#        ./bootstrap.sh --test   # Test mode: use this vimrc without touching ~/.vimrc
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VIMRC_SRC="$SCRIPT_DIR/vimrc"

# --- Parse args ---
TEST_MODE=false
if [ "$1" = "--test" ]; then
    TEST_MODE=true
fi

# --- Install vim-plug if missing ---
PLUG_FILE="$HOME/.vim/autoload/plug.vim"
if [ ! -f "$PLUG_FILE" ]; then
    echo "Installing vim-plug..."
    curl -fLo "$PLUG_FILE" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "  ✓ vim-plug installed"
else
    echo "  ✓ vim-plug already installed"
fi

if [ "$TEST_MODE" = true ]; then
    echo ""
    echo "=== Test mode ==="
    echo "Installing plugins using $VIMRC_SRC (not touching ~/.vimrc)..."
    vim -u "$VIMRC_SRC" +PlugInstall +qall --not-a-term 2>&1
    echo "  ✓ Plugins installed to ~/.vim/plugged/"
    echo ""
    echo "Test with:  vim -u $VIMRC_SRC"
    echo "Deploy for real:  ./bootstrap.sh"
    exit 0
fi

# --- Deploy: symlink vimrc ---
echo ""
echo "=== Deploying vimrc ==="

if [ -f "$HOME/.vimrc" ] && [ ! -L "$HOME/.vimrc" ]; then
    BACKUP="$HOME/.vimrc.bak.$(date +%Y%m%d_%H%M%S)"
    cp "$HOME/.vimrc" "$BACKUP"
    echo "  Backed up existing .vimrc → $BACKUP"
fi

ln -sf "$VIMRC_SRC" "$HOME/.vimrc"
echo "  ✓ ~/.vimrc → $VIMRC_SRC"

# --- Install plugins ---
echo ""
echo "=== Installing plugins ==="
vim +PlugInstall +qall --not-a-term 2>&1
echo "  ✓ Plugins installed"

# --- Compile YCM if needed ---
YCM_DIR="$HOME/.vim/plugged/YouCompleteMe"
if [ -d "$YCM_DIR" ]; then
    echo ""
    echo "=== Compiling YouCompleteMe ==="

    # Check for build deps
    MISSING_DEPS=""
    command -v cmake >/dev/null 2>&1 || MISSING_DEPS="$MISSING_DEPS cmake"
    command -v g++ >/dev/null 2>&1   || MISSING_DEPS="$MISSING_DEPS g++"

    if [ -n "$MISSING_DEPS" ]; then
        echo "  ⚠ Missing build dependencies:$MISSING_DEPS"
        echo "  Install them and re-run bootstrap.sh"
        echo "  YCM will not work until compiled."
    else
        cd "$YCM_DIR"
        python3 install.py
        echo "  ✓ YCM compiled"
    fi
fi

echo ""
echo "🦐 vim-o-shrimp deployed!"
echo ""
echo "To update later:"
echo "  cd $SCRIPT_DIR && git pull && ./bootstrap.sh"
