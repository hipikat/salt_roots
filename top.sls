### Top-level SaLt State - map state moduels to minions
### http://docs.saltstack.com/ref/states/top.html
##########################################

base:
  '*':
    - packages
    - users

  'wsgi_still:enabled:True':
    - match: pillar
    - wsgi_still
