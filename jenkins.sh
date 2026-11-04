#!/bin/bash

# Exit if any command fails
set -e

echo "STEP 1: Updating packages"
sudo yum update -y

echo "STEP 2: Installing Git, Maven and wget"
sudo yum install -y git maven wget fontconfig

echo "STEP 3: Adding Jenkins Repository"
sudo wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/rpm-stable/jenkins.repo

echo "STEP 4: Importing Jenkins GPG Key"
sudo rpm --import https://pkg.jenkins.io/rpm-stable/jenkins.io-2026.key

echo "STEP 5: Installing Java 21"
sudo yum install -y java-21-amazon-corretto

echo "STEP 6: Checking Java Version"
java -version

echo "STEP 7: Installing Jenkins"
sudo yum install -y jenkins

echo "STEP 8: Reloading Systemd"
sudo systemctl daemon-reload

echo "STEP 9: Enabling Jenkins at Boot"
sudo systemctl enable jenkins

echo "STEP 10: Starting Jenkins"
sudo systemctl start jenkins

echo "STEP 11: Checking Jenkins Status"
sudo systemctl status jenkins --no-pager
echo "STEP 12: Jenkins Initial Admin Password"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

echo "Jenkins Installation Completed Successfully!"


