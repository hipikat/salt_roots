#
# Top-level SaLt State - maps state modules to minions
########################################################################

base:
  # All minions under our control
  '*':
    - system.all    # System-level state formulas
    - users         # Admin users with shell accounts
    - homeboy       # Install admins' dotfiles & preferred packages

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
