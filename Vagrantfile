# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  
  config.vm.hostname = "buda1"

  config.vm.box = "debian/jessie64"
  
  config.vm.network :forwarded_port, guest: 13598, host: 13598 # couchdb
  config.vm.network :forwarded_port, guest: 13180, host: 13180 # jena-fuseki

  config.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
  end
  
  config.vm.provision "tools", type: "shell", path: "scripts/tools.sh"
  config.vm.provision "oracle-jdk", type: "shell", path: "scripts/oracle-jdk.sh"
  config.vm.provision "node-js", type: "shell", path: "scripts/node-js.sh"
  config.vm.provision "couchdb", type: "shell", path: "scripts/couchdb.sh"
  config.vm.provision "couchapp", type: "shell", path: "scripts/couchapp.sh"
  config.vm.provision "fuseki", type: "shell", path: "scripts/fuseki.sh"
end
