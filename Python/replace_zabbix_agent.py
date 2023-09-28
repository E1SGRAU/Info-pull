import platform 
hostname=platform.uname()[1]
file=r"/etc/zabbix/zabbix_agentd.conf"

search1="Server=127.0.0.1"
replace1="Server=51.20.12.82"
with open(r"/etc/zabbix/zabbix_agentd.conf", 'r') as file:
    data=file.read()
    data=data.replace(search1,replace1)
with open(r"/etc/zabbix/zabbix_agentd.conf", 'w') as file:
    file.write(data)

search2="ServerActive=127.0.0.1"
replace2="ServerActive=51.20.12.82"
with open(r"/etc/zabbix/zabbix_agentd.conf", 'r') as file:
    data=file.read()
    data=data.replace(search2,replace2)
with open(r"/etc/zabbix/zabbix_agentd.conf", 'w') as file:
    file.write(data)

search3="# Hostname="
replace3=f"Hostname={hostname}"
with open(r"/etc/zabbix/zabbix_agentd.conf", 'r') as file:
    data=file.read()
    data=data.replace(search3,replace3)
with open(r"/etc/zabbix/zabbix_agentd.conf", 'w') as file:
    file.write(data)
