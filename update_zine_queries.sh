#!/bin/bash

set -e

# This is only needed until proper packages are available:
# https://zine-ssg.io/docs/editors/neovim/

cd ~/git/ziggy 
git pull
cp -r tree-sitter-ziggy/queries ~/.config/nvim/queries/ziggy
cp -r tree-sitter-ziggy-schema/queries ~/.config/nvim/queries/ziggy_schema
zig build
cp zig-out/bin/ziggy ~/.local/bin/

cd ~/git/supermd
git pull
cp -r editors/neovim/queries/supermd ~/.config/nvim/queries/supermd
cp -r editors/neovim/queries/supermd_inline ~/.config/nvim/queries/supermd_inline

cd ~/git/superhtml 
git pull
zig build
cp zig-out/bin/superhtml ~/.local/bin/
cp -r tree-sitter-superhtml/queries ~/.config/nvim/queries/superhtml
