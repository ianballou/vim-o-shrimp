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

# --- Deploy or test vimrc ---
if [ "$TEST_MODE" = true ]; then
    echo ""
    echo "=== Test mode ==="
    echo "Installing plugins using $VIMRC_SRC (not touching ~/.vimrc)..."
    vim -u "$VIMRC_SRC" +PlugInstall +qall --not-a-term 2>&1
    echo "  ✓ Plugins installed to ~/.vim/plugged/"
else
    echo ""
    echo "=== Deploying vimrc ==="

    if [ -f "$HOME/.vimrc" ] && [ ! -L "$HOME/.vimrc" ]; then
        BACKUP="$HOME/.vimrc.bak.$(date +%Y%m%d_%H%M%S)"
        cp "$HOME/.vimrc" "$BACKUP"
        echo "  Backed up existing .vimrc → $BACKUP"
    fi

    ln -sf "$VIMRC_SRC" "$HOME/.vimrc"
    echo "  ✓ ~/.vimrc → $VIMRC_SRC"

    echo ""
    echo "=== Installing plugins ==="
    vim +PlugInstall +qall --not-a-term 2>&1
    echo "  ✓ Plugins installed"
fi

# --- Compile YCM if needed ---
YCM_DIR="$HOME/.vim/plugged/YouCompleteMe"
if [ -d "$YCM_DIR" ]; then
    echo ""
    echo "=== Compiling YouCompleteMe ==="

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

# --- Install Solargraph for Ruby LSP support ---
echo ""
echo "=== Ruby LSP (Solargraph) ==="
if command -v gem >/dev/null 2>&1; then
    if gem list -i solargraph >/dev/null 2>&1; then
        echo "  ✓ Solargraph already installed"
    else
        echo "  Installing solargraph..."
        gem install solargraph --user-install --no-document
        echo "  ✓ Solargraph installed"
    fi

    # Ensure gem bin dir is on PATH
    GEM_BIN="$(ruby -e 'puts Gem.user_dir')/bin"
    if ! echo "$PATH" | grep -q "$GEM_BIN"; then
        if ! grep -q 'Ruby gems (vim-o-shrimp)' ~/.bashrc 2>/dev/null; then
            echo "" >> ~/.bashrc
            echo "# Ruby gems (vim-o-shrimp)" >> ~/.bashrc
            echo "export PATH=\"$GEM_BIN:\$PATH\"" >> ~/.bashrc
            echo "  ✓ Added $GEM_BIN to PATH in .bashrc"
        fi
        export PATH="$GEM_BIN:$PATH"
    fi
else
    echo "  ⚠ Ruby/gem not found — skipping Solargraph"
fi

# --- Done ---
echo ""
echo "🦐 vim-o-shrimp deployed!"

if [ "$TEST_MODE" = true ]; then
    echo ""
    echo "Test with:  vim -u $VIMRC_SRC"
    echo "Deploy for real:  ./bootstrap.sh"
else
    echo ""
    echo "To update later:"
    echo "  cd $SCRIPT_DIR && git pull && ./bootstrap.sh"
fi
