#!/bin/bash

apt update 
wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
apt update
apt install jenkins -y
apt update
apt install fontconfig openjdk-17-jre -y
#java -version
#openjdk version "17.0.8" 2023-07-18
#OpenJDK Runtime Environment (build 17.0.8+7-Debian-1deb12u1)
#OpenJDK 64-Bit Server VM (build 17.0.8+7-Debian-1deb12u1, mixed mode, sharing)
systemctl enable jenkins
systemctl start jenkins
#systemctl status jenkins
#cat /var/lib/jenkins/secrets/initialAdminPassword
#
#ssh-keygen -t ed25519 -f /root/.ssh/id_ed25519 -C "shupik3@gmail.com"
apt install expect -y
#ssh-keygen_command="ssh-keygen -t ed25519 -f /root/.ssh/id_ed25519 -C \"shupik3@gmail.com\""
echo "y" | ssh-keygen -t ed25519 -f /root/.ssh/id_ed25519 -C "shupik3@gmail.com" -P ""

# Використання expect для автоматизації
expect -c "
spawn $ssh-keygen_command
expect \"Enter passphrase (empty for no passphrase):\"
send \"\r\"
expect \"Enter same passphrase again:\"
send \"\r\"
expect eof
"
#cat /root/.ssh/id_ed25519.pub
#cat /root/.ssh/id_ed25519
mkdir -p /var/lib/jenkins/.ssh/
cp /root/.ssh/id_ed25519 /var/lib/jenkins/.ssh/
cp /root/.ssh/id_ed25519.pub /var/lib/jenkins/.ssh/
chown -R jenkins:jenkins /var/lib/jenkins/.ssh/
chmod 700 /var/lib/jenkins/.ssh/
chmod 600 /var/lib/jenkins/.ssh/id_ed25519
chmod 644 /var/lib/jenkins/.ssh/id_ed25519.pub
snap install docker
apt install docker.io -y
#echo "hello"
sudo -u jenkins ssh-keyscan -t ed25519 github.com >> /var/lib/jenkins/.ssh/known_hosts
systemctl restart jenkins
usermod -aG docker jenkins
service jenkins restart



echo "\n\t KEY FROM  JENKINS\n"
cat /var/lib/jenkins/secrets/initialAdminPassword
echo "\n\t SSH_KEY.pub\n"
cat /root/.ssh/id_ed25519.pub
echo "\n\t SSH_KEY.priv\n"
cat /root/.ssh/id_ed25519
echo "\n\n"
