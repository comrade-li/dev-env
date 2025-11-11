# PostgreSQL环境配置

`注意：` 基本Linux环境参考 [Debian Server配置](./Debian%20Server配置.md)

## 1. 源码安装

### 1.1 配置环境变量

```shell
echo '
export PG_HOME=/usr/local/pgsql-17
export PGDATA=$PG_HOME/data
export LD_LIBRARY=$PG_HOME/lib
export PGPORT=5432
export LANG=en_US.UTF-8
export PATH=$PG_HOME/bin:$PATH' |  sudo tee -a /etc/profile && source /etc/profile
```

### 1.2 配置postgres组和用户

1.创建组用户

```shell
sudo groupadd postgers && 
sudo useradd -g postgers -d /home/postgres -s /bin/bash postgres && 
sudo passwd postgres
```

2.新建用户家目录

```shell
sudo mkdir /home/postgres && 
sudo chown -R postgres /home/postgres
```

### 1.3 安装必须软件包

```shell
sudo apt install -y libicu-dev pkg-config bison flex libpython3-dev libreadline-dev libssl-dev libpam0g-dev libxml2-dev libxml2-utils libxslt1-dev tcl-dev libperl-dev liblz4-dev libzstd-dev libossp-uuid-dev libsystemd-dev gettext
```

### 1.4 配置、编译、安装

1.进入源码目录配置

```shell
tar -zxvf /shares/postgresql-17.*.tar.gz -C ~ && 
cd ~/postgresql-17.* && 
./configure --prefix=$PG_HOME --enable-nls='en' --with-perl --with-python --with-tcl --with-llvm --with-lz4 --with-zstd --with-ssl=openssl --with-pam --with-systemd --with-uuid=ossp --with-libxml --with-libxslt --without-ldap CFLAGS='-O2 -pipe'
```

2.编译

```shell
make -j4 world-bin
```

3.安装

```shell
sudo mkdir -p $PG_HOME && 
sudo make install-world-bin
```

### 1.5 配置PG

```shell
sudo chown -R postgres $PG_HOME
```

```shell
su - postgres
```

初始化

```shell
initdb
```

修改远程连接配置

```shell
vim $PGDATA/postgresql.conf
vim $PGDATA/pg_hba.conf
exit
```

### 1.6 配置systemd

1.创建service文件

```shell
echo "[Unit]
Description=PostgreSQL database server
Documentation=man:postgres(1)
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
User=postgres
ExecStart=$PG_HOME/bin/postgres -D $PGDATA
ExecReload=/bin/kill -HUP \$MAINPID
KillMode=mixed
KillSignal=SIGINT
TimeoutSec=infinity

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/postgresql.service
```

2.设置自启动

```shell
sudo systemctl enable postgresql.service
```

3.启动服务

```shell
sudo systemctl start postgresql.service
```

### 1.7 修改postgres用户密码

```shell
su - postgres
psql
```

```sql
ALTER USER postgres PASSWORD 'postgres';
```
