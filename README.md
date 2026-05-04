# vim-o-shrimp 🦐

Portable Vim configuration managed by [vim-plug](https://github.com/junegunn/vim-plug).

## Quick Start

```bash
git clone git@github.com:ianballou/vim-o-shrimp ~/vim-o-shrimp
cd ~/vim-o-shrimp
./bootstrap.sh
```

## Test Without Affecting Current Setup

```bash
./bootstrap.sh --test
vim -u ~/vim-o-shrimp/vimrc
```

## Update

```bash
cd ~/vim-o-shrimp && git pull && ./bootstrap.sh
```

## Plugins

| Plugin | Purpose |
|--------|---------|
| [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe) | Code completion (requires cmake, g++) |
| [vim-flake8](https://github.com/nvie/vim-flake8) | Python linting |
| [NERDTree](https://github.com/preservim/nerdtree) | File explorer (`Ctrl-n`) |
| [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim) | Fuzzy file finder |
| [vim-fugitive](https://github.com/tpope/vim-fugitive) | Git integration |
| [vim-rhubarb](https://github.com/tpope/vim-rhubarb) | GitHub integration for fugitive |
| [vim-airline](https://github.com/vim-airline/vim-airline) | Status line |
| [vim-airline-themes](https://github.com/vim-airline/vim-airline-themes) | Airline themes |
| [vim-puppet](https://github.com/rodjek/vim-puppet) | Puppet syntax |

## Key Mappings

- `Ctrl-n` — Toggle NERDTree
- `Ctrl-h/j/k/l` — Navigate splits
- `<leader>g` — YCM GoToDefinition
