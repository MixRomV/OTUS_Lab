# Vagrant-стенд для обновления ядра и создания образа системы
[Цель](#pin01)

[Задание](#pin02)

[Выполнение](#pin03)

### <a id="pin01">Цель домашнего задания</a>
Научиться обновлять ядро в ОС Linux. Получение навыков работы с Vagrant.

### <a id="pin02">Описание домашнего задания</a>
1. Запустить ВМ с помощью Vagrant.
2. Обновить ядро ОС из репозитория ELRepo.
3. Оформить отчет в README-файле в GitHub-репозитории.

### <a id="pin03">Ход выполнения задания</a>
Для текущего задания был написан следующий Vagarntfile
```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

#Определяем массив с настройкам ВМ (в данном примере одна ВМ)
lab01vm=[
    {
      :hostname => "kernelUpdate",
      :cpus => 2,
      :ram => 1024,
      :box => "generic/centos8s"
    }
]

#Настраиваем главную конфигурацию vagtant
Vagrant.configure("2") do |config|
  #Оключаем дефолтную шару
  config.vm.synced_folder ".", "/vagrant", disabled: true
  #Проходим по элементам массива lab01vm
  lab01vm.each do |vms|
    #Описываем конфигурацию машин
    config.vm.define vms[:hostname] do |node|
      #Развернуть машину из образа "generic/centos8s"
      node.vm.box = vms[:box]
      #Отключаем проверку обновлений образа
      node.vm.box_check_update = false
      #Задаем hostname машины
      node.vm.hostname = vms[:hostname]
      #Тонкие настройки для конкретной платформы виртуализации (провайдера)
      node.vm.provider "virtualbox" do |vb|
        #Отключаем GUI при старте ВМ
        vb.gui = false
        #Настраивае параметры cpu
        vb.cpus = vms[:cpus]
        #Настраиваем параметры ram
        vb.memory = vms[:ram]
        #Перезаписываем имя ВМ в Vbox
        vb.name = vms[:hostname]
      end
      #Описываем действия которые будут выполнены после старта ВМ
      node.vm.provision "shell" do |script|
        #Указываем местоположение скрипта, в данном случае он в директории с Vagrantfile
        script.path = "updateKernel.sh"
      end
    end
  end
end
```

И написан небольшой скрипт для обновления ядра, который выполнится после старта ВМ
```bash
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
```
![Скриншот обновления 1](https://github.com/MixRomV/OTUS_Lab/blob/master/lab_01/Update01.png)

![Скриншот обновления 2](https://github.com/MixRomV/OTUS_Lab/blob/master/lab_01/Update02.png)

После перезагрузки ВМ, зайдем на нее и проверим версию ядра

![Скриншот обновления 2](https://github.com/MixRomV/OTUS_Lab/blob/master/lab_01/Update03.png)
