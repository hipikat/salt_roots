# Nginx setup
#############

nginx:
  pkg:
    - installed

/etc/nginx/nginx.conf:
  file.managed:
    - template: jinja
    - user: root
    - group: root
    - mode: 440 
    - source: salt://nginx/nginx.conf
    - require:
      - pkg: nginx
