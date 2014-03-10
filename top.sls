### Top-level SaLt State - map state modules to minions
### http://docs.saltstack.com/ref/states/top.html
##########################################

base:
  '*':
    - sys_packages
    - users

  # Salt masters
  'mr-*':
    - saltlick

  # Chippery is an integrated set of formulas for configuring
  # development and production web stacks from top to bottom.
  'chippery:enabled:True':
    - match: pillar
    - chippery
