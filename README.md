## Docker Atlassian Confluence Server with MySQL and JDBC drivers
This dockerfile uses autobuild and gets recreated once the main docker image from Atlassion gets any updates. The latest MySQL version, that can be used with Confluence is actually 5.7, since Atlassian is not supporting any higher version yet [(more details)](https://confluence.atlassian.com/doc/supported-platforms-207488198.html#SupportedPlatforms-Databases). 

**Sources used for this build**

| Package name  | Version | Link |
| ------------- | ------------- | ------------- |
| **MySQL server** (mysql/mysql-server) | 8.latest | [Docker Hub](https://hub.docker.com/r/mysql/mysql-server)  |
| **Atlassian Confluence Server** (atlassian/confluence-server) | latest | [Docker Hub](https://hub.docker.com/r/atlassian/confluence-server/)  |
| **MySQL JDBC drivers** | 8.0.21 | [MySQL.com](https://dev.mysql.com/downloads/connector/j/)  |


**Example docker-compose.yml script**

```
version: '3.5'
services:
  confl-mysql:
    image: mysql/mysql-server:5.7
    container_name: confl-mysql
    restart: always
    networks:
      - databases
    volumes:
      - /data/docker/mysql:/var/lib/mysql
    environment:
      - MYSQL_RANDOM_ROOT_PASSWORD=yes
      - MYSQL_DATABASE=confl
      - MYSQL_USER=confl
      - MYSQL_PASSWORD=YOUR_NEW_PASSWORD
    command: [mysqld, --character-set-server=utf8, --collation-server=utf8_bin, --default-storage-engine=INNODB, --max_allowed_packet=256M, --innodb_log_file_size=2GB, --transaction-isolation=READ-COMMITTED, --binlog_format=row]

  confluence:
    image: techgeeks/confluence-mysql-server
    container_name: confluence
    hostname: your.hostname
    restart: always
    networks:
      - frontend
      - databases
    volumes:
      - /data/docker/confluence:/var/atlassian/application-data/confluence
      # Optional (permissions must be changed on the host system)
      #- /data/docker/confluence/attachments:/var/atlassian/application-data/confluence/attachments
      #- /data/docker/confluence/backups:/var/atlassian/application-data/confluence/backups
    environment:
      - 'CATALINA_OPTS= -Dsynchrony.proxy.healthcheck.disabled=true'
      - JVM_MINIMUM_MEMORY=1024m
      - JVM_MAXIMUM_MEMORY=8192m
    ports:
      - 8090:8090
      - 8091:8091
```

If you want to use Confluence behind an NGINX proxy, please use the following docker-compose configuration for confluence:
```
  confluence:
    image: techgeeks/confluence-mysql-server
    container_name: confluence
    hostname: your.hostname
    restart: always
    networks:
      - frontend
      - databases
    volumes:
      - /data/docker/confluence:/var/atlassian/application-data/confluence
      # Optional (permissions must be changed on the host system)
      #- /data/docker/confluence/attachments:/var/atlassian/application-data/confluence/attachments
      #- /data/docker/confluence/backups:/var/atlassian/application-data/confluence/backups
    environment:
      - 'CATALINA_OPTS= -Dsynchrony.proxy.healthcheck.disabled=true'
      - JVM_MINIMUM_MEMORY=1024m
      - JVM_MAXIMUM_MEMORY=8192m
      - CATALINA_CONNECTOR_PROXYNAME=your_proxy.url
      - CATALINA_CONNECTOR_SCHEME=https
      - CATALINA_CONNECTOR_SECURE=true
      - CATALINA_CONNECTOR_PROXYPORT=443
```


**Steps during the installation**

![MySQL settings](https://abload.de/img/settingsqgkiz.png)

Please enter the following JDBC string during setting up the MySQL connection instead of the "Simple" configuration, to avoid the error message down below. This will allow us to use a SSL connection between webserver and database but hides the annoying messages:
```
jdbc:mysql://confl-mysql:3306/confluence?verifyServerCertificate=false&useSSL=true
```

**WARNING Message (flooding):** SSL connection warning in the catalina logs, between Atlassian (Tomcat) and MySQL:
```
WARNING: Establishing SSL connection without server's identity verification is not recommended. According to MySQL 5.5.45+, 5.6.26+ and 5.7.6+ requirements SSL connection must be established by default if explicit option isn't set. For compliance with existing applications not using SSL the verifyServerCertificate property is set to 'false'. You need either to explicitly disable SSL by setting useSSL=false, or set useSSL=true and provide truststore for server certificate verification.
```
