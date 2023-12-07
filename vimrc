" put me under ~/.vim/
set nocompatible " be iMproved
" set exrc         " run .vimrc in the local directory
" colorscheme ron  " also try industry, torte, default
set number       " 显示行号
set confirm      " 在处理未保存或只读文件的时候，弹出确认
set ruler 		 " show cursor position

set encoding=utf-8
set fileencodings=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936,utf-16,big5,euc-jp,latin1

" 不可见字符的格式
set	listchars=eol:$,tab:>-,trail:-,extends:>,precedes:<,space:-
"set list      " 显示不可见字符

set tabstop=4          	"  设置Tab键宽度为多少个空格，但注意并不替换
set shiftwidth=4      	"  设置系统的自动缩紧宽度为多少个空格
"set expandtab         	"  把tab替换为空格

set autoindent        "按下回车键后，下一行的缩进会自动跟上一行的缩进保持一致。
set showmatch         " 光标遇到圆括号、方括号、大括号时，自动高亮对应的另一个圆括号、方括号和大括号
set showmode

" Only do this part when compiled with support for autocommands.
if has("autocmd")
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
endif " has("autocmd")

" use menus in console mode
source $VIMRUNTIME/menu.vim
set wildmenu
set cpo-=<
set wcm=<C-Z>
map <F4> :emenu <C-Z>

" allow <BS> to delete autoindent, eol and go beyound the start point of insertion
set backspace=2

set mouse=a " enable the use of the mouse in all modes in certain terminals

set hlsearch          " 搜索时，高亮显示匹配结果
" set incsearch       " 输入搜索模式时，每输入一个字符，就自动跳到第一个匹配的结果。
"syntax on
" do not reverse TabLineFill on term and cterm, use ":hi clear" back to default
hi TabLineFill term=NONE cterm=NONE

set splitbelow      "水平切割时，默认窗口在下面
set splitright      "垂直切割时，默认窗口在右边
set switchbuf=useopen,usetab,split	" split/switch buffer options

"set fdm=syntax        "  设置根据语法折叠
"set foldmethod=indent
"set foldlevel=99

" record marks of maximum number of files and maxium lines of register contents
"set viminfo='20,\"50
" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
""set shellslash
" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse latex-suite. Set your grep
" program to alway generate a file-name.
if executable('ack')
  set grepprg=ack\ -Hk\ $*
elseif executable('ag')
  set grepprg=ag\ --vimgrep\ $*
  set grepformat=%f:%l:%c:%m
else
  set grepprg=grep\ -nH\ $*
endif

" make the cursor always in the middle of window
set scrolloff=200

if has("cscope") && executable("cscope")
    "set csprg=/usr/bin/cscope
    set cscopetagorder=0
    set cscopetag
    set nocsverb
    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set csverb

    " find all functions calling a certain function
    map g<C-]> :cs find 3 <C-R>=expand("<cword>")<CR><CR>
    " find all occurrences of a particular C symbol
    map g<C-\> :cs find 0 <C-R>=expand("<cword>")<CR><CR>

    nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>

    " Using 'CTRL-spacebar' then a search type makes the vim window
    " split horizontally, with search result displayed in
    " the new window.

    nmap <C-Space>s :scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space>g :scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space>c :scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space>t :scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space>e :scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-Space>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-Space>d :scs find d <C-R>=expand("<cword>")<CR><CR>

    " Hitting CTRL-space *twice* before the search type does a vertical
    " split instead of a horizontal one

    nmap <C-Space><C-Space>s
        \:vert scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space><C-Space>g
        \:vert scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space><C-Space>c
        \:vert scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space><C-Space>t
        \:vert scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space><C-Space>e
        \:vert scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space><C-Space>i
        \:vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-Space><C-Space>d
        \:vert scs find d <C-R>=expand("<cword>")<CR><CR>

endif

" open Man page in seperate window,  \K :Man 3 strstr
runtime! ftplugin/man.vim

" Show trailing whitepace and spaces before a tab:
:highlight ExtraWhitespace ctermbg=red guibg=red
:autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/

" make previous insterted word all uppercase 
map! <C-F> <Esc>gUiw`]a
" switch on/off local buffer's spell-checking, using en_ca dictionary (z= zg ]s [s)
nmap <F5> :if &spell<Bar>setl nospell<Bar>else<Bar>setl spell spl=en_ca<Bar>endif<CR>
" insert current date & time into the buffer
" nmap <F11> a<C-R>=strftime("%c")<CR><Esc>
" confliction: F11 is the hot key to toggle full-screen in Gnome-terminal
nmap <F9> a<C-R>=strftime("%a %b %e %T %Z %Y")<CR><Esc>
imap <F9> <C-R>=strftime("%a %b %e %T %Z %Y")<CR>
" cmap <F12> set ml\|set mls=1\|if bufname("%")!=""\|e%\|en\|set mls=0<CR>
nmap <F12> :set ml\|set mls&vim\|if bufname("%")!=""\|e%\|en\|set mls=0<CR>

" some xterms doesn't clear the screen automatically
" cmap ,! to !clear; to clear the terminal before showing the command output
cmap ,! !clear;

" mapping {, (, [, ", ', ` to autocomplete the ending part
inoremap { {}<Esc>i
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap " ""<Esc>i
inoremap ' ''<Esc>i
inoremap ` ``<Esc>i

"设置netrw, 即通过Ex, Sex,Vex唤起的文件目录窗口
let g:netrw_winsize = 25

let g:UltiSnipsExpandTrigger="<C-t>"

"---------------------------gutentags配置
"" gutentags插件是管理ctags的工具，会自动增量更新ctags
" gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'
" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags
" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
" 检测 ~/.cache/tags 不存在就新建
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif

"-------------vim-go推荐的配置--------------------
" 保存文件时，阻止goimports自动运行
let g:go_imports_autosave=0
set autowrite
" let mapleader = ","
" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction
autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>c <Plug>(go-coverage-toggle)
"-------------vim-go推荐的配置结束----------------

" buf linter
let g:ale_linters = {
\   'proto': ['buf-lint',],
\}
let g:ale_lint_on_text_changed = 'never'
let g:ale_linters_explicit = 1

if filereadable(expand("~/.vim/coc.vimrc"))
  if v:version < 830
    let g:coc_disable_startup_warning = 1
  endif
  source ~/.vim/coc.vimrc
endif

" vim-plug是插件管理工具
" automatically install vim-plug if it's not installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin()
"if executable('ctags')
" ctags好伴侣，自动调用ctags生成tag，能够增量管理
Plug 'ludovicchabant/vim-gutentags'
"endif

" 安装强大的LSP客户端coc,用于自动补全，语法检查，定义跳转，支持各种语言
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" vim-go是golang的开发插件，项目地址：https://github.com/fatih/vim-go，帮助:help vim-go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" airline插件，花里胡哨的状态栏，用处不大
" Plug 'vim-airline/vim-airline'

" Tagbar类似于outline, 展示当前文件的函数，变量，类等声明
Plug 'preservim/tagbar'

" 查找文件和搜索字符的工具
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

if has("python3")
" 用于插入代码片段
" ultisnips是snippets的管理器
Plug 'SirVer/ultisnips'
" vim-snippets是具体snippets的定义，可添加自己定义的代码片段
Plug 'honza/vim-snippets'
endif

" support dart files
Plug 'dart-lang/dart-vim-plugin'

" database markup language
Plug 'jidn/vim-dbml'

" support buf
Plug 'dense-analysis/ale'
Plug 'bufbuild/vim-buf'

" bufexplorer
Plug 'jlanzarotta/bufexplorer'

" svelte, javascript, typescript
Plug 'evanleck/vim-svelte'
Plug 'pangloss/vim-javascript'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'codechips/coc-svelte', {'do': 'npm install'}

call plug#end()

" run :PlugInstall after adding new plugins above
