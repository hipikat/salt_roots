### System-wide packages to be installed
##########################################

# Standard Debian/Ubuntu packages
required_sys_pkgs:
  pkg.installed:
    - pkgs:
      - language-pack-en  # Magic-away locale warnings
      - git               # Version control
