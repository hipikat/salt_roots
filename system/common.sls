#!stateconf -o yaml . jinja
#
# Common, generic system includes
# aka 'every good machine should have...'


.Common system packages:
  pkg.installed:
    pkgs:
      - git
