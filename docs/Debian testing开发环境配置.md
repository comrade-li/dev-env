# Debian testing开发环境配置

## 1. 配置sudo

切换到root(`su -`)用户下:

```shell
vi /etc/sudoers
```

## 2. 配置国内源

1.备份传统格式源

```shell
sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak
```

2.设置DEB822源，以清华大学源为例

```shell
echo 'Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/debian
Suites: testing testing-updates testing-backports
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/debian-security
Suites: testing-security
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg' | sudo tee /etc/apt/sources.list.d/debian.sources
```

3.更新源并升级

```shell
sudo apt update && sudo apt upgrade -y
```

## 3. 软件包管理

1.卸载无用软件

```shell
sudo apt remove -y evolution gnome-contacts gnome-tour libreoffice-gtk3 libreoffice-uiconfig-draw simple-scan evolution-ews gnome-core gnome-weather libreoffice-help-common libreoffice-uiconfig-impress task-gnome-desktop evolution-plugin-bogofilter gnome-maps im-config evolution-plugin-pstimport gnome-music libreoffice-base-core libreoffice-impress libreoffice-uiconfig-writer totem-plugins evolution-plugins gnome-software libreoffice-calc libreoffice-math libreoffice-writer vim-tiny gnome gnome-software-plugin-deb libreoffice-common libreoffice-style-colibre malcontent gnome-calendar gnome-software-plugin-fwupd libreoffice-core libreoffice-style-elementary malcontent-gui gnome-clocks gnome-sound-recorder libreoffice-draw libreoffice-uiconfig-calc python3-uno gnome-connections gnome-text-editor libreoffice-gnome libreoffice-uiconfig-common shotwell xterm && sudo apt autoremove -y
```

2.安装字体库

```shell
sudo apt install -y fonts-arphic-ukai fonts-arphic-uming fonts-dejavu-core fonts-dejavu-mono fonts-droid-fallback fonts-liberation-sans-narrow fonts-liberation fonts-noto-cjk-extra fonts-noto-cjk fonts-noto-color-emoji fonts-noto-core fonts-noto-mono fonts-ubuntu fonts-urw-base35
```

3.安装yaru theme包

```shell
sudo apt install -y yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon yaru-theme-sound yaru-theme-unity
```

4.安装基础环境

```shell
sudo apt install -y git vim zsh ibus-rime openssh-server curl build-essential cmake autoconf ninja-build tcl tk tcl-dev tk-dev gnome-tweaks gnome-shell-extensions gnome-disk-utility gnome-calculator gnome-system-monitor gnome-shell-extension-user-theme gnome-shell-extension-dashtodock
```

5.安装llvm

```shell
sudo apt install -y clang-format clang-tidy clang-tools clang clangd libc++-dev libc++1 libc++abi-dev libc++abi1 libclang-dev libclang1 liblldb-dev libllvm-ocaml-dev libomp-dev libomp5 lld lldb llvm-dev llvm-runtime llvm python3-clang
```

6.安装并配置KVM

```shell
sudo apt install -y qemu-system-x86 virt-manager libvirt-daemon-system virtinst libvirt-clients bridge-utils
```

```shell
sudo systemctl enable --now libvirtd && sudo systemctl start libvirtd && sudo usermod -aG kvm ${USER} && sudo usermod -aG libvirt ${USER}
```

7.安装并配置wireshark

```shell
sudo apt install -y wireshark
```

```shell
sudo chgrp wireshark /usr/bin/dumpcap && sudo chmod 4755 /usr/bin/dumpcap && sudo gpasswd -a ${USER} wireshark
```

8.安装vlc

```shell
sudo apt install -y vlc
```

## 4. 配置环境变量

```shell
echo '
export PATH=/usr/local/texlive/2024/bin/x86_64-linux:$PATH
export MANPATH=/usr/local/texlive/2024/texmf-dist/doc/man:$MANPATH
export INFOPATH=/usr/local/texlive/2024/texmf-dist/doc/info:$INFOPATH

JAVA_HOME=~/.softwares/java/current
GRADLE_HOME=~/.softwares/gradle/current
MAVEN_HOME=~/.softwares/maven/current
JMETER_HOME=~/.softwares/jmeter
VISUALVM_HOME=~/.softwares/visualvm

PATH=$JAVA_HOME/bin:$GRADLE_HOME/bin:$MAVEN_HOME/bin:$JMETER_HOME/bin:$VISUALVM_HOME/bin:$PATH

export JAVA_HOME GRADLE_HOME MAVEN_HOME JMETER_HOME VISUALVM_HOME PATH' | tee -a ~/.profile
```

## 5. 配置SSH和git

1.配置SSH

```shell
ssh-keygen -t rsa -b4096 -C "comrade.lijing@gmail.com" && cat ~/.ssh/id_rsa.pub
```

2.配置git

```shell
git config --global user.email "comrade.lijing@gmail.com" && git config --global user.name "Comrade Li"
```

## 6.配置oh-my-zsh

1.下载

```shell
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
```

2.安装插件

```shell
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
```

```shell
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/plugins/zsh-autosuggestions
```

3.配置~/.zshrc

```shell
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && 
sed -i 's/plugins=(git)/plugins=(\n  git\n  zsh-autosuggestions\n  zsh-syntax-highlighting\n)\nsource ~\/.profile/g' ~/.zshrc
```

4.更换默认sh为zsh

```shell
chsh -s $(which zsh)
```

## 7.配置输入法oh-my-rime

1.下载

```shell
git clone https://github.com/Mintimate/oh-my-rime.git ~/.config/ibus/rime
```

2.修改配置

```shell
cp ~/.config/ibus/rime/ibus_rime.yaml ~/.config/ibus/rime/user.yaml.bak && 
cp ~/.config/ibus/rime/rime_mint.schema.yaml ~/.config/ibus/rime/rime_mint.schema.yaml.bak && 
sed -i 's/  horizontal: true/  horizontal: false/g' ~/.config/ibus/rime/ibus_rime.yaml && 
sed -i '/^  - name: emoji_suggestion/,+2d' ~/.config/ibus/rime/rime_mint.schema.yaml
```

## 8. 安装字体

```shell
git clone git@github.com:comrade-li/dev-env.git ~/Projects/dev-env
```

```shell
cd ~/Projects/dev-env/fonts && 
sudo tar -xJf sarasa-ui-sc.tar.xz -C /usr/share/fonts/truetype && 
sudo tar -xJf jetbrains-mono.tar.xz -C /usr/share/fonts/truetype && 
sudo tar -xJf fira-code.tar.xz -C /usr/share/fonts/truetype && 
sudo tar -xJf hack.tar.xz -C /usr/share/fonts/truetype && 
sudo tar -xJf intel-one-mono.tar.xz -C /usr/share/fonts/truetype && 
sudo tar -xJf lxgw-wenkai-mono.tar.xz -C /usr/share/fonts/truetype && 
sudo tar -xJf source-code-pro.tar.xz -C /usr/share/fonts/truetype && 
sudo tar -xJf sf-mono.tar.xz -C /usr/share/fonts/truetype && 
sudo tar -xJf inter.tar.xz -C /usr/share/fonts/truetype && 
sudo tar -xJf courier-prime.tar.xz -C /usr/share/fonts/truetype && 
sudo tar -xJf courier-new.tar.xz -C /usr/share/fonts/truetype && 
sudo tar -xJf times-new-roman.tar.xz -C /usr/share/fonts/truetype && 
sudo fc-cache -f && fc-cache -f
```

## 9. 配置vim

```shell
sudo cp ~/Projects/dev-env/config/.vimrc /root/ && cp ~/Projects/dev-env/config/.vimrc ~/
```

## 10. 常用工具

1.PDF工具`pdftk-java`

```shell
sudo apt install -y pdftk-java
```
