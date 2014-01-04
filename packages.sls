### System-wide packages to be installed
##########################################

# Standard Debian/Ubuntu packages
global_pkgs:
  pkg.installed:
    - pkgs:
      - exuberant-ctags
      - git
      - mosh
      - screen

python-pip:
  pkg.installed

# System-Python packages
{% for system_python_pkg in (
  'flake8',
) %}
{{ system_python_pkg }}:
  pip.installed:
    - require:
      - pkg: python-pip
{% endfor %}
