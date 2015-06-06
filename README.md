Superngingx

A fast horizontally scalable cloud friendly control panel
## Software requirements

- <a href="https://www.vagrantup.com/">Vagrant</a>
- <a href="https://www.virtualbox.org/">Virtualbox</a>
This has been tested under:

  - Mac OS X + Virtualbox

## Start the VM

- Virtualbox: `vagrant up --provider=virtualbox`

This takes a while to start.

You need to redirect your local 80 port to the port 8080 and add panel.supernginx.com to your /etc/hosts file pointing to localhost ex:

#echo "127.0.0.1	panel.supernginx.com" >> /etc/hosts
#ssh user@localhost -L 80::8080
