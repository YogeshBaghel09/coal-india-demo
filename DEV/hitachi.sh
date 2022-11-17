#!/bin/bash
              #sudo su
              sudo yum update -y
              #sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
              sudo yum install httpd -y
              sudo systemctl start httpd
              sudo systemctl enable httpd
              sudo echo 'Hello World this is DEV' >> /var/www/html/index.html
              sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
              #sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf
              sudo systemctl restart httpd
              sudo systemctl restart sshd
