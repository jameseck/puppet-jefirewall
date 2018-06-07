# ==Class: jefirewall::pre
#
class jefirewall::pre (
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

  $jefirewall_pre_rules = lookup({ name => 'jefirewall::pre::rules', merge => { 'strategy' => $strategy }, default_value => {}, })

  validate_hash($jefirewall_pre_rules)

  create_resources('firewall', $jefirewall_pre_rules)

}
