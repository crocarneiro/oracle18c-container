./etc/init.d/oracle-xe-18c start || :
lsnrctl set current_listener XE || :
snrctl save_config || :
lsnrctl reload || :