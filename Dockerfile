FROM atlassian/confluence-server

MAINTAINER Sebastian <docker@techgeeks.io>

COPY mysql-connector-java-5.1.46.jar /opt/atlassian/confluence/confluence/WEB-INF/lib
