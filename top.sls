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
    - system.swapfile
    - system.packages
    - system.filesystem
    - system.timezone

    # Local system stuff
    - users
    - homeboy     # Install dotfiles and packages for system admins


  # Basic web-serving capabilities
  'G@services:web:True or G@services:wordpress:True':
    - nginx
    - letsencrypt

  # Application-specific and standalone-service matching
  'G@services:mysql:True G@services:wordpress:True':
    - mysql

  'G@services:php:True G@services:wordpress:True':
    - php

  'G@services:vsftpd:True G@services:wordpress:True':
    - vsftpd      # Look, Wordpress likes to do FTP over SSL for their
                  # updates, and who am I to try to stop them?
