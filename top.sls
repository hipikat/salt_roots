#
# Top-level SaLt State - maps state modules to minions
########################################################################

base:
  '*':
    # Admin users with shell access
    - users

  'mr-*':
    - match: pcre
    # Super-master configurator. Syncs salt roots, formulas, pillars, etc.
    # and sets up salt-cloud providers (etc.) from a 'secrets' pillar.
    #'saltlick:enabled:True':
    - saltlick
    # Install admin users' dotfiles and requested system & python packages.
    - homeboy

  # Instances of maps syndicated by Chippery projects
  'chippery:syndicated:True':
    - match: grain
    - homeboy

  # Chippery is a set of integrated formulas for configuring & commissioning
  # WSGI-based projects, for development and production.
  'chippery:enabled:True':
    - match: pillar
    - chippery
