# docker-confluence-mysql-server
Atlassian Confluence Server with MySQL JDBC drivers

Example docker-compose script
...
version: '3.5'
services:
    confl-mysql:
        image: mysql/mysql-server:5.7
        restart: always
        networks:
          - databases
        volumes:
          - /data/mysql:/var/lib/mysql
        environment:
          - MYSQL_RANDOM_ROOT_PASSWORD=yes
          - MYSQL_DATABASE=confl
          - MYSQL_USER=confl
          - MYSQL_PASSWORD=YOUR_NEW_PASSWORD
        command: [mysqld, --character-set-server=utf8, --collation-server=utf8_bin, --default-storage-engine=INNODB, --max_allowed_packet=256M, --innodb_log_file_size=2GB, --transaction-isolation=READ-COMMITTED, --binlog_format=row]

    confluence:
        image: techgeeks/confluence-mysql-server:latest
        restart: always
        networks:
          - frontend
          - databases
        volumes:
          - /data/confluence:/var/atlassian/application-data/confluence
        ports:
          - 8090:8090
          - 8091:8091

networks:
    frontend: {}
    databases: {}
...
