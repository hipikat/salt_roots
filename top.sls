#
# Top-level SaLt State - maps state modules to minions
########################################################################

base:
  # All minions under our control
  '*':
    # System-level state formulas
    - system.all_states
    - system.patches.pep8-linelength99
    # Admin users with shell accounts
    - users
    # Install admin users' dotfiles and requested system & Python packages
    - homeboy

  # Salt masters
  'hrm-*|mx-*':
    - match: pcre
    - saltlick      # Install Salt, roots, formulas, pillars, etc.

  # Integrated formulas for installing WSGI (etc.) projects from pillars
  'chippery:enabled:True':
    - match: pillar
    - chippery

  # A personal utility box and general master controller/hub/home/den/kennel
  'mr-bones':
    - git-server

  # Nedsaver.org campaign website
  'nedsaver.org':
    - homeboy
