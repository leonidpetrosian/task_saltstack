# -*- mode: ruby -*-
# vi: set ft=ruby :

# Created by Leonid Petrosian

Vagrant.configure(2) do |config|
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

end
