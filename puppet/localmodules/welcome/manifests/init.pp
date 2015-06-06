class welcome {
#Making the ssh daemon to read from motd and to dismiss last login
file { sshd_config :
	path => '/etc/ssh/sshd_config',
	notify  => Service["sshd"],
	content => 'AcceptEnv LANG LC_*
ChallengeResponseAuthentication no
GSSAPIAuthentication no
PermitRootLogin yes
PrintMotd yes
Subsystem sftp /usr/libexec/openssh/sftp-server
UseDNS no
UsePAM yes
X11Forwarding yes
PrintLastLog no',
}


#the welcome message comes here
file { motd :
	path => '/etc/motd',
	notify  => Service["sshd"],
	content => "Welcome to the Bashton network.\nUnauthorized access strictly prohibited.\n",
	ensure => present,
}
#declare the service in order to restart it on files refresh
service { sshd :
	ensure => running,
	require => FILE['sshd_config'],
}
}
