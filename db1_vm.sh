#!/bin/bash
software_install() {
    sudo yum update -y
    sudo yum install wget expect -y
    wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
    sudo yum localinstall mysql57-community-release-el7-11.noarch.rpm -y
    sudo yum-config-manager --enable mysql57-community
    sudo yum install mysql-community-server -y
}
database_config() {
    sudo service mysqld start
    cat <<_EOF >./my.expect
    #!/usr/bin/expect -f
    set timeout 3
    spawn mysql -u root -p
    sleep 2
    expect "Enter password:"
    send "[lindex \$argv 0]
    "
    sleep 1
    expect "mysql>"
    send "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RootPWD1@';
    "
    sleep 1
    expect "mysql>"
    send "CREATE DATABASE dtapi2;
    "
    sleep 1
    expect "mysql>"
    send "CREATE USER 'username'@'%' IDENTIFIED BY 'passwordQ1@';
    "
    sleep 1
    expect "mysql>"
    send "GRANT ALL PRIVILEGES ON dtapi2.* TO 'username'@'%'  WITH GRANT OPTION;
    "
    sleep 1
    expect "mysql>"
    send "FLUSH PRIVILEGES;
    "
    sleep 1
    expect "mysql>"
    send "exit
    "
_EOF
    sudo chmod 777 ./my.expect
    sudo grep 'temporary password' /var/log/mysqld.log | sed 's|.*: ||' >./1.txt
    tmp_pass=$(cat 1.txt)
    expect ./my.expect $tmp_pass
    rm ./my.expect
}
load_dump() {
    wget https://dtapi.if.ua/~yurkovskiy/dtapi_full.sql
    mysql -u root --password=RootPWD1@ dtapi2 < ./dtapi_full.sql
    sudo chmod 666 /etc/my.cnf
    sudo echo "bind-address=192.168.33.100" >>/etc/my.cnf
    sudo chmod 644 /etc/my.cnf
    sudo systemctl restart mysqld
}
software_install
database_config
load_dump