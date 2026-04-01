# Debian 13开发环境配置

1. 将当前用户加入root权限

    ```shell
    su - root
    vi /etc/sudoers
    ```

2. 挂载硬盘

    ```shell
    sudo mkdir -p /datas && 
    sudo chown ${USER} /datas && 
    sudo mount /dev/sda1 /datas && 
    echo '
    UUID=bc14161f-d0e7-4474-8b13-6f3ee84488f3     /datas      btrfs   defaults,user     0     0' | sudo tee -a /etc/fstab
    ```

3. 配置源

    ```shell
    sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak && 
    echo 'Types: deb
    URIs: https://mirrors.ustc.edu.cn/debian
    Suites: trixie trixie-updates
    Components: main contrib non-free non-free-firmware
    Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

    Types: deb
    URIs: https://mirrors.ustc.edu.cn/debian-security
    Suites: trixie-security
    Components: main contrib non-free non-free-firmware
    Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg' | sudo tee /etc/apt/sources.list.d/debian.sources
    ```

4. 卸载无用包并更新包

    ```shell
    sudo apt remove -y gnome-calendar gnome-contacts gnome-weather gnome-clocks gnome-maps gnome-music simple-scan libreoffice-* totem malcontent gnome-tour shotwell gnome-sound-recorder evolution evolution-data-server gnome-software gnome-text-editor im-config vim-tiny nano xterm && 
    sudo apt autoremove -y && 
    sudo apt update && 
    sudo apt upgrade -y
    ```

5. 基础包安装

    ```shell
    sudo apt install -y git git-lfs vim tree zsh ibus-rime openssh-server gpg curl build-essential gdb autoconf ninja-build python3-pip python3-dev tcpdump tcl tk lm-sensors fancontrol i2c-tools
    ```

6. 安装LLVM

    ```shell
    sudo apt install -y libllvm-ocaml-dev libllvm22 llvm llvm-dev llvm-runtime clang clang-tools libclang-dev libclang1 clang-format python3-clang clang-tidy libclang-rt-dev lldb lld libc++-dev libc++abi-dev libomp-dev libbolt-dev bolt flang libclang-rt-dev-wasm32 libclang-rt-dev-wasm64 libc++-dev-wasm32 libclang-rt-dev-wasm32 libclang-rt-dev-wasm64 
    ```

    选择安装最新LLVM 22

    ```shell
    wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | sudo tee /usr/share/keyrings/llvm.gpg > /dev/null
    ```

    ```shell
    echo 'Types: deb
    URIs: https://apt.llvm.org/trixie/
    Suites: llvm-toolchain-trixie-22
    Components: main
    Architectures: amd64
    Signed-By: /usr/share/keyrings/llvm.gpg' | sudo tee /etc/apt/sources.list.d/llvm.sources
    ```

    ```shell
    sudo apt update && 
    sudo apt install -y libllvm-22-ocaml-dev libllvm22 llvm-22 llvm-22-dev llvm-22-doc llvm-22-examples llvm-22-runtime clang-22 clang-tools-22 clang-22-doc libclang-common-22-dev libclang-22-dev libclang1-22 clang-format-22 python3-clang-22 clangd-22 clang-tidy-22 libclang-rt-22-dev libpolly-22-dev libfuzzer-22-dev lldb lld libc++-22-dev libc++abi-22-dev libomp-22-dev libclc-22-dev libunwind-22-dev libmlir-22-dev mlir-22-tools libbolt-22-dev bolt-22 flang-22 libclang-rt-22-dev-wasm32 libclang-rt-22-dev-wasm64 libc++-22-dev-wasm32 libc++abi-22-dev-wasm32 libclang-rt-22-dev-wasm32 libclang-rt-22-dev-wasm64 libllvmlibc-22-dev
    ```

7. 安装并配置KVM

    ```shell
    sudo apt install -y qemu-system-x86 virt-manager libvirt-daemon-system virtinst libvirt-clients bridge-utils virtiofsd
    ```

    ```shell
    sudo systemctl enable libvirtd && sudo usermod -aG kvm ${USER} && sudo usermod -aG libvirt ${USER} && 
    mkdir -p ~/KVM/images
    ```

8. 安装并配置wireshark

    ```shell
    sudo apt install -y wireshark
    ```

    ```shell
    sudo chgrp wireshark /usr/bin/dumpcap && sudo chmod 4755 /usr/bin/dumpcap && sudo gpasswd -a ${USER} wireshark
    ```

9. 安装vlc

    ```shell
    sudo apt install -y vlc
    ```

10. 安装yaru-theme和dash-to-dock插件

    ```shell
    sudo apt install -y gnome-shell-extension-user-theme gtk2-engines-pixbuf gtk2-engines-murrine gnome-themes-extra && 
    sudo dpkg -i /datas/debs/session-migration*.deb && 
    sudo dpkg -i /datas/debs/yaru-theme-*.deb && 
    sudo apt install -y gnome-shell-extension-dashtodock
    ```

11. 系统设置

    设置locale防止终端警告

    ```shell
    echo 'LANG="en_US.UTF-8"
    LANGUAGE="en_US:en"
    LC_ALL="en_US.UTF-8"' | sudo tee /etc/default/locale && sudo update-locale
    ```

    设置grub取消选择启动项等待

    ```shell
    sudo cp /etc/default/grub /etc/default/grub.blk && 
    sudo sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub && 
    sudo update-grub
    ```

    设置登录缩放与当前一致

    ```shell
    sudo cp ~/.config/monitors.xml /var/lib/gdm3/.config
    ```

    配置SSH密钥对

    ```shell
    ssh-keygen -t rsa -b4096 -C "comrade.lijing@gmail.com" && cat ~/.ssh/id_rsa.pub
    ```

    设置git本地用户名和邮箱

    ```shell
    git config --global user.email "comrade.lijing@gmail.com" && git config --global user.name "Comrade Li"
    ```

12. 拉取个人配置

    ```shell
    git clone git@github.com:comrade-li/dev-env.git ~/Projects/dev-env
    ```

13. 设置字体

    设置字体

    ```shell
    sudo cp -r /datas/fonts/nonerd-fonts/*  /usr/share/fonts/truetype && 
    mkdir -p ~/.config/fontconfig && 
    ln -s ~/Projects/dev-env/configs/fontconfig/fonts.conf ~/.config/fontconfig/fonts.conf && 
    sudo fc-cache -f && fc-cache -f && 
    gsettings set org.gnome.desktop.interface font-antialiasing 'rgba' && 
    gsettings set org.gnome.desktop.interface font-hinting 'none' && 
    gsettings set org.gnome.desktop.interface font-rgba-order 'rgb' && 
    gsettings set org.gnome.desktop.interface font-name 'Inter 12' && 
    gsettings set org.gnome.desktop.interface document-font-name 'Noto Sans 12' && 
    gsettings set org.gnome.desktop.interface monospace-font-name 'Google Sans Code 14' 
    ```

    选择安装Twitter Color Emoji

    ```shell
    sudo apt install -y ttf-bitstream-vera && 
    sudo dpkg -i /datas/debs/fonts-twemoji-svginot*.deb && 
    sudo fc-cache -f && fc-cache -f
    ```

    选择安装Nerd Font

    ```shell
    sudo cp -r /datas/fonts/nerd-fonts/*  /usr/share/fonts/truetype && 
    sudo fc-cache -f && fc-cache -f
    ```

14. 设置桌面环境

    配置vim

    ```shell
    sudo ln -sf ~/Projects/dev-env/configs/.vimrc /root/.vimrc && ln -sf ~/Projects/dev-env/configs/.vimrc ~/.vimrc
    ```

    设置头像

    ```shell
    sudo cp ~/Projects/dev-env/configs/avatar-wang.jpg /usr/share/pixmaps/faces
    ```

    设置Terminal

    ```shell
    dconf load /org/gnome/terminal/ < ~/Projects/dev-env/configs/gnome-settings/gnome-terminal-settings.dconf
    ```

    设置颜色、快捷键、禁用Caps

    ```shell
    dconf load /org/gnome/settings-daemon/plugins/ < ~/Projects/dev-env/configs/gnome-settings/color-keys-power-settings.dconf && 
    dconf load /org/gnome/desktop/ < ~/Projects/dev-env/configs/gnome-settings/desktop.dconf && 
    dconf load /org/gnome/mutter/ < ~/Projects/dev-env/configs/gnome-settings/mutter.dconf && 
    dconf load /org/gnome/shell/app-switcher/ < ~/Projects/dev-env/configs/gnome-settings/app-switcher.dconf && 
    dconf load /org/gnome/nautilus/ < ~/Projects/dev-env/configs/gnome-settings/nautilus.dconf && 
    dconf load /org/gtk/gtk4/settings/file-chooser/ < ~/Projects/dev-env/configs/gnome-settings/file-chooser.dconf && 
    dconf load /org/virt-manager/ < ~/Projects/dev-env/configs/gnome-settings/virt-manager.dconf && 
    gsettings set org.gnome.Settings window-state '(1620, 1080, false)'
    ```

15. 安装配置oh-my-zsh

    1.安装oh-my-zsh

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

    ```shell
    git clone https://github.com/zsh-users/zsh-completions.git ~/.oh-my-zsh/plugins/zsh-completions
    ```

    3.配置~/.zshrc并更换默认sh为zsh

    ```shell
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && 
    sed -i 's/plugins=(git)/plugins=(\n  git\n  sudo\n  zsh-completions\n  zsh-autosuggestions\n  zsh-syntax-highlighting\n)\nsource ~\/.profile/g' ~/.zshrc && 
    chsh -s $(which zsh)
    ```

16. 安装配置oh-my-rime输入法

    1.下载

    ```shell
    git clone https://github.com/Mintimate/oh-my-rime.git ~/.config/ibus/rime
    ```

    2.修改配置

    ```shell
    cp ~/.config/ibus/rime/ibus_rime.yaml ~/.config/ibus/rime/ibus_rime.yaml.bak && 
    cp ~/.config/ibus/rime/rime_mint.schema.yaml ~/.config/ibus/rime/rime_mint.schema.yaml.bak && 
    sed -i 's/  horizontal: true/  horizontal: false/g' ~/.config/ibus/rime/ibus_rime.yaml && 
    sed -i '/^  - name: emoji_suggestion/,+2d' ~/.config/ibus/rime/rime_mint.schema.yaml
    ```

17. Java、go、nod、Cmake、clangd开发环境搭建

    配置环境变量

    ```shell
    echo '
    export PATH=/usr/local/texlive/2026/bin/x86_64-linux:$PATH
    export MANPATH=/usr/local/texlive/2026/texmf-dist/doc/man:$MANPATH
    export INFOPATH=/usr/local/texlive/2026/texmf-dist/doc/info:$INFOPATH

    CMAKE_HOME=~/.softwares/cmake/current

    CLANGD_HOME=~/.softwares/clangd

    GOROOT=~/.softwares/go/current

    JAVA_HOME=~/.softwares/java/current
    GRADLE_HOME=~/.softwares/gradle/current
    MAVEN_HOME=~/.softwares/maven/current
    MVND_HOME=~/.softwares/mvnd/current
    JMETER_HOME=~/.softwares/jmeter
    VISUALVM_HOME=~/.softwares/visualvm

    NODE_HOME=~/.softwares/node

    CARGO_HOME=~/.softwares/rust/cargo
    RUSTUP_HOME=~/.softwares/rust/rustup

    PATH=$CMAKE_HOME/bin:$CLANGD_HOME/bin:$GOROOT/bin:$JAVA_HOME/bin:$GRADLE_HOME/bin:$MAVEN_HOME/bin:$MVND_HOME/bin:$JMETER_HOME/bin:$VISUALVM_HOME/bin:$NODE_HOME/bin:$CARGO_HOME/bin:$PATH
    export CMAKE_HOME CLANGD_HOME GOROOT JAVA_HOME GRADLE_HOME MAVEN_HOME MVND_HOME JMETER_HOME VISUALVM_HOME NODE_HOME CARGO_HOME RUSTUP_HOME PATH' | tee -a ~/.profile
    ```

    安装

    ```shell
    mkdir -p ~/.softwares/cmake ~/.softwares/go ~/.softwares/java/oracle ~/.softwares/java/liberica ~/.softwares/gradle ~/.softwares/maven ~/.softwares/mvnd  && 
    tar -zxf /datas/softwares/cmake*.tar.gz -C ~/.softwares/cmake && 
    ln -sf ~/.softwares/cmake/cmake-* ~/.softwares/cmake/current && 
    unzip -qq /datas/softwares/clangd-linux-*.zip -d ~/.softwares && 
    mv ~/.softwares/clangd_* ~/.softwares/clangd && 
    tar -zxf /datas/softwares/go1.26*.tar.gz -C ~/.softwares/go --transform="s/go/"$(basename -s .tar.gz "$(find /datas/softwares -name "go1.26*")")"/" && 
    tar -zxf /datas/softwares/go1.25*.tar.gz -C ~/.softwares/go --transform="s/go/"$(basename -s .tar.gz "$(find /datas/softwares -name "go1.25*")")"/" && 
    ln -sf ~/.softwares/go/go1.26* ~/.softwares/go/current && 
    tar -zxf /datas/softwares/jdk-21*.tar.gz -C ~/.softwares/java/oracle &&  
    tar -zxf /datas/softwares/jdk-25*.tar.gz -C ~/.softwares/java/oracle && 
    tar -zxf /datas/softwares/bellsoft-jdk21*.tar.gz -C ~/.softwares/java/liberica && 
    tar -zxf /datas/softwares/bellsoft-jdk25*.tar.gz -C ~/.softwares/java/liberica && 
    ln -sf ~/.softwares/java/oracle/jdk-25* ~/.softwares/java/current && 
    unzip -qq /datas/softwares/gradle*.zip -d ~/.softwares/gradle && 
    ln -sf ~/.softwares/gradle/gradle*/ ~/.softwares/gradle/current && 
    tar -zxf /datas/softwares/apache-maven*.tar.gz -C ~/.softwares/maven && 
    ln -sf ~/.softwares/maven/apache-maven* ~/.softwares/maven/current && 
    tar -zxf /datas/softwares/maven-mvnd*.tar.gz -C ~/.softwares/mvnd && 
    ln -sf ~/.softwares/mvnd/maven-mvnd* ~/.softwares/mvnd/current && 
    tar -zxf /datas/softwares/apache-jmeter*.tgz -C ~/.softwares && 
    mv ~/.softwares/apache-jmeter* ~/.softwares/jmeter && 
    unzip -qq /datas/softwares/visualvm*.zip -d ~/.softwares && 
    mv ~/.softwares/visualvm* ~/.softwares/visualvm && 
    tar -xJf /datas/softwares/node-*.tar.xz -C ~/.softwares && 
    mv ~/.softwares/node-*  ~/.softwares/node
    ```

18. 安装Chrome

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

19. 安装VSCode

    ```shell
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor  | sudo tee /usr/share/keyrings/microsoft.gpg > /dev/null
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

20. 安装firefox

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

    复制这条命令后先关闭Firefox-esr浏览器！

    ```shell
    sudo apt remove -y firefox-esr && 
    sudo apt autoremove && 
    rm -rf ~/.face ~/.face.icon ~/.mozilla ~/.cache/mozilla ~/.bash_history ~/.config/evolution ~/.cache/evolution ~/.local/share/evolution && 
    sudo apt update && sudo apt install -y firefox
    ```

21. Postman安装与配置

    ```shell
    tar -zxf ~/Downloads/postman-linux-x64.tar.gz -C ~/.softwares && 
    cp ~/Projects/dev-env/configs/postman.desktop ~/.local/share/applications && 
    sudo desktop-file-install ~/.local/share/applications/postman.desktop
    ```
