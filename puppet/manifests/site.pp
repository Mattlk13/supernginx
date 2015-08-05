# Stop Puppet's annoying allow_virtual warnings

Package {
  allow_virtual => false,
}

notice "Profile: ${profile}"
hiera_include('classes')
