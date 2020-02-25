FROM oraclelinux

##############################
###### PRE INSTALLATION ######
##############################
# Install Oracle 18C XE dependencies
RUN yum install \
    wget net-tools \
    oracle-database-preinstall-18c \
    file \
    -y

# Download Oracle 18C XE
RUN wget -O oracle-database-xe-18c-1.0-1.x86_64.rpm https://download.oracle.com/otn-pub/otn_software/db-express/oracle-database-xe-18c-1.0-1.x86_64.rpm

# Tell the Oracle package that we are in a Docker container
ENV ORACLE_DOCKER_INSTALL=true

##############################
######## INSTALLATION ########
##############################
# Install Oracle 18C XE
RUN rpm -i oracle-database-xe-18c-1.0-1.x86_64.rpm

##############################
##### POST INSTALLATION ######
##############################
# Set sys password
RUN (echo "password"; echo "password";) | /etc/init.d/oracle-xe-18c configure

# Set SID
ENV ORACLE_SID=XE

# Set ORAENV_ASK
ENV ORAENV_ASK=NO

# Set another bunch of environment variables
RUN ./opt/oracle/product/18c/dbhomeXE/bin/oraenv
ENV ORACLE_HOME=/opt/oracle/product/18c/dbhomeXE
ENV PATH=$ORACLE_HOME/bin:$PATH
ENV ADR_BASE_LISTENER=$ORACLE_HOME

# Change some directories permissions
RUN chmod 01777 /var/tmp/.oracle
RUN chmod 6751 $ORACLE_HOME/bin/oracle
RUN chmod 777 /opt/oracle/product/18c/dbhomeXE/network/log

# Change TNS and listener configuration
COPY "listener.ora" "/home/"
COPY "tnsnames.ora" "/home/"

RUN cp -f /home/listener.ora /opt/oracle/product/18c/dbhomeXE/network/admin/
RUN cp -f /home/tnsnames.ora /opt/oracle/product/18c/dbhomeXE/network/admin/

# Create a startup script
RUN echo $'./etc/init.d/oracle-xe-18c start || :\nlsnrctl start || :' >> /opt/startup.sh
RUN chmod +x /opt/startup.sh

RUN rm oracle-database-xe-18c-1.0-1.x86_64.rpm