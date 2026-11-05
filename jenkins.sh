
#!/bin/bash

# Exit if any command fails
set -e

echo "STEP 1: Updating packages"
sudo dnf update -y

echo "STEP 2: Installing Git, Maven, wget and fontconfig"
sudo dnf install -y git maven wget fontconfig

echo "STEP 3: Installing Java 21 (OpenJDK)"
sudo dnf install -y java-21-openjdk

echo "STEP 4: Checking Java Version"
java -version

echo "STEP 5: Setting JAVA_HOME"
JAVA_HOME=$(dirname "$(dirname "$(readlink -f "$(which java)")")")
echo "JAVA_HOME=$JAVA_HOME"
export JAVA_HOME

echo "STEP 6: Adding Jenkins Repository"
sudo wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/rpm-stable/jenkins.repo

echo "STEP 7: Importing Jenkins GPG Key"
sudo rpm --import https://pkg.jenkins.io/rpm-stable/jenkins.io-2026.key

echo "STEP 8: Cleaning DNF Cache"
sudo dnf clean all

echo "STEP 9: Installing Jenkins"
sudo dnf install -y jenkins

echo "STEP 10: Reloading Systemd"
sudo systemctl daemon-reload

echo "STEP 11: Enabling Jenkins at Boot"
sudo systemctl enable jenkins
echo "STEP 12: Starting Jenkins"
sudo systemctl start jenkins

echo "STEP 13: Checking Jenkins Status"

if sudo systemctl is-active --quiet jenkins; then
    echo "Jenkins is running successfully!"
else
    echo "Jenkins failed to start. Checking logs..."
    sudo journalctl -u jenkins -n 50 --no-pager
    exit 1
fi

echo "STEP 14: Jenkins Initial Admin Password"

if sudo test -f /var/lib/jenkins/secrets/initialAdminPassword; then
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword
else
    echo "Initial password not generated yet. Check Jenkins logs."
fi

echo "Jenkins Installation Completed Successfully!"

