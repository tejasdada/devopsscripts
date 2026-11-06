
#!/bin/bash

# Install Java 21
dnf install -y java-21-amazon-corretto

# Download Apache Tomcat 11
wget https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.14/bin/apache-tomcat-11.0.14.tar.gz

# Extract Tomcat
tar -zxvf apache-tomcat-11.0.14.tar.gz

# Configure Tomcat users
sed -i '/<\/tomcat-users>/d' apache-tomcat-11.0.14/conf/tomcat-users.xml

cat >> apache-tomcat-11.0.14/conf/tomcat-users.xml <<'EOF'
<role rolename="manager-gui"/>
<role rolename="manager-script"/>
<user username="tomcat" password="root123456" roles="manager-gui,manager-script"/>
</tomcat-users>
EOF

# Allow remote access to Tomcat Manager
sed -i '/<Valve /d' apache-tomcat-11.0.14/webapps/manager/META-INF/context.xml

# Allow remote access to Host Manager
sed -i '/<Valve /d' apache-tomcat-11.0.14/webapps/host-manager/META-INF/context.xml

# Start Tomcat
sh apache-tomcat-11.0.14/bin/startup.sh

# Check Java version
java -version

echo "Tomcat installation completed successfully!"
