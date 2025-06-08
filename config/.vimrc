" 语法高亮
syntax on

" 不与vi兼容
set nocompatible

" 显示行号
set number

" 启用256色
set t_Co=256

" 是否显示状态栏: 0 表示不显示; 1 表示只在多窗口时显示; 2 表示显示
set laststatus=2
" 在状态栏显示光标的当前位置
set  ruler
" 底栏显示当前模式
set showmode
set showcmd

" 支持鼠标
" set mouse=a

" 设置编码
set encoding=UTF-8
set termencoding=UTF-8
set fileencodings=UTF-8,gbk,gb18030,gb2312

" 缩进
set tabstop=4
set shiftwidth=4
set tabstop=4
set noexpandtab
set softtabstop=-1
set smarttab
" 自动缩进，与上一行相同
set autoindent
set smartindent
set cindent

" 缩进规则载人
filetype indent on

" 行宽
set textwidth=120
set nowrap
" 只有遇到指定的符号折行,不会在单词内部折行
set linebreak
" 指定折行处与编辑窗口的右边缘之间空出的字符数
set wrapmargin=2
" 垂直滚动时,光标距离顶部/底部的位置
set scrolloff=5
" 水平滚动时,光标距离行首或行尾的位置
set sidescrolloff=15

" 搜索匹配和高亮
set showmatch
set hlsearch
set incsearch
" 忽略大小写
set ignorecase
set smartcase

" 备份文件与交换文件
set nobackup
set noswapfile
set noundofile
set history=1000

" 关闭出错响铃
set errorbells
set visualbell

" 打开文件监视,如果在编辑过程中文件发生外部改变就会发出提示
set autoread

" 命令模式Tab键自动补全
set wildmenu
set wildmode=longest:list,full

" 括号自动补齐
inoremap ( ()<LEFT>
inoremap [ []<LEFT>
inoremap { {}<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
inoremap < <><LEFT>