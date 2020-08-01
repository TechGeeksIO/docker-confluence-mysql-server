FROM atlassian/confluence-server

MAINTAINER Sebastian <docker@techgeeks.io>

COPY mysql-connector-java-8.0.21.jar /opt/atlassian/confluence/confluence/WEB-INF/lib
