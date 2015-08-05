$script = <<SCRIPT
if [ ! -d /usr/local/rvm ]; then
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    curl -sSL https://get.rvm.io | bash -s stable --ruby
    source /etc/profile.d/rvm.sh
    source /usr/local/rvm/scripts/rvm
    gem install padrino
fi
if ! [ command -v librarian-puppet ]; then
    gem install librarian-puppet
    source /etc/profile.d/rvm.sh
fi
cd /vagrant/panel
bundle install
cd /vagrant/puppet
librarian-puppet install
rm -rf /etc/puppetlabs/code/*
ln -s /vagrant/puppet/* /etc/puppetlabs/code/
mkdir -p /etc/facter/facts.d
echo 'envtype=vagrant' >> /etc/facter/facts.d/vagrant.txt
echo 'envname=dev' >> /etc/facter/facts.d/vagrant.txt
echo 'profile=supernginx' >> /etc/facter/facts.d/vagrant.txt

export PATH=/opt/puppetlabs/puppet/bin:$PATH
/opt/puppetlabs/puppet/bin/puppet apply --color=false \
--modulepath=/etc/puppetlabs/code/localmodules:/etc/puppetlabs/code/modules \
--hiera_config=/etc/puppetlabs/code/hiera.yaml \
/etc/puppetlabs/code/manifests/site.pp

echo 'Made By ⫐⟑℞∣⊔⨕'
SCRIPT

Vagrant.configure("2") do |config|

  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provider "virtualbox" do |v,override|
    override.vm.box = "puppetlabs/ubuntu-14.04-64-puppet"
    v.memory = 2048
    v.cpus = 2
  end

  config.vm.provision :shell, inline: $script

end
