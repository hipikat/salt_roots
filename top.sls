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

    # System user accounts
    - users
    - homeboy     # Install dotfiles and packages for system administrators

    # Basic web-serving services
    - nginx
    - php

    # "Yes, Salt can Salt itself!"
    # https://github.com/saltstack-formulas/salt-formula/
    # (Note: probably not desirable in top.sls)
    #- salt.master
    #- salt.minion
    #- salt.formulas
