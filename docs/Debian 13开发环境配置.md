# Debian 13开发环境配置

## 1. 权限及挂载硬盘

### 1.1 将当前用户加入root权限

```shell
su root -c 'sed -i "s|^root\s\+ALL=(ALL:ALL)\s\+ALL$|root    ALL=(ALL:ALL) ALL\n$USER    ALL=(ALL:ALL) ALL|g" /etc/sudoers'
```

### 1.2 挂载硬盘

```shell
sudo mkdir -p /datas && 
sudo chown ${USER} /datas && 
sudo mount /dev/sda /datas && 
echo '
UUID=3423735e-f5b8-4e70-b3ed-aa67ec474d19     /datas      btrfs   defaults,user     0     0' | sudo tee -a /etc/fstab
```

## 2. 基础软件安装

### 2.1 配置源

```shell
sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak && 
echo 'Types: deb
URIs: http://mirrors.ustc.edu.cn/debian
Suites: trixie trixie-updates
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb
URIs: http://mirrors.ustc.edu.cn/debian-security
Suites: trixie-security
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg' | sudo tee /etc/apt/sources.list.d/debian.sources
```

### 2.2 卸载无用包、更新包、安装基础包

```shell
sudo apt purge -y gnome-calendar gnome-contacts gnome-weather gnome-clocks gnome-maps gnome-music simple-scan totem malcontent gnome-tour shotwell gnome-sound-recorder evolution gnome-software gnome-text-editor im-config vim-tiny nano xterm gnome-snapshot gnome-characters gnome-connections libreoffice-* && 
sudo apt autoremove --purge -y && 
sudo apt update && 
sudo apt upgrade -y && 
sudo apt install -y curl wget openssh-server iputils-arping traceroute net-tools iproute2 bind9-dnsutils tcpdump gpg openssl libssl-dev git git-lfs vim tree zsh ibus-rime build-essential libgmp-dev libmpfr-dev libmpc-dev libisl-dev binutils linux-headers-amd64 gdb autoconf ninja-build python3 python3-venv python3-dev python3-pip lua5.4 tk-dev pkg-config lm-sensors fancontrol i2c-tools
```

### 2.3 安装LLVM

```shell
sudo apt install -y llvm llvm-dev llvm-runtime clang clang-tools clang-format clang-tidy python3-clang lldb lld libc++-dev libc++-dev libomp-dev
```

### 2.4 安装并配置KVM

```shell
sudo apt install -y qemu-system-x86 virt-manager libvirt-daemon-system virtinst libvirt-clients bridge-utils virtiofsd
```

```shell
sudo systemctl enable libvirtd && sudo usermod -aG kvm ${USER} && sudo usermod -aG libvirt ${USER} && 
mkdir -p ~/KVM/images
```

### 2.5 安装并配置wireshark

```shell
sudo apt install -y wireshark
```

```shell
sudo chgrp wireshark /usr/bin/dumpcap && sudo chmod 4755 /usr/bin/dumpcap && sudo gpasswd -a ${USER} wireshark
```

### 2.6 安装vlc

```shell
sudo apt install -y vlc
```

### 2.7 安装yaru-theme和dash-to-dock插件

```shell
sudo apt install -y gnome-shell-extension-user-theme gtk2-engines-pixbuf gtk2-engines-murrine gnome-themes-extra && 
sudo dpkg -i /datas/debs/session-migration*.deb && 
sudo dpkg -i /datas/debs/yaru-theme-*.deb && 
sudo apt install -y gnome-shell-extension-dashtodock
```

## 3. 系统配置

### 3.1 设置系统语言

```shell
echo 'LANG="en_US.UTF-8"
LANGUAGE="en_US:en"
LC_ALL="en_US.UTF-8"' | sudo tee /etc/default/locale && sudo update-locale
```

### 3.2 设置grub取消选择启动项等待

```shell
sudo cp /etc/default/grub /etc/default/grub.blk && 
sudo sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub && 
sudo update-grub
```

### 3.3 设置登录缩放与当前一致

```shell
sudo cp ~/.config/monitors.xml /var/lib/gdm3/.config
```

### 3.4 TeXLive、Java、go、rust、C/C++、python开发环境搭建

#### 3.4.1 TexLive环境搭建

```shell
echo '
# TeX Live
export PATH=/usr/local/texlive/2026/bin/x86_64-linux:$PATH
export MANPATH=/usr/local/texlive/2026/texmf-dist/doc/man:$MANPATH
export INFOPATH=/usr/local/texlive/2026/texmf-dist/doc/info:$INFOPATH' | tee -a ~/.profile
```

```shell
sudo mount /datas/softwares/texlive2026.iso /media/cdrom && 
sudo /media/cdrom/install-tl && 
sudo umount /media/cdrom
```

#### 3.4.2 Java开发环境(jdk、maven、mvnd、gradle、visualvm、jmeter)

```shell
echo '
# JDK
export JAVA_HOME=~/.softwares/java/current
export PATH=$JAVA_HOME/bin:$PATH' | tee -a ~/.profile && 
mkdir -p ~/.softwares/java/oracle ~/.softwares/java/liberica ~/.softwares/java/adoptium && 
tar -zxf /datas/softwares/jdk-21*.tar.gz -C ~/.softwares/java/oracle && 
tar -zxf /datas/softwares/jdk-25*.tar.gz -C ~/.softwares/java/oracle && 
tar -zxf /datas/softwares/bellsoft-jdk21*.tar.gz -C ~/.softwares/java/liberica && 
tar -zxf /datas/softwares/bellsoft-jdk25*.tar.gz -C ~/.softwares/java/liberica && 
tar -zxf /datas/softwares/OpenJDK21*.tar.gz -C ~/.softwares/java/adoptium && 
tar -zxf /datas/softwares/OpenJDK25*.tar.gz -C ~/.softwares/java/adoptium && 
ln -sf ~/.softwares/java/oracle/jdk-25* ~/.softwares/java/current
```

```shell
echo '
# maven
export PATH=~/.softwares/maven/bin:$PATH
# mvnd
export PATH=~/.softwares/mvnd/bin:$PATH' | tee -a ~/.profile && 
tar -zxf /datas/softwares/apache-maven*.tar.gz -C ~/.softwares && 
mv ~/.softwares/apache-maven-* ~/.softwares/maven && 
tar -zxf /datas/softwares/maven-mvnd*.tar.gz -C ~/.softwares && 
mv ~/.softwares/maven-mvnd-* ~/.softwares/mvnd
```

```shell
echo '
# gradle
export PATH=~/.softwares/gradle/bin:$PATH' | tee -a ~/.profile && 
unzip -qq /datas/softwares/gradle*.zip -d ~/.softwares && 
mv ~/.softwares/gradle-* ~/.softwares/gradle
```

```shell
echo '
# visualvm
export PATH=~/.softwares/visualvm/bin:$PATH' | tee -a ~/.profile && 
unzip -qq /datas/softwares/visualvm*.zip -d ~/.softwares && 
mv ~/.softwares/visualvm* ~/.softwares/visualvm
```

```shell
echo '
# jmeter
export PATH=~/.softwares/jmeter/bin:$PATH' | tee -a ~/.profile && 
tar -zxf /datas/softwares/apache-jmeter*.tgz -C ~/.softwares && 
mv ~/.softwares/apache-jmeter* ~/.softwares/jmeter
```

#### 3.4.3 go开发环境

```shell
echo '
# go
export GOROOT=~/.softwares/go/current
export PATH=$GOROOT/bin:$PATH' | tee -a ~/.profile && 
tar -zxf /datas/softwares/go1.26*.tar.gz -C ~/.softwares/go --transform="s/go/"$(basename -s .tar.gz "$(find /datas/softwares -name "go1.26*")")"/" && 
tar -zxf /datas/softwares/go1.25*.tar.gz -C ~/.softwares/go --transform="s/go/"$(basename -s .tar.gz "$(find /datas/softwares -name "go1.25*")")"/" && 
ln -sf ~/.softwares/go/go1.26* ~/.softwares/go/current
```

#### 3.4.4 rust开发环境

```shell
echo '
# custom rust install path
export CARGO_HOME=~/.softwares/rust/cargo
export RUSTUP_HOME=~/.softwares/rust/rustup
export PATH=$CARGO_HOME/bin:$PATH' | tee -a ~/.profile && 
source ~/.profile
```

```shell
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

#### 3.4.5 C/C++开发环境(cmake、clangd)

```shell
echo '
# cmake
export PATH=~/.softwares/cmake/bin:$PATH
# clangd
export PATH=~/.softwares/clangd/bin:$PATH' | tee -a ~/.profile && 
tar -zxf /datas/softwares/cmake*.tar.gz -C ~/.softwares && 
mv ~/.softwares/cmake-* ~/.softwares/cmake && 
unzip -qq /datas/softwares/clangd-linux-*.zip -d ~/.softwares && 
mv ~/.softwares/clangd_* ~/.softwares/clangd
```

#### 3.4.6 配置python venv环境

```shell
python3 -m venv ~/.softwares/python_venv
```

### 3.5 配置SSH密钥对、git

```shell
ssh-keygen -t rsa -b4096 -C "comrade.lijing@gmail.com" && cat ~/.ssh/id_rsa.pub
```

```shell
git config --global user.email "comrade.lijing@gmail.com" && git config --global user.name "Comrade Li"
```

## 4. 桌面环境配置

### 4.1 拉取个人配置

```shell
git clone git@github.com:comrade-li/dev-env.git ~/Projects/dev-env
```

### 4.2 设置字体

#### 4.2.1 安装字体

```shell
sudo cp -r /datas/fonts/* /usr/share/fonts/truetype 
```

选择安装Twitter Color Emoji

```shell
sudo apt install -y ttf-bitstream-vera && 
sudo dpkg -i /datas/debs/fonts-twemoji-svginot*.deb
```

#### 4.2.2 设置系统字体

```shell
mkdir -p ~/.config/fontconfig && 
ln -sf ~/Projects/dev-env/configs/fonts.conf ~/.config/fontconfig/fonts.conf && 
sudo fc-cache -f && fc-cache -f
gsettings set org.gnome.desktop.interface font-antialiasing 'rgba' && 
gsettings set org.gnome.desktop.interface font-hinting 'none' && 
gsettings set org.gnome.desktop.interface font-rgba-order 'rgb' && 
gsettings set org.gnome.desktop.interface font-name 'Inter 13' && 
gsettings set org.gnome.desktop.interface document-font-name 'Noto Sans 13' && 
gsettings set org.gnome.desktop.interface monospace-font-name 'SF Mono 15'
```

### 4.3 配置vim

```shell
sudo ln -sf ~/Projects/ev-env/configs/.vimrc /root/.vimrc && ln -sf ~/Projects/dev-env/configs/.vimrc ~/.vimrc
```

### 4.4 设置用户头像、终端、主题、快捷键、禁用Caps

```shell
sudo cp ~/Projects/dev-env/configs/avatars/* /usr/share/pixmaps/faces
```

```shell
dconf load /org/gnome/terminal/ < ~/Projects/dev-env/configs/gnome-settings/gnome-terminal-settings.dconf && 
dconf load /org/gnome/settings-daemon/plugins/ < ~/Projects/dev-env/configs/gnome-settings/color-keys-power-settings.dconf && 
dconf load /org/gnome/desktop/ < ~/Projects/dev-env/configs/gnome-settings/desktop.dconf && 
dconf load /org/gnome/mutter/ < ~/Projects/dev-env/configs/gnome-settings/mutter.dconf && 
dconf load /org/gnome/shell/app-switcher/ < ~/Projects/dev-env/configs/gnome-settings/app-switcher.dconf && 
dconf load /org/gnome/nautilus/ < ~/Projects/dev-env/configs/gnome-settings/nautilus.dconf && 
dconf load /org/gtk/gtk4/settings/file-chooser/ < ~/Projects/dev-env/configs/gnome-settings/file-chooser.dconf && 
dconf load /org/virt-manager/ < ~/Projects/dev-env/configs/gnome-settings/virt-manager.dconf && 
gsettings set org.gnome.Settings window-state '(1700, 1100, false)'
```

### 4.5 安装配置oh-my-zsh

#### 4.5.1 安装oh-my-zsh

```shell
git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
```

#### 4.5.2 安装插件

```shell
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
```

```shell
git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/plugins/zsh-autosuggestions
```

```shell
git clone --depth 1 https://github.com/zsh-users/zsh-completions.git ~/.oh-my-zsh/plugins/zsh-completions
```

#### 4.5.3 配置~/.zshrc并更换默认sh为zsh

```shell
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && 
sed -i 's/plugins=(git)/plugins=(\n  git\n  sudo\n  zsh-completions\n  zsh-autosuggestions\n  zsh-syntax-highlighting\n)\n\nsource ~\/.profile\nsource ~\/.softwares\/python_venv\/bin\/activate\n\nsetopt nonomatch/g' ~/.zshrc && 
chsh -s $(which zsh)
```

### 4.6 安装配置雾凇拼音

```shell
git clone --depth 1 https://github.com/iDvel/rime-ice.git ~/.config/ibus/rime
```

```shell
sed -i "s|page_size: 5|page_size: 7|g" ~/.config/ibus/rime/default.yaml
```

## 5. 安装常用软件

### 5.1 安装Chrome

```shell
wget -qO- https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor | sudo tee /usr/share/keyrings/google-chrome-keyring.gpg > /dev/null
```

```shell
echo 'Types: deb
URIs: http://dl.google.com/linux/chrome/deb/
Suites: stable
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/google-chrome-keyring.gpg' | sudo tee /etc/apt/sources.list.d/google-chrome.sources
```

```shell
sudo apt update && 
sudo apt install -y google-chrome-stable && 
sudo rm -rf /etc/apt/sources.list.d/google-chrome.list
```

### 5.2 安装VSCode

```shell
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft.gpg > /dev/null
```

```shell
echo 'Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/microsoft.gpg' | sudo tee /etc/apt/sources.list.d/vscode.sources
```

```shell
sudo apt update &&
sudo apt install -y code
```

### 5.3 安装firefox

```shell
wget -qO- https://packages.mozilla.org/apt/repo-signing-key.gpg | sudo tee /usr/share/keyrings/mozilla.gpg > /dev/null
```

```shell
echo 'Types: deb
URIs: https://packages.mozilla.org/apt
Suites: mozilla
Components: main
Signed-By: /usr/share/keyrings/mozilla.gpg' | sudo tee /etc/apt/sources.list.d/mozilla.sources
```

```shell
echo 'Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000' | sudo tee /etc/apt/preferences.d/mozilla
```

`复制这条命令后先关闭firefox-esr浏览器！`

```shell
sudo apt purge -y firefox-esr && 
sudo apt autoremove --purge -y && 
rm -rf ~/.face ~/.face.icon ~/.mozilla ~/.cache/mozilla ~/.bash_history ~/.config/evolution ~/.cache/evolution ~/.local/share/evolution && 
sudo apt update && 
sudo apt install -y firefox
```

### 5.4 Postman安装与配置

```shell
tar -zxf /datas/softwares/postman-linux-x64.tar.gz -C ~/.softwares && 
cp ~/Projects/dev-env/configs/desktop-files/postman.desktop ~/.local/share/applications && 
desktop-file-install ~/.local/share/applications/postman.desktop --dir=~/.local/share/applications/postman.desktop
```
