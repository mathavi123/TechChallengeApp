#!/bin/bash
sudo apt update -y  
sudo apt-get install git -y
sudo apt install golang-go -y
cd /home/ubuntu/ServianTechChallenge/; wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O- | sudo apt-key add -
echo "deb [arch=amd64] http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main" | sudo tee /etc/apt/sources.list.d/postgresql.list;
sudo apt update
sudo apt install -y postgresql-10
sudo apt install net-tools
sudo apt install golang-rice -y
cd /home/ubuntu/TechChallengeApp
go get github.com/GeertJohan/go.rice
go get github.com/GeertJohan/go.rice/rice
sudo ./build.sh
sudo -u postgres psql -U postgres -d postgres -c "alter user postgres with password 'changeme';"
sudo cd /home/ubuntu/TechChallengeApp/dist
./TechChallengeApp updatedb

sed -i 's/"ListenHost" = "localhost"/"ListenHost" = "0.0.0.0"/g'  /home/ubuntu/TechChallengeApp/dist/conf.toml
./TechChallengeApp serve 
