# Тестовое задание на SaltStack
## 1. Установка SaltStack
### 1.1. Поднять две VM под управлением Debian 10
Самым быстрым и простым способом поднять лабораторную работу является Vagrant.
Создаем Vagrantfile для инициализации наших master и minion:

    os = "debian/buster64"
  
    # Salt Master
    config.vm.define "master" do |master|
      master.vm.hostname = "master"
      master.vm.box = os
      master.vm.network "private_network", ip: "192.168.0.10"
      end
      
    # Salt Minion
    config.vm.define "minion" do |minion|
      minion.vm.hostname = "minion"
      minion.vm.box = os
      minion.vm.network "private_network", ip: "192.168.0.11"
    end
И поднимаем наши виртуальные машины командой `vagrant up`

### 1.2-3. Установка Salt на master и minion машины
Воспользуемся bootstrap скриптом для установки salt. Использование флага `-M` установит master версию

    root@master:~# wget https://bootstrap.saltstack.com -O install_salt.sh
    root@master:~# sh install_salt.sh    #Optional -M
    
Чтобы удостовериться в успешной установке проверим версии Python и Salt на master-машине:

    root@master:~# python3 --version
    Python 3.7.3
    root@master:~# salt-master --version
    salt-master 3001.1
    
и на minion-машине:

    root@master:~# python3 --version
    Python 3.7.3
    root@master:~# salt-minion --version
    salt-minion 3001.1
    
### 1.4-6. Настроить связность master-minion

Следующим шагом является настройка конфиг-файлов для нашего master'a и minion'a. Простейший файл конфигурации master'a:

    interface: 192.168.0.10
    
и файл конфигурации minion'a:

    master: 192.168.0.10
    
После рестарта процессов наблюдаем на master'е непринятый ключ от minion'a:

    root@master:~# salt-key
    Accepted Keys:
    Denied Keys:
    Unaccepted Keys:
    minion
    Rejected Keys:
    
Значит мы всё настроили правильно! Принимаем ключ minion'a командой `salt-key --accept=minion` и пробуем пропинговать:

    root@master:~# salt minion test.ping
    minion:
        True
        
Связность настроена!

### 1.7. Сбор grains с minion'a

Завершающим этапом первого задания является сбор данных о нашем minion'e

    root@master:~# salt minion grains.items
    
Вывод команды прилагаю в файле output_1.7.txt

## 2. Файл состояния

Разобьем нашу задачу на несколько подзадач. Для установки игры supertux из исходников нам необходимо:
1. Установить все необходимые библиотеки
2. Загрузить исходники с репозитория supertux
3. Скомпилировать игру
Все данные пункты будем выполнять в отдельных блоках.
### 2.1. Установка библиотек
При помощи модуля `pkg.installed` устанавливаем все необходимые зависимости для нашей игры. Полный список зависимостей можно найти на сайте разработчика https://www.supertux.org. Модуль установки библиотек выглядит так:

    install_requirements:
      pkg.installed:
        - pkgs:
          - git
          - build-essential
          - cmake
          - subversion
          - autoconf
          - automake
          - jam
          - g++
          - libfreetype6
          - libsdl2-dev
          - libsdl2-image-dev 
          - libphysfs-dev
          - libvorbis-dev
          - libogg-dev
          - libopenal-dev
          - libfreetype6-dev
          - libcurl3-dev
          - libboost-all-dev
          - libglew-dev
  
### 2.2. Загрузка исходных файлов
Скачать исходники можно как с сайта разработчика, так и с git'a, что намного удобней и проще. Не забываем обновить сабмодули! Модуль загрузки исходных файлов выглядит так:

    download_supertux:
      git.latest:
        - name: https://github.com/SuperTux/supertux.git 
        - rev: master
        - target: /usr/games/supertux
      cmd.run:
        - cwd: /usr/games/supertux
        - name: "git submodule update --init --recursive"
        
### 2.3. Компилирование supertux
Последний, и самый ответственный этам - сборка игры из исходников. Модуль сборки выглядит так:

    install_supertux:
      file.directory:
        - name: /usr/games/supertux/build
      cmd.run:
        - cwd: /usr/games/supertux/build
        - name: |
            cmake ..
            make
            
Полный файл состояния описывается в supertux.sls. Вывод работы salt содержится в файле output_2.txt
