#
# Top-level SaLt State - maps state modules to minions
########################################################################

base:

  # All minions under our control
  '*':
    # Ubiquitous states
    #- common
    # Install any 'system_packages' and 'system_python_packages' in pillars
    - system.system_packages
    # Make 'MAX_LINE_LENGTH = 99' in the module responsible for Python style
    - system.pep8-linelength99
    # Set timezone to Australia/Perth
    - system.tz-australia-perth
    # Admin users with shell accounts
    - users

  # Dormant boxes used to make seed images
  '*-stem-*':
    - homeboy

  # All Salt masters
  'mr-*|hrm-*':
    - match: pcre
    # Super-master configurator. Syncs salt roots, formulas, pillars, etc.
    # and sets up salt-cloud providers (etc.) from a 'secrets' pillar.
    - saltlick
    # Install admin users' dotfiles and requested system & python packages
    - homeboy

  # A personal utility box and general master controller/hub/home/den/kennel
  'mr-bones':
    - git-server

  # Chippery is a set of integrated formulas for configuring & commissioning
  # WSGI-based projects, for development and production.
  'chippery:enabled:True':
    - match: pillar
    - chippery

  # Nedsaver.org campaign website
  'nedsaver.org':
    - homeboy
