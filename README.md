# nrun.vim
Defines "which" and "exec" functions targeted at local node project bin, with "which" fallback

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

## nrun#Which('command')
A "which" that first tries to see if you're in a node project (traversing the current directly up looking for package.json and node_modules/.bin/<command>), falling back to "which" if root or home folders are hit without a match.

## nrun#Exec('command')
Executes the above and passes the results to system() for you.
