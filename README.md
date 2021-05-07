# kaf-elk
filebeat-kafka-logstash-elasticsearch-kibana-wordpress-corosync-pacemaker-keepalivd
_______________________

# Домашнее задание: реализация очереди для сборщика логов между logstash и elasticsearch

Цель:
настроить сбор логов с веб портала реализованного ранее настроить kafka как промежуточную очередь между logstash и elasticsearch

развернуть кафку на 1 ноде создать 2 топика по 2 шарда и 2 реплики (nginx и wordpress) на каждой ноде поставить на выбор filebeat/fluentd/vector собирать этим утилитами логи nginx и wordpress отправлять в 2 разных топика nginx и wordpress развернуть ELK на одной ноде настроить логстэш для забора данных с кафки и сохранение в 2 индекса настроить индекс паттерны в кибане

** Ход работы:
1. Изменение скрипта терраформа под создание отдельно машин под JAVA based logstash/kafka/kibana/elasticsearch с увеличенным объёмом ОЗУ и ЦПУ.
2. Добавление ролей ансибл для установки стэка ELK и KAFKA
3. Изучение принципов взаимодействия стэка ELK и сборщиками логов filebeat, управление которыми взял на себя pacemaker в кластере; изучение принципов записи, хранения и передачи очередей сообщений KAFKA
4. Создание ролей и запуск развёртывания машин.
5. Отчёт по результатам работы в виде скринов экрана и вставки stdout
*********************************
Запуск стенда начинаем с терраформа
```
terraform apply --autoapprove
```
ansible
```
ansible-playbook ansible/playbooks/environment.yml
```
Время развёртывания достаточно продолжительное. После успешной раскатки, ***НЕОБХОДИМО*** зайти на сайт и произвести первичную настройку: фейковые имена/пароли/имэйлы. Спустя время пойдёт запись в логи, которые отслеживает сборщик **filebeat.** 
Чтобы вручную не вносить индексы в кибану для процесса **Discovery** я докопался до запроса, по которому автоматически создаётся индекс. Выполнить можно так
```
ansible-playbook ansible/playbooks/environment.yml --start-at-task="elk : create index-patterns kibana"
```
Спустя буквально минуту после требуемых действий можно заходить по внешнему адресу ноды **elk_1**, указав порт 5601
```
@timestamp
May 8, 2021 @ 00:30:18.451
	
@version
1
	
_id
HL69SHkBMdAwRs99EaEl
	
_index
nginx-2021.05.07
	
_score
 - 
	
_type
_doc
	
agent.ephemeral_id
6ca4a60f-2262-4389-8a0b-4f765da690a4
	
agent.hostname
web0
	
agent.id
05ef7104-735a-49c6-80f0-a9544e5f1c3b
	
agent.name
web0
	
agent.type
filebeat
	
agent.version
7.12.1
	
auth
-
	
bytes
21855
	
clientip
152.231.61.88
	
ecs.version
1.8.0
	
fields.domashka
OTUS
	
fields.kafka_topic
nginx
	
fields.logs
err and access NGINX
	
geoip.city_name
Villa General Belgrano
	
geoip.continent_code
SA
	
geoip.country_code2
AR
	
geoip.country_code3
AR
	
geoip.country_name
Argentina
	
geoip.ip
152.231.61.88
	
geoip.latitude
-31.917
	
geoip.location.lat
-31.917
	
geoip.location.lon
-64.583
	
geoip.longitude
-64.583
	
geoip.postal_code
5194
	
geoip.region_code
X
	
geoip.region_name
Cordoba
	
geoip.timezone
America/Argentina/Cordoba
	
host.name
web0
	
httpversion
1.0
	
ident
-
	
input.type
log
	
log.file.path
/var/log/nginx/access.log
	
log.offset
10,732
	
message
152.231.61.88 - - [08/May/2021:00:30:18 +0300] "GET / HTTP/1.0" 200 21855 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"
	
referrer
"-"
	
request
/
	
response
200
	
tags
nginx, geolocation
	
timestamp
08/May/2021:00:30:18 +0300
	
verb
GET
```
Из примера видно, что заблудший аргентинец зашёл в гости.
Проверим, что задание выполнено по кафке:
```
Topic: wordpress        TopicId: lpBHcyG1QYqxCKasMoRjJg PartitionCount: 2       ReplicationFactor: 1    Configs:
        Topic: wordpress        Partition: 0    Leader: 0       Replicas: 0     Isr: 0
        Topic: wordpress        Partition: 1    Leader: 0       Replicas: 0     Isr: 0
        
Topic: nginx    TopicId: rZffGfUaR9ey0_LX4evnig PartitionCount: 2       ReplicationFactor: 1    Configs:
        Topic: nginx    Partition: 0    Leader: 0       Replicas: 0     Isr: 0
        Topic: nginx    Partition: 1    Leader: 0       Replicas: 0     Isr: 0
```
Каждый топик поделён на две парции. К сожалению, реплики не создал, так как кластер отказался строить.
Задание выполнено ✅ 
