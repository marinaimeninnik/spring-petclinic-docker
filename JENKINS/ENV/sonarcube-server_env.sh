#! bin/bash/

# ubuntu_20 or 22 supported

USERNAME="ddsonar"
PASSWD="mwd#2%#!!#%rgs"
GROUPNAME="ddsonar"
DB_NAME="ddsonarqube" 

echo 'Updating system...'
apt-get update -y &>/dev/null

# Java
echo "Installing Java..."
apt install -y openjdk-17-jdk &>/dev/null
java -version

# Postgre
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" /etc/apt/sources.list.d/pgdg.list'
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -

echo 'Installing Postgre DB...'
apt install postgresql postgresql-contrib -y &>/dev/null
systemctl enable postgresql
systemctl start postgresql
psql --version

#Postgre presets for SonarCube
sudo -i -u postgres
createuser "$USERNAME"
psql
ALTER USER "$USERNAME" WITH ENCRYPTED password "'$PASSWD'";
CREATE DATABASE "$DB_NAME" OWNER "$USERNAME";
GRANT ALL PRIVILEGES ON DATABASE "$DB_NAME" to "$USERNAME";
\q
exit

echo 'Installin ZIP/Unzip...'
apt install zip -y &>/dev/null
apt install unzip -y &>/dev/null
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.0.0.68432.zip
unzip sonarqube-10.0.0.68432.zip
mv sonarqube-10.0.0.68432 sonarqube
mv sonarqube /opt/
groupadd "$GROUPNAME"
sudo useradd -d /opt/sonarqube -g "$USERNAME" "$USERNAME"
sudo chown "$USERNAME":"$USERNAME" /opt/sonarqube -R

cp /opt/sonarqube/conf/sonar.properties /opt/sonarqube/conf/sonar.properties.old
sed -i "s/^#sonar.jdbc.username=.*/"$USERNAME"/" "/opt/sonarqube/conf/sonar.properties"
sed -i "s/^#sonar.jdbc.password=.*/'$PASSWD'/" "/opt/sonarqube/conf/sonar.properties"
sed -i "/'$PASSWD'/a sonar.jdbc.url=jdbc:postgresql://localhost:5432/ddsonarqube" "/opt/sonarqube/conf/sonar.properties"

cp sonar.sh sonar.sh.old
sed -i "/APP_NAME="SonarQube"/iRUN_AS_USER="$USERNAME"" "sonar.sh"

cat <<EOL | tee /etc/systemd/system/sonar.service
[Unit]
Description=SonarQube service
After=syslog.target network.target
[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User="$USERNAME"
Group="$GROUPNAME"
Restart=always
LimitNOFILE=65536
LimitNPROC=4096
[Install]
WantedBy=multi-user.target

EOL

systemctl enable sonar
systemctl start sonar
if systemctl is-active --quiet sonar; then
    echo "Service SonarQube is running."
else
    echo "Service SonarQube is not running or does not exist."
    exit 1 
fi

