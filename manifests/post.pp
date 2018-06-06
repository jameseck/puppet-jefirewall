# ==Class: jefirewall::post
#
class jefirewall::post (
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

  $jefirewall_post_rules = lookup({ name => 'jefirewall::post::rules', merge => { 'strategy' => $strategy }, default => {}, })

  validate_hash($jefirewall_post_rules)

  create_resources('firewall', $jefirewall_post_rules, { 'before' => undef } )

}
