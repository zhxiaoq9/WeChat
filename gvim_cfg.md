
```
"Show line number
set nu!

"Command history
set history=1024

"Set the cursor
set cursorcolumn
set cursorline
set guicursor+=a:blinkon0

"Syntax highlighting
syntax enable
syntax on

"Set tab key as 4 blank
set tabstop=4

"Highlight search
set hlsearch

colorscheme desert
set guifont=Consolas:h10
set showmatch

"Turn off back up
set nobackup
set noundofile
set noswapfile


"Remap Key
inoremap (   ()<ESC>i
inoremap [   []<ESC>i
inoremap {   {}<ESC>i
inoremap <   <=<ESC>a


let g:miniBufExplMapCTabSwitchBufs=1 
let g:miniBufExplMapWindowsNavVim=1 
let g:miniBufExplMapWindowNavArrows=1

```