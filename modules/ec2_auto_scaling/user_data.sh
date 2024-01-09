#!/bin/bash
sudo apt update -y
sudo apt upgrade -y
sudo apt install awscli -y
sudo aws configure set region us-east-1 
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

sudo usermod -aG docker ubuntu

sudo apt install -y git

git clone https://github.com/naveend3v/Python-MySQL-application.git /home/ubuntu/app

# Retrieve database password from AWS Systems Manager Parameter Store
mysql_password=$(aws ssm get-parameter --name mysql_psw --query "Parameter.Value" --output text --with-decryption)

# Retrieve databse endpoint from AWS RDS
db_endpoint_url=$(aws rds describe-db-instances --db-instance-identifier test --query "DBInstances[*].Endpoint.Address" --output text)

# Replacing database endpoint url in app.py
grep -rl "database_endpoint" /home/ubuntu/app/app.py | xargs sed -i 's|database_endpoint|'"$db_endpoint_url"'|g'

# Setting aws secert key for python app
secret_key=$(aws ssm get-parameter --name my_secret_key --query "Parameter.Value" --output text --with-decryption)

grep -rl "your_secret_key" /home/ubuntu/app/app.py | xargs sed -i 's|your_secret_key|'"$secret_key"'|g'

# Pass the password as an environment variable to the Docker container
sudo docker build -t python-app /home/ubuntu/app/

sudo docker run -d -p 80:5000 -e MYSQL_PASSWORD="$mysql_psw" python-app