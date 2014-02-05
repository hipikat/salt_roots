### System-wide packages to be installed
##########################################

# Standard Debian/Ubuntu packages
required_sys_pkgs:
  pkg.installed:
    - pkgs:
      - git               # Version control

useful_sys_pkgs:
  pkg.installed:
      - exuberant-ctags   # Parsing code in Vim
      - mosh              # Persistent ssh sessions
      - screen            # Terminal window management
