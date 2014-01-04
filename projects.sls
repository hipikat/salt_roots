### Standardised project setup
##########################################

### Django projects
### Basic stack: Nginx + uWSGI + Virtualenv + Supervisor

{% if pillar.get('django_projects') %}
include:
  - nginx
{% endif %}

{% for venv, project in pillar.get('django_projects', {}).items() %}

# Install the virtualenv
/opt/{{ venv }}:
  file.touch

# Ensure latest checked-out repository

{% endfor %} 
