#
# Top-level SaLt State - maps state modules to minions
########################################################################
#
# Compound matcher quick reference:
#
# G *   Grains glob
# E     PCRE minion ID
# P *   Grains PCRE
# L     List of minions
# I *   Pillar glob
# J *   Pillar PCRE
# S     Subnet/IP address
# R     Range cluster
# 
# '*' Indicates an alternative delimiter to ':' may
# be specified between the letter and '@' character.

base:
  # Ubiquitous states/formulas
  '*':
    # System-level state formulas
    - system.state.packages
    - system.state.swapfile
    - system.state.timezone

    # System user accounts
    - users
    - homeboy     # Install dotfiles and packages for system administrators


  # Activate simple formulas on the existence of matching grains or pillars
  {% for formula in (
    'saltlick',
    'httpbin',
    'uwsgi_emperor',
  ) %}
  '@G:{{ formula }} or @P:{{ formula }}':
    - {{ formula }}
  {% endfor %}


  # 
  'P@cluster_rank:sovereign or P@cluster_rank:noble':
    - salt-formula
    - gitlab
