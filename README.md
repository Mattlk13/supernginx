Superngingx

A fast horizontally scalable cloud friendly control panel based in puppet + nginx + padrino + mongodb + slim + ajax + all the good stuff
## Software requirements

- <a href="https://www.vagrantup.com/">Vagrant</a>
- <a href="https://www.virtualbox.org/">Virtualbox</a>
- <a href="https://rvm.io/rvm/install">rvm</a>

    Please install Vagrant and rvm from their web, not from apt or pip

This has been tested under:

  - Linux + rvm + Virtualbox
  - Mac OS X + rvm + Virtualbox

Note: If you just want to run the Padrino web panel (for development) you can just launch it (and launch also mongodb) and skip the next Vagrant stuff

## Start the VM

- Virtualbox: `vagrant up --provider=virtualbox`

It will work also with docker soon ...

This takes a while to start.

You need to redirect your local 80 port to the port 8080 and add panel.supernginx.com to your /etc/hosts file pointing to localhost ex:

#echo "127.0.0.1	panel.supernginx.com" >> /etc/hosts
#ssh user@localhost -L 80::8080

Once the machine is started, ensure you load your mongodb with data, please check Padrino documentation about setting up the admin panel superadmin and loading data via the padrino admin panel.

