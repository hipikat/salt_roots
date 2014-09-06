#!stateconf -o yaml . jinja
#
# System-wide packages to be installed
########################################################################


# Standard system packages
{% if 'system_packages' in pillar %}
.Install system packages from pillar['system_packages']:
  pkg.installed:
    - pkgs:
      {% for pkg in pillar['system_packages'] %}
      - {{ pkg }}
      {% endfor %}
{% endif %}


# System-Python packages
{% if 'system_python_packages' in pillar %}

.Install system-Python Pip package:
  pkg.installed:
    - name: python-pip

{% for py_pkg in pillar['system_python_packages'] %}
.Install {{ py_pkg }} in system-Python: 
  pip.installed:
    - name: {{ py_pkg }}
{% endfor %}

{% endif %}   # End if 'system_python_packages' in pillar
