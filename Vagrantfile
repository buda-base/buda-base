# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  
  config.vm.hostname = "buda1"

  config.vm.box = "debian/stretch64"
  
  disk = 'dataDisk.vdi'
  config.vm.synced_folder ".", "/vagrant", type: "rsync",
    rsync__exclude: [ "dataDisk.vdi", ".git", ".gitignore", ".DS_Store", ".project" ],
    rsync__verbose: true
  
  config.vm.network :forwarded_port, guest: 13598, host: 13598 # couchdb
  config.vm.network :forwarded_port, guest: 13599, host: 13599 # couchdb-lucene
  config.vm.network :forwarded_port, guest: 13180, host: 13180 # jena-fuseki
  config.vm.network :forwarded_port, guest: 13190, host: 13190 # marple client
  config.vm.network :forwarded_port, guest: 13191, host: 13191 # marple admin

# need enough room for fuseki to do its thing
  config.vm.provider "virtualbox" do |vb|
      vb.memory = "8192"
      unless File.exist?(disk)
        vb.customize ['createhd', '--filename', disk, '--size', 32 * 1024]
      end
      vb.customize ['storageattach', :id,  '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk]
  end
  
# setup a second data drive for the services since the root drive is fixed at 10GB
  config.vm.provision "first-local", type: "shell", path: "scripts/first-local.sh"
  config.vm.provision "tools", type: "shell", path: "scripts/tools.sh"
  config.vm.provision "oracle-jdk", type: "shell", path: "scripts/oracle-jdk.sh"
  config.vm.provision "node-js", type: "shell", path: "scripts/node-js.sh"
  config.vm.provision "couchdb", type: "shell", path: "scripts/couchdb.sh"
  config.vm.provision "couchdb-lucene", type: "shell", path: "scripts/couchdb-lucene.sh"
# no need for couchapp (yet)
#  config.vm.provision "couchapp", type: "shell", path: "scripts/couchapp.sh"
  config.vm.provision "fuseki", type: "shell", path: "scripts/fuseki.sh"
end
