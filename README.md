# nrun.vim
Defines "which" and "exec" functions targeted at local node project bin, with "which" fallback

## Why?
Eases the pain of integrating vim into your JavaScript/node build tools.

Many of the development and build processes inherent to node require the use of locally-installed executables for linting, testing, building, etc. While npm scripts often work well for this, invoking via npm is slow, and it can be inconvenient to set an npm script for every runnable dependency. There's `npm bin` to find your local bin directory, but it's noticeably slow, and can bog down relying vim plugins. One could use a bash script, or `npm-which` on npm, but this is a self-contained vimscript implementation with no dependencies other than a Unix-style `which` for fallback purposes.

## Install
Must already have neomake set up. This will automatically set eslint as a maker on top of setting its executable path for Neomake.
Using [vim-plug](https://github.com/junegunn/vim-plug):
```
Plug 'jaawerth/nrun.vim'
```

Using [vundle](https://github.com/VundleVim/Vundle.vim):
```
Plugin 'jaawerth/nrun.vim'
```
## Functions
### nrun#Which('command')
A "which" that first tries to see if you're in a node project (traversing the current directly up looking for package.json and node_modules/.bin/<command>), falling back to "which" if root or home folders are hit without a match.

### nrun#Exec('command')
Executes the above and passes the results to system() for you. Throws if no command found.

### nrun#StrTrim(string)
Trim the whitespace around a string (used internally to account for the newline from `which`)

## Examples

### With [neovim](https://github.com/neovim/neovim) + [Neomake](https://github.com/benekastah/neomake)
In `~/<nvim-config>/ftplugin/javascript.vim`:
```nvim
" set neomake's eslint path, and enable it as a maker
let g:neomake_javascript_eslint_exe = nrun#Which('eslint')
let g:neomake_javascript_enabled_makers = ['eslint']

" Auto-lint on save and buffer open
autocmd! BufWritePost * Neomake
autocmd! BufWinEnter * Neomake
```

### With vim + [Syntastic](https://github.com/scrooloose/syntastic)
```vim
let b:syntastic_javascript_eslint_exec = nrun#Which('eslint')
```
