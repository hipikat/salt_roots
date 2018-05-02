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
    - system.packages
    - system.swapfile
    - system.timezone

    - users       # System user accounts
    - homeboy     # Install dotfiles and packages for system administrators
    - nvm.source  # Node Version Manager

    - fix.all     # Corrections, like owners or permission that may slip


  # Activate simple formulas on the existence of matching grains or pillars
  {% for formula in (
    'saltlick',
    'httpbin',
  ) %}
  '@G:{{ formula }} or @P:{{ formula }}':
    - {{ formula }}
  {% endfor %}
