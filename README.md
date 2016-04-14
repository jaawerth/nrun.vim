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

## Usage Examples

### With vim + [Syntastic](https://github.com/scrooloose/syntastic)
In you `~/.vimrc` or in a javascript ftplugin
```vim
let b:syntastic_javascript_eslint_exec = nrun#Which('eslint')
```

### With [neovim](https://github.com/neovim/neovim) + [Neomake](https://github.com/benekastah/neomake)
This is my favorite setup. In your `~/<nvim-config>/init.vim` or `~/<nvim-config>/ftplugin/javascript.vim`:
```nvim
" set neomake's eslint path, and enable it as a maker
let g:neomake_javascript_eslint_exe = nrun#Which('eslint')
let g:neomake_javascript_enabled_makers = ['eslint']
```
For more on Neomake config, see their docs - I like to put the above in an ftplugin file with the following to auto-lint on save and file load:
```nvim
autocmd! BufWritePost * Neomake
autocmd! BufWinEnter * Neomake
```

## Functions
### nrun#Which('command')
A "which" that first tries to see if you're in a node project (traversing the current directly up looking for package.json and node_modules/.bin/<command>), falling back to "which" if root or home folders are hit without a match.

### nrun#Exec('command')
Executes the above and passes the results to system() for you. Throws if no command found.

### nrun#StrTrim(string)
Trim the whitespace around a string (used internally to account for the newline from `which`)

## Why?
Eases the pain of integrating vim into your JavaScript/node build tools.

Many of the development and build processes inherent to node require the use of locally-installed executables for linting, testing, building, etc. While npm scripts often work well for this, it can be inconvenient to set an npm script for every runnable dependency. There's `npm bin` to find your local bin directory, but it's noticeably slow, and can bog down vim plugins.

For a time I used a bash script, or the node-based [npm-which](https://www.npmjs.com/package/npm-which), but preferred a self-contained vimscript implementation with no global dependencies (`which` aside).
