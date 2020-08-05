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
server_config () {
sudo systemctl enable httpd
git clone https://github.com/avvppro/dtester.git
sudo mkdir dtester/dt-api/application/logs dtester/dt-api/application/cache
chmod 766 dtester/dt-api/application/logs
chmod 766 dtester/dt-api/application/cache
sudo chown apache:apache dtester/*/*/*
sudo mv dtester /var/www
sudo mkdir /etc/httpd/sites-available /etc/httpd/sites-enabled
sudo echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf
sudo cat <<_EOF > /etc/httpd/sites-available/dtester.conf
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
sudo mkdir /var/log/httpd/dtester
sudo ln -s /etc/httpd/sites-available/dtester.conf /etc/httpd/sites-enabled/dtester.conf
systemctl restart httpd
}
software_install
server_config
