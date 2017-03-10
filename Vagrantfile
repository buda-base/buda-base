# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  
  config.vm.hostname = "buda1"

  config.vm.box = "debian/jessie64"
  
  config.vm.network :forwarded_port, guest:  5984, host:  5984 # couchdb
  config.vm.network :forwarded_port, guest: 13180, host: 13180 # jena-fuseki

  config.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
  end
  
  config.vm.provision :shell, path: "scripts/tools.sh"
  config.vm.provision :shell, path: "scripts/oracle-jdk.sh"
  config.vm.provision :shell, path: "scripts/node-js.sh"
  config.vm.provision :shell, path: "scripts/couchdb.sh"
  config.vm.provision :shell, path: "scripts/couchapp.sh"
  config.vm.provision :shell, path: "scripts/fuseki.sh"
end
