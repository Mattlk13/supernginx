class roles::containers {
  $domains = {'dario.com' => 3001}
  $domains.each |String $domain, Integer $port| {
    docker::run { "$domain":
      image    => 'tutum/lamp',
      ports    => ["$port:80"],
      hostname => $domain,
      volumes  => ["/vagrant/sites/$domain/www:/var/www"],
    }
  }
}
