# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  require 'fileutils'
  if(ENV['BUDA_PROPS'])
    FileUtils.cp_r( ENV['BUDA_PROPS'] , "conf/shared/etc/buda" )
  else
    puts("BUDA_PROPS env variable is not set : using default configuration !")
  end


  config.vm.hostname = "buda-local"

  config.vm.box = "debian/stretch64"

  disk = 'dataDisk.vdi'
  config.vm.synced_folder ".", "/vagrant", type: "rsync",
    rsync__exclude: [ "dataDisk.vdi", ".git", ".gitignore", ".DS_Store", ".project" ],
    rsync__verbose: true

  config.vm.network :forwarded_port, guest: 13180, host: 13180 # jena-fuseki
  config.vm.network :forwarded_port, guest: 13190, host: 13190 # marple client
  config.vm.network :forwarded_port, guest: 13191, host: 13191 # marple admin
  config.vm.network :forwarded_port, guest: 13280, host: 13280 # lds-pdi
  config.vm.network :forwarded_port, guest: 13380, host: 13380 # blmp
  config.vm.network :forwarded_port, guest: 13480, host: 13480 # iiifpres
  config.vm.network :forwarded_port, guest: 13580, host: 13580 # iiifserv
  config.vm.network :forwarded_port, guest: 13780, host: 13780 # githubmail
  config.vm.network :forwarded_port, guest: 13581, host: 13581 # iiifserv monitoring
  config.vm.network :forwarded_port, guest: 13680, host: 13680 # public library
  config.vm.network :forwarded_port, guest: 13880, host: 13880 # edition server

# need enough room for fuseki to do its thing
  config.vm.provider "virtualbox" do |vb|
      vb.memory = "8192"
      unless File.exist?(disk)
        vb.customize ['createhd', '--filename', disk, '--size', 48 * 1024]
      end
      vb.customize ['storageattach', :id,  '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk]
  end

# setup a second data drive for the services since the root drive is fixed at 10GB
  config.vm.provision "first-local", type: "shell", path: "scripts/first-local.sh"
  config.vm.provision "open-jdk", type: "shell", path: "scripts/open-jdk.sh"
  config.vm.provision "tools", type: "shell", path: "scripts/tools.sh"
  config.vm.provision "config", type: "shell", path: "scripts/config.sh"
  config.vm.provision "node-js", type: "shell", path: "scripts/node-js.sh"
  config.vm.provision "fuseki", type: "shell", path: "scripts/fuseki.sh"
  config.vm.provision "lds-pdi", type: "shell", path: "scripts/ldspdi.sh"
  config.vm.provision "iiifpres", type: "shell", path: "scripts/iiifpres.sh"
  config.vm.provision "iiifserv", type: "shell", path: "scripts/iiifserv.sh"
  config.vm.provision "editserv", type: "shell", path: "scripts/editserv.sh"
  config.vm.provision "githubmail", type: "shell", path: "scripts/githubmail.sh"
  config.vm.provision "blmp", type: "shell", path: "scripts/blmp.sh"
  config.vm.provision "pdl", type: "shell", path: "scripts/pdl.sh"
  config.vm.provision "nginx", type: "shell", path: "scripts/nginx.sh"
  config.vm.provision "letsencrypt", type: "shell", path: "scripts/letsencrypt.sh"
end
