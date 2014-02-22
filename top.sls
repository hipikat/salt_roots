### Top-level SaLt State - map state modules to minions
### http://docs.saltstack.com/ref/states/top.html
##########################################

base:
  '*':
    - packages
    - users

  'chippery:enabled:True':
    - match: pillar
    - chippery
