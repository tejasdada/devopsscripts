
#!/bin/bash

set -e

# Install Java 21
dnf install -y java-21-amazon-corretto

# Download Tomcat 11
cd /opt

wget -O apache-tomcat-11.0.27.tar.gz \
https://downloads.apache.org/tomcat/tomcat-11/v11.0.27/bin/apache-tomcat-11.0.27.tar.gz

# Verify download
if [ ! -s apache-tomcat-11.0.27.tar.gz ]; then
    echo "Tomcat download failed!"
    exit 1
fi

# Extract Tomcat
tar -zxvf apache-tomcat-11.0.27.tar.gz

# Set Tomcat directory
TOMCAT_HOME=/opt/apache-tomcat-11.0.27

# Configure Tomcat users
sed -i '/<\/tomcat-users>/i\
<role rolename="manager-gui"/>\
<role rolename="manager-script"/>\
<user username="tomcat" password="root123456" roles="manager-gui,manager-script"/>' \
$TOMCAT_HOME/conf/tomcat-users.xml

# Allow remote access to Manager application
sed -i '/<Valve/,/\/>/d' \
$TOMCAT_HOME/webapps/manager/META-INF/context.xml

# Allow remote access to Host Manager
sed -i '/<Valve/,/\/>/d' \
$TOMCAT_HOME/webapps/host-manager/META-INF/context.xml

# Start Tomcat
sh $TOMCAT_HOME/bin/startup.sh

# Verify Java
java -version

# Verify Tomcat process
ps -ef | grep '[o]rg.apache.catalina.startup.Bootstrap'

echo "Tomcat installation completed successfully!"
