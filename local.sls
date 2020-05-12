

Let's Encrypt '.well-known' direcotory:
  file.directory:
    - name: /var/lib/letsencrypt/.well-known


Let's Encrypt base directory:
  file.directory:
    - name: /var/lib/letsencrypt
    - group: www-data
    - dir_mode: g+s



