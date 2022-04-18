sudo apt update -y  
#sudo apt install docker.io -y						
#sudo usermod -aG docker ubuntu
sudo apt-get install git -y
sudo apt install golang-go -y
cd /home/ubuntu; wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O- | sudo apt-key add -
echo "deb [arch=amd64] http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main" | sudo tee /etc/apt/sources.list.d/postgresql.list;
sudo apt update
sudo apt install -y postgresql-10
sudo apt install net-tools
cd /home/ubuntu/ServianTechChallenge/TechChallengeApp
./build.sh
sudo -u postgres psql -U postgres -d postgres -c "alter user postgres with password 'changeme';"
cd /home/ubuntu/ServianTechChallenge/TechChallengeApp/dist
./TechChallengeApp updatedb

sed -i 's/"ListenHost" = "localhost"/"ListenHost" = "0.0.0.0"/g'  /home/ubuntu/ServianTechChallenge/TechChallengeApp/dist/conf.toml
./TechChallengeApp serve &