FROM tomcat:latest
RUN apt-get update

# Configure Tomcat users for manager access
RUN rm -rf /usr/local/tomcat/webapps/*

# Add tomcat-users.xml with manager-script role
RUN echo '<?xml version="1.0" encoding="UTF-8"?>' > /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '<tomcat-users xmlns="http://tomcat.apache.org/xml"' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '              version="1.0">' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '  <role rolename="manager-gui"/>' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '  <role rolename="manager-script"/>' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '  <user username="tomcat" password="Raghu@123" roles="manager-gui,manager-script"/>' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '</tomcat-users>' >> /usr/local/tomcat/conf/tomcat-users.xml

# Enable manager app access from any IP
RUN sed -i 's/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/<!-- <Valve className="org.apache.catalina.valves.RemoteAddrValve"/g' /usr/local/tomcat/webapps/manager/META-INF/context.xml 2>/dev/null || true && \
    sed -i 's/allow=".*" \/>/allow=".*" \/> -->/g' /usr/local/tomcat/webapps/manager/META-INF/context.xml 2>/dev/null || true

COPY ${CI_PROJECT_DIR}/application_build_output/*.war /usr/local/tomcat/webapps/

CMD ["catalina.sh","run"]