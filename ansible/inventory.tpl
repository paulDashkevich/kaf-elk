[target]
iscsi    ansible_host=${ip[0]} ansible_subnet1=${int_ip[0]} ansible_subnet2=${int_ip2[0]}
[web_pcm]
web0     ansible_host=${ip[1]} ansible_subnet1=${int_ip[1]} ansible_subnet2=${int_ip2[1]}
web1     ansible_host=${ip[2]} ansible_subnet1=${int_ip[2]} ansible_subnet2=${int_ip2[2]}
[pr]
proxy    ansible_host=${ip[3]} ansible_subnet1=${int_ip[3]} ansible_reverseproxy_ip=${proxy_reverse_ip[0]}
[sql]
proxysql ansible_host=${ip[4]} ansible_subnet1=${int_ip[4]}
db1      ansible_host=${ip[5]} ansible_subnet1=${int_ip[5]}
db2      ansible_host=${ip[6]} ansible_subnet1=${int_ip[6]}
db3      ansible_host=${ip[7]} ansible_subnet1=${int_ip[7]}
[logs]
elk_1    ansible_host=${ext_elk[0]} ansible_subnet2=${elk_ip[0]}
[kafka]
kafka_1  ansible_host=${ext_kafka[0]} ansible_subnet2=${kafka_ip[0]}