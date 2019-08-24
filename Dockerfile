FROM atlassian/confluence-server

MAINTAINER Sebastian <docker@techgeeks.io>

COPY mysql-connector-java-5.1.48.jar /opt/atlassian/confluence/confluence/WEB-INF/lib
