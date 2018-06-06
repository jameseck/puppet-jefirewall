# ==Class: je_firewall::post
#
class je_firewall::post (
  $rules            = {},
  $inherit_defaults = true,
) {

  Firewall {
    require => undef,
  }

  # The rules hash is auto-populated from hiera.
  # If we want to inherit_defaults, then we need to use hiera_hash,
  # otherwise we default to the $rules class parameter.
  if ( $inherit_defaults == true ) {
    $strategy = 'deep'
  } else {
    $strategy = 'first'
  }

  $je_firewall_post_rules = lookup({ name => 'je_firewall::post::rules', merge => { 'strategy' => $strategy }, })

  validate_hash($je_firewall_post_rules)

  create_resources('firewall', $je_firewall_post_rules, { 'before' => undef } )

}
