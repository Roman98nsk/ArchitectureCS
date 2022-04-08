#!/bin/bash
echo "Дата: `date`"
echo
echo "Имя учетной записи: `whoami`"
echo
echo "Доменное имя ПК: `hostname`"
echo
echo "Процессор:"
  lscpu | grep "Имя модели"
  lscpu | grep "Архитектура"
  lscpu | grep "CPU МГц"
  lscpu | grep "CPU(s)"
  lscpu | grep "Потоков на ядро"
echo
echo "Оперативная память:"
  free -h | grep "всего" | awk '{print $1,$6}'
  free -h | grep "Память" | awk '{print $2,$7}'
echo
echo "Жесткий диск:"
  df -h --total | grep 'total' | awk '{print "Всего - " $2}'
  df -h --total | grep 'total' | awk '{print "Доступно - " $4}'
  df -h | grep '/dev/nvme0n1p2' | awk '{print "Смонтированно в корневую директорию  - " $2}'
  free -h | grep 'Подкачка' | awk '{print " Swap всего:	" $2 }'
  free -h | grep 'Подкачка' | awk '{print " Swap доступно: " $4 }'
echo

NAME_INT=$(ifconfig | cut -c 1-8 | sort | uniq -u | awk -F: '{print "" $1}')
NUM_INT=$(echo "$NAME_INT"| wc -l)
echo "Сетевые интерфейсы:"
echo "Количество сетевых интерфейсов - $NUM_INT"
echo "    №     Имя интерфейса    МАС-адрес           IP-адрес        Скорость соединения"
I=0

for INTERFACE in $NAME_INT
do
  if(($I<=$NUM_INT))
  then
    ((I++))
  fi
  MAC_ADD=$(ifconfig $INTERFACE | grep 'ether' | awk '{print "   " $2}')
  if [ -z "${MAC_ADD}" ];
  then
    MAC_ADD=$(echo "        No such device  ")
  fi
  IP_ADD=$(ifconfig $INTERFACE | grep 'inet ' | awk '{print "   " $2}')


  cd /
  CONNECTION_SPD=$((cat sys/class/net/${INTERFACE}/speed) 2> ~/Рабочий\ стол/3\ курс/АрхитектураВС/Лабораторная\ 1/Errors.txt)
  if [ -z "${CONNECTION_SPD}" ];
  then
    CONNECTION_SPD=$(echo "  No speed")
  fi
  N=-1
  if [ "${CONNECTION_SPD}" ==  "$N" ];
  then
    CONNECTION_SPD=$(echo "      0")
  fi
  echo "    $I     $INTERFACE       $MAC_ADD  $IP_ADD          $CONNECTION_SPD "
done
