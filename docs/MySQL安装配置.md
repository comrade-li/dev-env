# MySQL安装配置

`注意：` 基本Linux环境参考 [Debian Server配置](./Debian%20Server配置.md)

## 1. 二进制安装

### 1.1 环境变量

```shell
echo '
export MYSQL_HOME=/usr/local/mysql
export MYSQL_DATA=$MYSQL_HOME/data
export PATH=$PATH:$MYSQL_HOME/bin' |  sudo tee -a /etc/profile && source /etc/profile
```

### 1.2 添加mysql组和用户

```shell
sudo groupadd mysql && 
sudo useradd -g mysql -s /bin/false mysql
```

### 1.3 安装必须软件包

```shell
sudo apt install -y libaio-dev && 
sudo ln -s /usr/lib/x86_64-linux-gnu/libaio.so.1t64 /usr/lib/x86_64-linux-gnu/libaio.so.1
```

### 1.4 解压二进制包

```shell
sudo tar -xf /shares/mysql-2*.tar.xz -C /usr/local && 
sudo mv /usr/local/mysql* /usr/local/mysql && 
sudo mkdir -p $MYSQL_DATA
```

### 1.5 创建配置文件

```shell
echo "[mysqld]
port=3306
basedir=$MYSQL_HOME
datadir=$MYSQL_DATA" | sudo tee /etc/my.cnf
```

### 1.6 初始化MySQL数据库

```shell
sudo /usr/local/mysql/bin/mysqld --defaults-file=/etc/my.cnf --initialize-insecure --user=mysql
```

### 1.7 配置systemd

```shell
echo '[Unit]
Description=MySQL Community Server
Documentation=man:mysqld(8)
Documentation=https://dev.mysql.com/doc/refman/en/using-systemd.html
After=network-online.target
Wants=network-online.target

[Install]
WantedBy=multi-user.target

[Service]
User=mysql
Group=mysql
Type=notify
ExecStart=/usr/local/mysql/bin/mysqld
TimeoutSec=0
LimitNOFILE=10000
Restart=on-failure
RestartPreventExitStatus=1

# Always restart when mysqld exits with exit code of 16. This special exit code is used by mysqld for RESTART SQL.
RestartForceExitStatus=16

# Set enviroment variable MYSQLD_PARENT_PID. This is required for restart.
Environment=MYSQLD_PARENT_PID=1' | sudo tee /etc/systemd/system/mysqld.service
```

```shell
sudo systemctl start mysqld.service
```

### 1.8 登录并修改root密码

```shell
mysql -u root --skip-password
```

```sql
UPDATE mysql.user SET host="%" WHERE user='root';
FLUSH PRIVILEGES;
ALTER USER 'root'@'%' IDENTIFIED BY 'root';
FLUSH PRIVILEGES;
```
