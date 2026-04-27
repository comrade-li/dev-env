# PostgreSQL环境配置

`注意：` 基本Linux环境参考 [Debian Server配置](./Debian%20Server配置.md)

## 1. 源码编译安装

### 1.1 环境变量

```shell
echo '
export PG_HOME=/usr/local/pgsql-18
export PGDATA=$PG_HOME/data
export LD_LIBRARY=$PG_HOME/lib
export PGPORT=5432
export LANG=en_US.UTF-8
export PATH=$PATH:$PG_HOME/bin' |  sudo tee -a /etc/profile && source /etc/profile
```

### 1.2 添加postgres组和用户

```shell
sudo groupadd postgers && 
sudo useradd -g postgers -d /home/postgres -s /bin/bash postgres && 
sudo passwd postgres
```

```shell
sudo mkdir /home/postgres && 
sudo chown -R postgres /home/postgres
```

### 1.3 安装必须软件包

```shell
sudo apt install -y flex bison perl libperl-dev libedit-dev libreadline8t64 libreadline-dev libicu-dev gettext libpython3-dev liblz4-dev zstd libgssapi-krb5-2 libldap-dev libpam0g-dev libsystemd-dev libossp-uuid-dev e2fsprogs libcurl4t64 libcurl4-openssl-dev libnuma-dev liburing-dev libxml2-dev libxslt1-dev fop dbtoepub xsltproc
```

### 1.4 配置、编译、安装

1.进入源码目录配置

```shell
tar -zxf /shares/postgresql-18.*.tar.gz -C ~ && 
cd ~/postgresql-18.* && 
./configure --prefix=$PG_HOME --enable-nls='en' --with-perl --with-python --with-tcl --with-llvm LLVM_CONFIG='/usr/bin/llvm-config' --with-lz4 --with-zstd --with-ssl=openssl --with-gssapi --with-ldap --with-pam --with-systemd --with-uuid=ossp --with-libcurl --with-libnuma --with-liburing --with-libxml --with-libxslt --with-selinux CFLAGS='-O2 -pipe'
```

2.编译

```shell
make -j$(nproc) world-bin
```

3.安装

```shell
sudo mkdir -p $PG_HOME && 
sudo make install-world-bin
```

### 1.5 配置PG

```shell
sudo chown -R postgres $PG_HOME && 
su -l postgres -c "initdb"
```

修改远程连接配置

```shell
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" $PGDATA/postgresql.conf && 
sudo sed -i "s/#port = 5432/port = 5432/g" $PGDATA/postgresql.conf && 
sudo sed -i "s|^host\s\+all\s\+all\s\+127.0.0.1/32\s\+trust|host    all             all             192.168.0.1/24            md5|g" $PGDATA/pg_hba.conf
```

### 1.6 配置systemd

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

```shell
sudo systemctl enable postgresql.service && 
sudo systemctl start postgresql.service
```

### 1.7 修改postgres用户密码

```sql
su -l postgres -c "psql -c \"ALTER USER postgres PASSWORD 'postgres';\""
```
