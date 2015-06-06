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

}
