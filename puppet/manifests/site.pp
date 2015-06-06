# Stop Puppet's annoying allow_virtual warnings

Package {
  allow_virtual => false,
}

hiera_include('classes')
