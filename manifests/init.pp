class jefirewall (
  Boolean $inherit_defaults = true,
  Hash $rules               = {},
  Boolean $purge            = true,
) {

  resources { 'firewall':
    purge => $purge,
  }

  Firewall {
    before  => Class['jefirewall::post'],
    require => Class['jefirewall::pre'],
  }

  class { 'firewall': }

  Class['firewall::linux']
  -> class { 'jefirewall::pre':  }
  -> class { 'jefirewall::post': }

  # The rules hash is auto-populated from hiera.
  # If we want to inherit_defaults, then we need to use hiera_hash,
  # otherwise we default to the $rules class parameter.
  if ( $inherit_defaults == true ) {
    $strategy = 'deep'
  } else {
    $strategy = 'first'
  }

  $jefirewall_rules = lookup({ name => 'jefirewall::rules', merge => { 'strategy' => $strategy }, default_value => {}, })

  validate_hash($jefirewall_rules)

  create_resources ( 'firewall', $jefirewall_rules )

}
