#!/bin/bash
software_install() {
sudo yum update -y
sudo yum install mc git httpd -y
sudo setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sudo yum install epel-release -y
sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
sudo rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-7.noarch.rpm
sudo yum --enablerepo=remi-php72 install php php-mysql php-xml php-soap php-xmlrpc php-mbstring php-json php-gd \
 php-mcrypt php72-php-fpm php72-php-gd php72-php-json php72-php-mbstring php72-php-mysqlnd -y
sudo yum-config-manager --enable remi-php72
}
be_install () {
sudo systemctl enable httpd
git clone https://github.com/yurkovskiy/dtapi
git clone https://github.com/koseven/koseven
mkdir ./dtapi/application/logs ./dtapi/application/cache
chmod 766 ./dtapi/application/logs
chmod 766 ./dtapi/application/cache
mv ./koseven/public/index.php ./dtapi/
mv ./koseven/modules/ ./dtapi/
mv ./koseven/system/ ./dtapi/
sed -i "s%RewriteBase /%RewriteBase /dtapi/%g" ./dtapi/.htaccess
sed -i "s%'base_url'   => '/'%'base_url'   => '/dtapi/'%g" ./dtapi/application/bootstrap.php
sed -i "s/PDO_MySQL/PDO/g" ./dtapi/application/config/database.php
sed -i "s/mysql:host=localhost/mysql:host=192.168.33.11/g" ./dtapi/application/config/database.php
sed -i "s/'username'   => 'dtapi'/'username'   => 'username'/g" ./dtapi/application/config/database.php
sed -i "s/'password'   => 'dtapi'/'password'   => 'passwordQ1@'/g" ./dtapi/application/config/database.php
sudo mkdir /var/www/dtester /etc/httpd/sites-available /etc/httpd/sites-enabled
sudo mv dtapi /var/www/dtester/
sudo chown -R apache.  /var/www/dtester
sudo systemctl restart httpd
}
fe_install () {
curl -sL https://rpm.nodesource.com/setup_12.x | sudo bash -
sudo yum install nodejs wget -y
sudo npm install -g @angular/cli
wget https://dtapi.if.ua/~yurkovskiy/IF-108/htaccess_example_fe
sudo mv ./htaccess_example_fe /var/www/dtester/.htaccess
git clone https://github.com/yurkovskiy/IF-105.UI.dtapi.if.ua.io
cd IF-105.UI.dtapi.if.ua.io
local_ip=$(ip addr show eth1 | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
sudo sed -i "s https://dtapi.if.ua/api http://$local_ip/dtapi g" ./src/environments/environment.prod.ts
sudo sed -i "s https://dtapi.if.ua/api http://$local_ip/dtapi g" ./src/environments/environment.ts
npm install
ng build --prod 
sudo mv dist/IF105/* /var/www/dtester/
sudo chown -R apache. /var/www/dtester/
sudo echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf
sudo cat <<_EOF > ./dtester.conf
<VirtualHost *:80>
    #    ServerName www.example.com
    #    ServerAlias example.com
    DocumentRoot /var/www/dtester
    ErrorLog /var/log/httpd/dtester/error.log
    CustomLog /var/log/httpd/dtester/requests.log combined
    <Directory /var/www/dtester/>
            AllowOverride All
    </Directory>
</VirtualHost>
_EOF
sudo mv ./dtester.conf /etc/httpd/sites-available/
sudo mkdir /var/log/httpd/dtester
sudo ln -s /etc/httpd/sites-available/dtester.conf /etc/httpd/sites-enabled/dtester.conf
sudo systemctl restart httpd
}
software_install
be_install
fe_install
