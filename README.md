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
terraform --apply-autoapprove
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
