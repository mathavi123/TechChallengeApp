#!/bin/bash
sudo yum update -y  
#sudo apt install docker.io -y						
#sudo usermod -aG docker ubuntu
sudo yum install git -y
sudo yum install golang-go -y
cd /home/ec2-user; wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O- | sudo apt-key add -
echo "deb [arch=amd64] http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main" | sudo tee /etc/apt/sources.list.d/postgresql.list;
sudo yum update
sudo yum install -y postgresql-10
sudo yum install net-tools
cd /home/ec2-user/TechChallengeApp
./build.sh
sudo -u postgres psql -U postgres -d postgres -c "alter user postgres with password 'changeme';"
cd /home/ec2-user/TechChallengeApp/dist
./TechChallengeApp updatedb

sed -i 's/"ListenHost" = "localhost"/"ListenHost" = "0.0.0.0"/g'  /home/ec2-user/TechChallengeApp/dist/conf.toml
nuhub ./TechChallengeApp serve &
