# Vagrant scripts for BUDA platform instanciation

The base platform is built using Vagrant and VirtualBox:

1. Install [Vagrant](https://www.vagrantup.com/downloads.html) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads).
1. [Download](https://github.com/buda-base/buda-base/archive/master.zip) or `git clone` this repository.
1. cd into the unzipped directory or git clone
1. install VirtualBox guest additions with `vagrant plugin install vagrant-vbguest`
1. run `vagrant up` to summon a local instance

Or for an AWS EC2 instance:
1. install the vbguest plugin: `vagrant plugin install vagrant-vbguest`
1. and run the command: `vagrant up` or rename `Vagrantfile.aws` to `Vagrantfile` and run `vagrant up --provider=aws`

This will grind awhile installing all the dependencies of the BUDA platform.

Once the initial install has completed the command: `vagrant ssh` will connect to the instance where development, customization of the environment and so on can be performed as for any headless server.

Similarly, the jena-fuseki server will be listening on:

    http://localhost:13180/fuseki

Lds-pdi application is accessible at :

	http://localhost:13280/

(see  https://github.com/buda-base/lds-pdi/blob/master/README.md for details about using this rest services)

The command: `vagrant halt` will shut the instance down. After halting (or suspending the instance) a further: `vagrant up` will simply boot the instance without further downloads, and `vagrant destroy` will completely remove the instance. 

If running an AWS instance, after provisioning access the instance via `ssh -p 15345` and delete
`Port 22` from `/etc/ssh/sshd_config` and `sudo systemctl restart sshd`. This will further secure the instance from attacks on port 22.