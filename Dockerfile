# Use an official Tomcat runtime as a parent image
FROM tomcat:9.0-jdk17-openjdk-slim

# Set the working directory to /app
WORKDIR /app

# Copy the WAR file into the container at the Tomcat webapps directory
COPY todoapp.war /usr/local/tomcat/webapps/todoapp.war

# Install MySQL Server
RUN apt-get update && \
    apt-get install -y mysql-server

# Initialize MySQL database and start the MySQL service
RUN /etc/init.d/mysql start && \
    mysql -e "CREATE DATABASE todoapp" && \
    mysql -e "GRANT ALL PRIVILEGES ON todoapp.* TO 'root'@'localhost' IDENTIFIED BY '123456789';" && \
    mysql -e "FLUSH PRIVILEGES"

# Set environment variables for MySQL connection
ENV MYSQL_HOST=localhost \
    MYSQL_PORT=3306 \
    MYSQL_DATABASE=todoapp \
    MYSQL_USER=root \
    MYSQL_PASSWORD=123456789

# Expose the port Tomcat will run on
EXPOSE 8080

# Start Tomcat when the container starts
CMD ["catalina.sh", "run"]
