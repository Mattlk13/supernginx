$script = <<SCRIPT
if [ ! -f /usr/bin/puppet ]; then
    cd /tmp
    wget https://apt.puppetlabs.com/puppetlabs-release-wheezy.deb
    dpkg -i puppetlabs-release-wheezy.deb
    apt-get update
    apt-get -y install puppet-common mongodb-server
    sed -i '/^templatedir/ d'  /etc/puppet/puppet.conf
fi
if [ ! -d /etc/puppet/modules/nginx ]; then
    puppet module install jfryman-nginx
fi
if [ ! -d /etc/puppet/modules/mysql ]; then
    puppet module install puppetlabs-mysql
fi
if [ ! -d /etc/puppet/modules/stdlib ]; then
    puppet module install puppetlabs-stdlib
fi
if [ ! -d /etc/puppet/modules/dovecot ]; then
    puppet module install example42-dovecot
fi
if [ ! -d /etc/puppet/modules/postfix ]; then
    puppet module install thias-postfix
fi
if [ ! -d /etc/puppet/modules/mailman ]; then
    puppet module install thias-mailman
fi
if [ ! -d /etc/puppet/modules/php ]; then
    puppet module install thias-php
fi
if [ ! -d /etc/puppet/modules/munin ]; then
    puppet module install ssm-munin
fi
if [ ! -d /etc/puppet/modules/mongodb ]; then
    puppet module install puppetlabs-mongodb
fi
if [ ! -d /etc/puppet/modules/timezone ]; then
    puppet module install bashtoni-timezone
fi
if [ ! -d /etc/puppet/modules/puppet-galera ]; then
    apt-get -y install git
    cd /etc/puppet/modules/
    #install the galera puppet modules
    git clone https://github.com/michaeltchapman/puppet-galera.git
fi 
if [ ! -d /usr/local/rvm ]; then
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    \curl -sSL https://get.rvm.io | bash -s stable --ruby
    source /etc/profile.d/rvm.sh
    source /usr/local/rvm/scripts/rvm
    gem install padrino
fi
cd /vagrant/panel
bundle install
echo 'Made By ⫐⟑℞∣⊔⨕'
SCRIPT

Vagrant.configure("2") do |config|

  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provider "virtualbox" do |v,override|
    override.vm.box = "puppetlabs/debian-7.8-64-nocm"
  end

  config.vm.provision :shell, inline: $script

  config.vm.provision :puppet do |puppet|
#      puppet.options = "--verbose --debug"
      puppet.manifests_path    = "puppet/manifests"
      puppet.manifest_file     = "site.pp"
      puppet.module_path       = ["puppet/localmodules"]
      puppet.hiera_config_path = 'puppet/hiera.yaml'
      puppet.facter = {
        'envname' => 'vagrant',
        'profile' => 'supernginx'
      }
  end

end
