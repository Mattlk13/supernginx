define containers::runcontainers(String $hostname, Integer $port) {
  docker::run { "$hostname":
    image    => 'tutum/lamp',
    ports    => ["$port:80"],
    hostname => $hostname,
    volumes  => ["/vagrant/sites/$hostname/www:/var/www"],
  }
}

