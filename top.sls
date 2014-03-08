### Top-level SaLt State - map state modules to minions
### http://docs.saltstack.com/ref/states/top.html
##########################################

base:
  '*':
    - packages
    - users

  # Salt masters
  'mr-*':
    - saltlick

  'chippery:enabled:True':
    - match: pillar
    - chippery
