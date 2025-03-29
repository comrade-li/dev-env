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
sudo apt remove -y libreoffice-gtk3 libreoffice-uiconfig-draw libreoffice-help-common libreoffice-uiconfig-impress libreoffice-base-core libreoffice-impress libreoffice-uiconfig-writer libreoffice-calc libreoffice-math libreoffice-writer libreoffice-common libreoffice-style-colibre libreoffice-core libreoffice-style-elementary libreoffice-draw libreoffice-uiconfig-calc libreoffice-gnome libreoffice-uiconfig-common gnome-calendar gnome-contacts gnome-weather gnome-clocks gnome-maps totem im-config simple-scan malcontent seahorse gnome-music shotwell gnome-sound-recorder  gnome-text-editor gnome-tour evolution gnome-software vim-tiny xterm && sudo apt autoremove -y
```

2.安装字体库

```shell
sudo apt install -y fonts-arphic-ukai fonts-arphic-uming fonts-dejavu-core fonts-dejavu-mono fonts-droid-fallback fonts-liberation-sans-narrow fonts-liberation fonts-noto-cjk-extra fonts-noto-cjk fonts-noto-color-emoji fonts-noto-core fonts-noto-mono fonts-ubuntu fonts-urw-base35
```

3.安装基础环境

```shell
sudo apt install -y git vim zsh ibus-rime openssh-server curl build-essential cmake autoconf ninja-build tcl tk tcl-dev tk-dev gnome-shell-extension-dashtodock
```

4.安装llvm

```shell
sudo apt install -y clang-format clang-tidy clang-tools clang clangd libc++-dev libc++1 libc++abi-dev libc++abi1 libclang-dev libclang1 liblldb-dev libllvm-ocaml-dev libomp-dev libomp5 lld lldb llvm-dev llvm-runtime llvm python3-clang
```

5.安装并配置KVM

```shell
sudo apt install -y qemu-system-x86 virt-manager libvirt-daemon-system virtinst libvirt-clients bridge-utils
```

```shell
sudo systemctl enable --now libvirtd && sudo systemctl start libvirtd && sudo usermod -aG kvm ${USER} && sudo usermod -aG libvirt ${USER}
```

6.安装并配置wireshark

```shell
sudo apt install -y wireshark
```

```shell
sudo chgrp wireshark /usr/bin/dumpcap && sudo chmod 4755 /usr/bin/dumpcap && sudo gpasswd -a ${USER} wireshark
```

7.安装vlc

```shell
sudo apt install -y vlc
```

8.Debian 12卸载无用包

```shell
sudo apt remove gnome-2048 gnome-contacts gnome-weather gnome-clocks gnome-maps aisleriot gnome-calendar totem gnome-chess simple-scan five-or-more four-in-a-row hitori cheese gnome-klotski libreoffice-* lightsoff gnome-mahjongg gnome-mines gnome-music gnome-nibbles quadrapassel im-config iagno rhythmbox gnome-robots shotwell gnome-sound-recorder gnome-sudoku swell-foop synaptic tali gnome-taquin gnome-tetravex transmission-gtk evolution gnome-software
```

## 4. 配置环境变量

```shell
echo '
export PATH=/usr/local/texlive/2025/bin/x86_64-linux:$PATH
export MANPATH=/usr/local/texlive/2025/texmf-dist/doc/man:$MANPATH
export INFOPATH=/usr/local/texlive/2025/texmf-dist/doc/info:$INFOPATH

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
sudo tar -xJf arial.tar.xz -C /usr/share/fonts/truetype && 
sudo tar -xJf calibri.tar.xz -C /usr/share/fonts/truetype && 
sudo tar -xJf cambria.tar.xz -C /usr/share/fonts/truetype && 
sudo tar -xJf consolas.tar.xz -C /usr/share/fonts/truetype && 
sudo tar -xJf georgia.tar.xz -C /usr/share/fonts/truetype && 
sudo tar -xJf microsoft-jhenghei-ui.tar.xz -C /usr/share/fonts/truetype && 
sudo tar -xJf microsoft-yahei-ui.tar.xz -C /usr/share/fonts/truetype && 
sudo tar -xJf segoe-ui.tar.xz -C /usr/share/fonts/truetype && 
sudo tar -xJf selawik.tar.xz -C /usr/share/fonts/truetype && 
sudo tar -xJf simsun.tar.xz -C /usr/share/fonts/truetype && 
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

## 11. 配置Eclipse

```shell
cp ~/Projects/dev-env/config/spring-tool-suite-4.desktop ~/.local/share/applications && 
sudo desktop-file-install ~/.local/share/applications/spring-tool-suite-4.desktop
```
