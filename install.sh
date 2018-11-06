gen_pass() {
    MATRIX='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
    LENGTH=16
    while [ ${n:=1} -le $LENGTH ]; do
        PASS="$PASS${MATRIX:$(($RANDOM%${#MATRIX})):1}"
        let n+=1
    done
    echo "$PASS"
}

echo
echo "=========== Install Nginx ==========="
echo

sudo add-apt-repository ppa:nginx/stable -y > /dev/null 2>&1
sudo apt-get update -y --force-yes -qq > /dev/null 2>&1

echo
echo "- Installing, please wait..."
echo

sudo apt-get install nginx -y --force-yes -qq > /dev/null 2>&1

sudo rm /etc/nginx/sites-available/default > /dev/null 2>&1
sudo wget https://raw.githubusercontent.com/globalmac/Larascale/master/nginx/default -O /etc/nginx/sites-available/default > /dev/null 2>&1

echo
echo "==> Nginx installed succesful!"
echo

echo
echo "=========== Install PostgreSQL ==========="
echo

PSQL_ROOT_PASSWORD=$(gen_pass)


echo
echo "- Cleaning up, please wait..."
echo

sudo apt-get update -y > /dev/null 2>&1
sudo apt-get upgrade -y > /dev/null 2>&1
sudo apt-get clean -y > /dev/null 2>&1
sudo apt-get autoclean -y > /dev/null 2>&1
sudo apt-get autoremove -y > /dev/null 2>&1


echo
echo "- Installing, please wait..."
echo

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list' -y > /dev/null 2>&1

sudo wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add - > /dev/null 2>&1
sudo apt-get update -y > /dev/null 2>&1
sudo apt-get install postgresql postgresql-contrib -y > /dev/null 2>&1

echo
echo "- Setting up PostgreSQL..."
echo

sudo -i -u postgres psql -q -c "ALTER USER postgres WITH PASSWORD '$PSQL_ROOT_PASSWORD';"
sudo -i -u postgres psql -q -c "create database myapp with encoding='UNICODE';"

echo
echo "==> PostgreSQL installed succesful!"
echo


echo
echo "=========== Install Node ==========="
echo

sudo apt-get update > /dev/null 2>&1
sudo apt-get install -y python-software-properties python g++ make > /dev/null 2>&1
sudo add-apt-repository -y ppa:chris-lea/node.js > /dev/null 2>&1
sudo apt-get update > /dev/null 2>&1
sudo apt-get install nodejs > /dev/null 2>&1
sudo npm install -g node-gyp pm2 > /dev/null 2>&1


echo
echo "==> Nodejs installed succesful!"
echo

echo "==========="
echo "Installation complete successfully! "
echo "PostgreSQL info:"
echo "Login: postgres"
echo "Password: $PSQL_ROOT_PASSWORD"
echo
echo "==========="

apt-get clean -y > /dev/null 2>&1
apt-get autoclean -y > /dev/null 2>&1
apt-get autoremove -y > /dev/null 2>&1

sed -i "s/_DATABASE_URL_/postgresql:\/\/postgres:$PSQL_ROOT_PASSWORD@localhost\/myapp/g" "./ecosystem.config.js"

service nginx restart > /dev/null 2>&1
service postgresql restart > /dev/null 2>&1

pm2 start ecosystem.config.js --env production

exit 0
