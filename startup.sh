/etc/init.d/oracle-xe-18c start || :
#su oracle
lsnrctl set current_listener XE || :
lsnrctl save_config || :
lsnrctl reload || :
/bin/bash