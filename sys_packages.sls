#
# System-wide packages to be installed
##########################################

# Standard system packages
{% if 'system_packages' in pillar %}
system_packages:
  pkg.installed:
    - pkgs:
      {% for pkg in pillar['system_packages'] %}
      - {{ pkg }}
      {% endfor %}
{% endif %}

# System-Python packages
{% if 'system_python_packages' in pillar %}

system_python_pip:
  pkg.installed:
    - name: python-pip

{% for py_pkg in pillar['system_python_packages'] %}
system_python_{{ py_pkg }}: 
  pip.installed:
    - name: {{ py_pkg }}
    - require:
      - pkg: system_python_pip
{% endfor %}

{% endif %}   # End if 'system_python_packages' in pillar
