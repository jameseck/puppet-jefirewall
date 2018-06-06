class je_firewall (
  Boolean $inherit_defaults = true,
  Hash $rules               = {},
  Boolean $purge            = true,
) {

  resources { 'firewall':
    purge => $purge,
  }

  Firewall {
    before  => Class['je_firewall::post'],
    require => Class['je_firewall::pre'],
  }

  class { 'firewall': }

  Class['firewall::linux']
  -> class { 'je_firewall::pre':  }
  -> class { 'je_firewall::post': }

  # The rules hash is auto-populated from hiera.
  # If we want to inherit_defaults, then we need to use hiera_hash,
  # otherwise we default to the $rules class parameter.
  if ( $inherit_defaults == true ) {
    $strategy = 'deep'
  } else {
    $strategy = 'first'
  }

  $je_firewall_rules = lookup({ name => 'je_firewall::rules', merge => { 'strategy' => $strategy }, })

  validate_hash($je_firewall_rules)

  create_resources ( 'firewall', $je_firewall_rules )

}
