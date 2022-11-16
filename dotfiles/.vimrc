set tabstop=2       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.

set shiftwidth=2    " Indents will have a width of 4

set softtabstop=2   " Sets the number of columns for a TAB

autocmd Filetype gitcommit setlocal spell textwidth=72

filetype plugin on
syntax on

set number

"# Indent as space insted of tab
set expandtab