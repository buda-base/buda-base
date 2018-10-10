# buda-base
Base platform for BUDA development

The base platform is built using Vagrant and VirtualBox.

1. Install [Vagrant](https://www.vagrantup.com/downloads.html) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads). 
1. [Download](https://github.com/BuddhistDigitalResourceCenter/buda-base/archive/master.zip) or `git clone` this repository.
1. cd into the project
1. install the vbguest plugin: `vagrant plugin install vagrant-vbguest`
1. and run the command: `vagrant up` or rename `Vagrantfile.aws` to `Vagrantfile` and run `vagrant up --provider=aws`

This will grind awhile installing the following:

* Debian Jessie
* node.js
* jena-fuseki
* the BUDA Linked Data interface
* the BUDA IIIF Server and IIIF Presentatin API server
* the BUDA web editor (BLMP)
* the BUDA public library interface

Once the initial install has completed the command: `vagrant ssh` will connect to the instance where development, customization of the environment and so on can be performed as for any headless server.

Similarly, the jena-fuseki server will be listening on:

    http://localhost:13180/fuseki

Lds-pdi application is accessible at :

	http://localhost:13280/

(see  https://github.com/BuddhistDigitalResourceCenter/lds-pdi/blob/master/README.md for details about using this rest services)

The Marple web interface can be accessed at `http://localhost:13190`.

The command: `vagrant halt` will shut the instance down. After halting (or suspending the instance) a further: `vagrant up` will simply boot the instance without further downloads, and `vagrant destroy` will completely remove the instance. 

If running an AWS instance, after provisioning access the instance via `ssh -p 15345` and delete
`Port 22` from `/etc/ssh/sshd_config` and `sudo systemctl restart sshd`. This will further secure the instance from attacks on port 22.