" ~/.vimrc (or ~/.vim/vimrc)
" In vimscript, line comments start with double quotes

set nocompatible
set number norelativenumber
" Hybrid line numbers are best, but take some getting used to:
"   set number relativenumber

set t_Co=256  " Assume we have 256 colors.   The 1980's are over.

" We always want a status line:
set laststatus=2

" Ctrl+z is the CUA 'undo'.  If you find vim's standard 'u' to
" be a bit dangerous, you can uncomment the line below to nullify
" that.  Then just use Ctrl+z all the time.
nnoremap <C-Z> u
inoremap <C-Z> <ESC>u
vnoremap <C-Z> u
"   nnoremap u <Nop>  " Un-comment this to eliminate 'u' as undo


" Most advanced vim users map a key sequence to be an alternate <ESC>,
" simply because the ESC key is far away from the precious HOME row of
" the keyboard, and you hit it about 10,000 times per day.  Since efficiency
" is everything, the sequence of 'j' followed by 'k', which can be typed
" very quickly, is a popular choice.  ('jj' is another popular choice).
"
" If you actually need to type jk in text, just type the 'j' and then pause
" for a second, so vim will respect your wishes instead of interpreting ESC:
inoremap jk <ESC>
inoremap JK <ESC>  " Map the capital version too -- although CAPSLOCK is evil
inoremap jj <Nop>  " Don't do anything for jj


" Smart tabbing / autoindenting is the norm for programming editors:
set autoindent
set copyindent

" Allow backspace to back over newlines.  Otherwise, that's just weird:
set backspace=indent,eol,start

set shiftwidth=4  " Number of spaces for autoindent
set shiftround    " Indenting should be multiple of shiftwidth
set tabstop=4     " Number of spaces per tab
set expandtab     " Insert spaces instead of tabs
set textwidth=79  " auto-wrap text lines by default

set showmatch     " Briefly highlight matching brackets/braces/parens
set hlsearch      " Highlight all search matches
set smartcase     " Enable case-insensitive search unless search text has caps
set incsearch     " Use incremental search

" You probably want it to write current file when jumping to another, until
" you reach level 10:
set autowrite

" Yes, wrap long lines (use :set nowrap) to disable this at runtime:
set wrap

" Ctrl-S should save the current file, as happens in every other app in
" the world:
nnoremap <C-S> :w<CR>

" In normal and visual mode, when wrap is ON, the per-line (instead of
" per-display) vertical movement is disorienting.
" This is cured by remapping j and k to gj and gk:
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" wildmenu turns on the fancy visual display of <TAB> matches when doing
" command-line completion:
set wildmenu

" Enable syntax highlighting:
syntax on

" Vim allows you to customize behavior based on the file type. Here's
" a simple example in which we honor the git world's convention for
" limiting line lengths in commit messages:
augroup gitcommit
    autocmd!
    au FileType gitcommit set textwidth=50
augroup END

" Turn on the spellchecker for markdown files:
augroup markdown
    autocmd!
    au FileType markdown set spell
augroup END

" The default colorscheme is... um... lame.  Try :colorscheme <tab> to
" cycle through the available choices.  You can replace this with your
" favorite:
colorscheme industry1
