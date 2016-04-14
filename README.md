# nrun.vim
Vim-native "which" and "exec" functions targeted at local node project bin, falling back to `which`, for easy vim integration with dev-depenendencies in node-based build processes.

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
## Why?
Eases the pain of integrating vim into your JavaScript/node build tools.

Many of the development and build processes inherent to node require the use of locally-installed executables for linting, testing, building, etc. While npm scripts often work well for this, it can be inconvenient to set an npm script for every runnable dependency. There's `npm bin` to find your local bin directory, but it's noticeably slow, and can bog down vim plugins.

For a time I used a bash script, or the node-based [npm-which](https://www.npmjs.com/package/npm-which), but preferred a self-contained vimscript implementation with no global dependencies (`which` aside).
