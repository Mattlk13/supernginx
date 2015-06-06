# Adds the supernginx
class roles::supernginx {
class { 'nginx': }
nginx::resource::vhost { 'supernginx.com':
  www_root => '/var/www/supernginx.com',
}
nginx::resource::upstream { 'panel':
  members => [
    'localhost:3000',
  ],
}
nginx::resource::vhost { 'panel.supernginx.com':
  proxy => 'http://panel',
}
#
#  class { '::tomcat':
#    install_from_source => false,
#  } ->
#  tomcat::instance { 'default':
#    package_name => 'tomcat',
#    require      => Class['epel'],
#  } ->
#  tomcat::service { 'default':
#    use_jsvc     => false,
#    use_init     => true,
#    service_name => 'tomcat',
#  }
#
#  tomcat::setenv::entry { 'HELLO_DATEURL':
#    value       => 'http://sleepy-thicket-8107.herokuapp.com',
#    require     => Class['tomcat'],
#    config_file => '/etc/sysconfig/tomcat',
#    notify      => Tomcat::Service['default'],
#  }
#  tomcat::setenv::entry { 'HELLO_CONN_TIMEOUT':
#    value       => '1000',
#    require     => Class['tomcat'],
#    config_file => '/etc/sysconfig/tomcat',
#    notify      => Tomcat::Service['default'],
#  }
#  tomcat::setenv::entry { 'HELLO_READ_TIMEOUT':
#    value       => '5000',
#    require     => Class['tomcat'],
#    config_file => '/etc/sysconfig/tomcat',
#    notify      => Tomcat::Service['default'],
#  }
#
#  tomcat::war { 'hello-world.war':
#    war_source    => 'https://s3-eu-west-1.amazonaws.com/bashton-engineering-test/bashton-hello-world_2.10-0.1.1-SNAPSHOT.war',
#    catalina_base => '/var/lib/tomcat',
#    require       => Class['tomcat'],
#  }

}
