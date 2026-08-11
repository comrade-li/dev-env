# GCC编译安装

说明：以最新版本gcc16.2为例, 根据具体需求安装具体版本

1. 设置基础变量

    ```shell
    export WORK_DIR="$HOME/Downloads" && 
    export DEP_SOFT="$WORK_DIR/dep_soft" && 
    export GCC_VERSION="16.2.0" && 
    export GCC_PREFIX="$HOME/.softwares/gcc-$GCC_VERSION"
    ```

2. 解压源码

    ```ahell
    tar -xf /datas/softwares/gcc/gmp-*.tar.xz -C $WORK_DIR && 
    tar -zxf /datas/softwares/gcc/mpfr-*.tar.gz -C $WORK_DIR && 
    tar -xf /datas/softwares/gcc/mpc-*.tar.xz -C $WORK_DIR && 
    tar -zxf /datas/softwares/gcc/gettext-*.tar.gz -C $WORK_DIR && 
    tar -zxf /datas/softwares/gcc/isl-*.tar.gz -C $WORK_DIR && 
    tar -zxf /datas/softwares/gcc/gcc-*.tar.gz -C $WORK_DIR
    ```

3. 编译安装gmp

    ```shell
    cd $WORK_DIR/gmp-* && mkdir build_dir && cd $_ && 
    ../configure --host=x86_64-pc-linux-gnu --prefix=$DEP_SOFT/gmp && 
    make -j$(nproc) && 
    make install
    ```

4. 编译安装mpfr

    ```shell
    cd $WORK_DIR/mpfr-* && mkdir build_dir && cd $_ && 
    ../configure --host=x86_64-pc-linux-gnu --prefix=$DEP_SOFT/mpfr --with-gmp=$DEP_SOFT/gmp && 
    make -j$(nproc) && 
    make install
    ```

5. 编译安装mpc

    ```shell
    cd $WORK_DIR/mpc-* && mkdir build_dir && cd $_ && 
    ../configure --host=x86_64-pc-linux-gnu --prefix=$DEP_SOFT/mpc --with-gmp=$DEP_SOFT/gmp --with-mpfr=$DEP_SOFT/mpfr && 
    make -j$(nproc) && 
    make install
    ```

6. 编译安装gettext

    ```shell
    cd $WORK_DIR/gettext-* && mkdir build_dir && cd $_ && 
    ../configure --host=x86_64-pc-linux-gnu --prefix=$DEP_SOFT/gettext --disable-java --with-mpfr=$DEP_SOFT/mpfr &&  
    make -j$(nproc) && 
    make install
    ```

7. 编译安装isl

    ```shell
    cd $WORK_DIR/isl-* && mkdir build_dir && cd $_ && 
    ../configure --host=x86_64-pc-linux-gnu --prefix=$DEP_SOFT/isl --with-gmp=$DEP_SOFT/gmp --with-clang-exec-prefix=/usr/bin/clang --with-python_exec_prefix=/usr/bin/python3 && 
    make -j$(nproc) && 
    make install
    ```

8. 配置安装gcc

    ```shell
    cd $WORK_DIR/gcc-* && mkdir build_dir && cd $_ && 
    ../configure \
    --host=x86_64-pc-linux-gnu \
    --with-pkgversion="Debian $GCC_VERSION" \
    --prefix=$GCC_PREFIX \
    --enable-threads=posix \
    --enable-languages=c,c++ \
    --with-gmp=$DEP_SOFT/gmp \
    --with-mpfr=$DEP_SOFT/mpfr \
    --with-mpc=$DEP_SOFT/mpc \
    --with-included-gettext=$DEP_SOFT/gettext \
    --with-isl=$DEP_SOFT/isl \
    --disable-multilib \
    --with-target-system-zlib && 
    make -j$(nproc) && 
    make install
    ```

9. 环境变量

    ```shell
    echo "
    export PATH=$GCC_PREFIX/bin:\$PATH
    export LD_LIBRARY_PATH=$GCC_PREFIX/lib64:\$LD_LIBRARY_PATH" | tee -a ~/.profile && 
    source ~/.zshrc
    ```
