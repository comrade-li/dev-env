# Debian12 Server配置文档

## 1. 基本环境配置

### 1.1 静态IP设置

按照需求修改`/etc/network/interfaces`如下：

```shell
allow-hotplug enp1s0
iface enp1s0 inet static
  address 192.168.1.20/24
  gateway 192.168.1.1
  dns-nameservers 192.168.1.1
  dns-search server
```

### 1.2 软件源和包管理(root)

1.备份传统格式源

```shell
mv /etc/apt/sources.list /etc/apt/sources.list.bak
```

2.设置DEB822源，以清华大学源为例

```shell
echo 'Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/debian
Suites: bookworm bookworm-updates bookworm-backports
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/debian-security
Suites: bookworm-security
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg' | tee /etc/apt/sources.list.d/debian.sources
```

3.更新源并升级

```shell
apt update && apt upgrade -y
```

4.管理软件包

```shell
apt install -y sudo vim git build-essential curl openssh-server cmake ninja-build && apt remove -y vim-tiny && apt autoremove -y
```

### 1.3 配置vim

```shell
echo 'set nocompatible
syntax on
set showmode
set showcmd
set encoding=utf-8
set t_Co=256
filetype indent on
set autoindent
set tabstop=2
set shiftwidth=2
set expandtab
set softtabstop=2
set number
set textwidth=120
set nowrap
set wrapmargin=2
set scrolloff=5
set sidescrolloff=15
set laststatus=2
set ruler
set showmatch
set hlsearch
set incsearch
set ignorecase
set smartcase
set nobackup
set noswapfile
set noerrorbells
set wildmenu
set wildmode=longest:list,full' | tee ~/.vimrc
```

### 1.4 配置sudo

根据环境中的用户配置。

```shell
vim /etc/sudoers
```

### 1.5 环境语言和编码警告处理

一般环境中可能会出现LANGUAGE(unset)和LC_ALL(unset)的情况，根据情况在`/etc/default/locale`文件中添加以下内容：

```text
LANGUAGE="en_US:en"
LC_ALL="en_US.UTF-8"
```

然后再生成配置：

```shell
sudo locale-gen && sudo dpkg-reconfigure locales
```

### 1.6 ssh和git配置

```shell
ssh-keygen -t rsa -b4096 -C "comrade.lijing@gmail.com" && cat ~/.ssh/id_rsa.pub
```

```shell
git config --global user.email "comrade.lijing@gmail.com" && git config --global user.name "Comrade Li"
```

### 1.7 Java环境配置

```shell
echo '
JAVA_HOME=~/.softwares/java/current

PATH=$PATH:$JAVA_HOME/bin

export PATH JAVA_HOME' | sudo tee -a /etc/profile
```
