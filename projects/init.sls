# Standardised setup for (currently just Django) projects.
##########################################################

### Django projects
### Basic stack: Nginx + uWSGI + Virtualenv + Supervisord

{% if pillar.get('django_projects') %}

# Python and web server setup
include:
  - python
  - nginx

/etc/nginx/sites-enabled/default:
  file:
    - absent

/etc/nginx/uwsgi_params:
  file.managed:
    - source: salt://projects/templates/uwsgi_params
    - mode: 444

# TODO: Let projects specify system package requirements.
# First line is for pillow, second line's for postgresql
{% set postgres_pkg = 'postgresql-9.1' %}
{% for system_pkg in (
  'python-dev', 'python-setuptools',
  postgres_pkg, 'python-psycopg2', 'libpq-dev',
  'supervisor',
) %}
{{ system_pkg }}:
  pkg.installed
{% endfor %}

{% endif %}


### The projects
{% for deploy_name, project in pillar.get('django_projects', {}).items() %}

# Source (git) checkout
{{ deploy_name }}-checkout:
  git.latest:
    - name: {{ project.git_url }}
    {% if 'rev' in project %}
    - rev: {{ project['rev'] }}
    {% endif %} 
    - target: /opt/proj/{{ deploy_name }}

/opt/proj/{{ deploy_name }}:
  file.directory:
    - user: www-data
    - group: www-data
    - recurse:
      - user
      - group

# Virtualenv
/opt/venv/{{ deploy_name }}:
  virtualenv.managed:
    {% if 'requirements' in project %}
    - requirements: /opt/proj/{{ deploy_name }}/{{ project.requirements }}
    {% endif %}
  require:
    - pip.installed: virtualenv

# Virtualenvwrapper association between project & virtualenv
/opt/venv/{{ deploy_name }}/.project:
  file.managed:
    - mode: 444
    - contents: /opt/proj/{{ deploy_name }}

# Database and database user
{{ deploy_name }}:
{% for obj in ('database', 'user'): %}
  postgres_{{ obj }}:
    - present
    - require:
      - pkg: {{ postgres_pkg }}
{% endfor %}

{% for user in project.get('db_admins', []): %}
{{ deploy_name }}-no-db-user:
  postgres_user.absent:
    - name: {{ user }}
{% endfor %}
#{% for user in project.get('db_admins', []): %}
#{{ deploy_name }}-db_user-{{ user }}:
#  postgres_user.present:
#    # TODO: Work out how to do postgres groups etc. properly in Salt
#    - superuser: true
#    - password: insecure
#    - name: {{ user }}
#{% endfor %}

# Envdir (flat files whose names/contents form environment keys/values)
{% if 'envdir' in project and 'env' in project: %}
{% for key, value in project['env'].iteritems(): %}
/opt/proj/{{ deploy_name }}/{{ project['envdir'] }}/{{ key }}:
  file.managed:
    - mode: 444
    - contents: {{ value }}
{% endfor %}
{% endif %}

# Python paths
{% if 'pythonpaths' in project %}
# TODO: This currently just assumes python2.7. Fix it.
/opt/venv/{{ deploy_name }}/lib/python2.7/site-packages/_django_project_paths.pth:
  file.managed:
    - source: salt://projects/templates/pythonpath_config.pth
    - mode: 444
    - template: jinja
    - context:
        base_dir: /opt/proj/{{ deploy_name }}
        paths: {{ project['pythonpaths'] }}
{% endif %}

# Additional libraries required by the project, sourced via git
{% if 'libdir' in project and 'libs' in project: %}
{% for dest, git_url in project['libs'].iteritems(): %}
{{ deploy_name }}-lib-{{ dest }}:
  git.latest:
    - name: {{ git_url }}
    - target: /opt/proj/{{ deploy_name }}/{{ project['libdir'] }}/{{ dest }}
{% endfor %}
{% endif %}

# Post-install hooks
{% if 'post_install' in project: %}
{% for hook in project['post_install']: %}
{{ deploy_name }}-post_install-{{ hook }}:
  cmd.run:
    - cwd: /opt/proj/{{ deploy_name }}
    - name: {{ hook }}
    - user: root
{% endfor %}
{% endif %}

# Supervisor uWSGI task
{% if 'wsgi_module' in project: %}
{{ deploy_name }}-pip-uwsgi:
  pip.installed:
    - name: uWSGI
    - bin_env: /opt/venv/{{ deploy_name }}/bin/pip

/etc/supervisor/conf.d/{{ deploy_name }}.conf:
  file.managed:
    - source: salt://projects/templates/supervisor-uwsgi.conf
    - mode: 444
    - template: jinja
    - context:
        program_name: {{ deploy_name }}
        wsgi_module: {{ project['wsgi_module'] }}
        settings_module: {{ project['settings_module'] }}
        uwsgi_bin: /opt/venv/{{ deploy_name }}/bin/uwsgi
        # TODO: Remove this assumption about project-local var/log dirs...
        socket: /opt/proj/{{ deploy_name }}/var/uwsgi.sock
        uwsgi_log: /opt/proj/{{ deploy_name }}/var/log/uwsgi.log
        virtualenv: /opt/venv/{{ deploy_name }}

supervisor-update-{{ deploy_name }}:
  module.wait:
    - name: supervisord.update
    - watch:
      - file: /etc/supervisor/conf.d/{{ deploy_name }}.conf

run-{{ deploy_name }}-uwsgi:
  supervisord:
    - name: {{ deploy_name }}
    {% if 'run_uwsgi' in project and project['run_uwsgi']: -%}
    - running
    {%- else -%}
    - dead
    {%- endif %}

# Nginx hook-up
/etc/nginx/sites-available/{{ deploy_name }}.conf:
  file.managed:
    - source: salt://projects/templates/nginx-uwsgi-proxy.conf
    - mode: 444
    - template: jinja
    - context:
        project_name: {{ deploy_name }}
        project_root: /opt/proj/{{ deploy_name }}
        upstream_server: unix:///opt/proj/{{ deploy_name }}/var/uwsgi.sock
        port: {{ project['port'] }}
        servers: {{ project['nginx_servers'] }}

{% if project.get('enabled', false) %}
{{ deploy_name }}-nginx:
  service.running:
    - name: nginx
    - reload: True
    - watch:
      - file: /etc/nginx/sites-enabled/{{ deploy_name }}.conf
  file.symlink:
    - name: /etc/nginx/sites-enabled/{{ deploy_name }}.conf
    - target: /etc/nginx/sites-available/{{ deploy_name }}.conf
{% endif %}


{% endif %}   # End if 'wsgi_module' in project

{% endfor %}  # End for deploy_name, project in django_projects
