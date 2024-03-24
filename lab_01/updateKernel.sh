#!/bin/bash

#Скрипт будет выполняться в vagrant после старта ВМ
 #Версия ядра до обновления
 uname -r
 #Подключение репозиторя с новым ядром 
 sudo yum install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
 #Установка нового ядра 
 yum --enablerepo elrepo-kernel install kernel-ml -y

 #Обновление параметров GRUB
 grub2-mkconfig -o /boot/grub2/grub.cfg
 grub2-set-default 0
 echo "Grub update done."
 #Перезагрузка ВМ
 sudo reboot

