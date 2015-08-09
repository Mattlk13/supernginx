class roles::containers {
  create_resources( containers::runcontainers, hiera("domains") )
}
