#!/bin/bash

# This is only needed until proper packages are available:
# https://zine-ssg.io/docs/editors/neovim/

cd ~/git/ziggy/tree-sitter-ziggy/queries && git pull
cd ~/git/supermd/editors/neovim/queries/supermd_inline && git pull
cd ~/git/superhtml/tree-sitter-superhtml/queries && git pull

cp -r ~/git/ziggy/tree-sitter-ziggy/queries ~/.config/nvim/queries/ziggy
cp -r ~/git/ziggy/tree-sitter-ziggy-schema/queries ~/.config/nvim/queries/ziggy_schema
cp -r ~/git/supermd/editors/neovim/queries/supermd ~/.config/nvim/queries/supermd
cp -r ~/git/supermd/editors/neovim/queries/supermd_inline ~/.config/nvim/queries/supermd_inline
cp -r ~/git/superhtml/tree-sitter-superhtml/queries ~/.config/nvim/queries/superhtml  
