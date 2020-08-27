#!/bin/bash
software_install() {
    sudo yum update -y
    rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
    sudo yum install mc nginx setroubleshoot-server -y    
}
nginx_config() {
 semanage permissive -a httpd_t
    cat <<_EOF >./backend_lb.conf 
    upstream backend {
        server 192.168.33.51:80;
        server 192.168.33.52:80;
    }
    server {
        listen       80;
        server_name  192.168.33.150;
        location /{
            proxy_pass http://backend;
        }
    }
_EOF
    sudo mv ./backend_lb.conf /etc/nginx/conf.d/
    sudo systemctl start nginx
    sudo systemctl enable nginx
}
software_install
nginx_config