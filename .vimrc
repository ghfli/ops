
"本配置常用快捷键说明:
"<tab>             自动补全，或者snippets
"gd                跳转到定义
"gr                跳转到引用
"\a                执行代码修正
"\ac               对当前Buffer执行代码修正
"\qf               quick fix，快速代码修正
"\f                格式化选中内容
"
"rn                用于重命名
"sn                跳转到下一条错误语句
"sp                跳转到上一条错误语句
"
":OR               自动导入包
":Format           格式化
"
"<space>a          打开诊断列表
"<space>t          打开tagbar
"<space>o          查找文件
"<space>f          查找字符
"
"<C-j>/<C-k>       在snippets的替换模块间移动
"
"------------------vim基本属性配置
set nocompatible " be iMproved
" set exrc         " run .vimrc in the local directory
" colorscheme ron  " also try industry, torte, default
set number       " 显示行号
set confirm      " 在处理未保存或只读文件的时候，弹出确认

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

set hlsearch          " 搜索时，高亮显示匹配结果
" set incsearch       " 输入搜索模式时，每输入一个字符，就自动跳到第一个匹配的结果。
"syntax on

set splitbelow      "水平切割时，默认窗口在下面
set splitright      "垂直切割时，默认窗口在左边

" set fdm=syntax        "  设置根据语法折叠

"设置netrw, 即通过Ex, Sex,Vex唤起的文件目录窗口
let g:netrw_winsize = 25

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

" ---------------------vim-go配置
" 保存文件时，阻止goimports自动运行
let g:go_imports_autosave=0

" -------------------------FZF配置
nnoremap <silent><nowait> <space>o :<C-u>FZF<CR>
" nnoremap <silent><nowait> <space>f :<C-u>Rg<CR>
nnoremap <silent><nowait> <space>f :<C-u>Ag<CR>
" let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
let g:fzf_layout = { 'down': '40%' }
" -------------------------tagbar配置
nnoremap <silent><nowait> <space>t :<C-u>TagbarToggle<CR>
let g:tagbar_width=25
"打开时自动获取焦点
let g:tagbar_autofocus=1

let g:UltiSnipsExpandTrigger="<C-t>"
"-------------coc.nvim推荐的配置--------------------
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

"在输入一部分字符的情况下，用tab来自动补全
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" 用Ctrl @来主动触发自动补全
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-@> coc#refresh()

" 回车时，选择自动补全窗口的第一项
" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> sp <Plug>(coc-diagnostic-prev)
nmap <silent> sn <Plug>(coc-diagnostic-next)

" 几个非常重要的定义跳转键,gd, gr
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" K用于显示文档
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
" autocmd CursorHold * silent call CocActionAsync('highlight')

" rn键用于重命名
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" leader f，默认就是\f，格式化代码
" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" 修正代码的快捷键，如自动引入
" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
"-------------coc.nvim推荐的配置结束----------------

"-------------vim-go推荐的配置--------------------
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

" Show trailing whitepace and spaces before a tab:
:highlight ExtraWhitespace ctermbg=red guibg=red
:autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/

" mapping {, (, [, ", ', ` to autocomplete the ending part
inoremap { {}<Esc>i
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap " ""<Esc>i
inoremap ' ''<Esc>i
inoremap ` ``<Esc>i

" buf linter
let g:ale_linters = {
\   'proto': ['buf-lint',],
\}
let g:ale_lint_on_text_changed = 'never'
let g:ale_linters_explicit = 1

" vim-plug是插件管理工具
" automatically install vim-plug if it's not installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin()
" ctags好伴侣，自动调用ctags生成tag，能够增量管理
Plug 'ludovicchabant/vim-gutentags'

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

" 用于插入代码片段
" ultisnips是snippets的管理器
Plug 'SirVer/ultisnips'
" vim-snippets是具体snippets的定义，可添加自己定义的代码片段
Plug 'honza/vim-snippets'

" support dart files
Plug 'dart-lang/dart-vim-plugin'

" database markup language
Plug 'jidn/vim-dbml'

" support buf
Plug 'dense-analysis/ale'
Plug 'bufbuild/vim-buf'

" bufexplorer
Plug 'jlanzarotta/bufexplorer'

call plug#end()

" run :PlugInstall after adding new plugins above
