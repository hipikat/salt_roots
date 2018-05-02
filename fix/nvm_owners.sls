
Set global Node Version Manager (nvm) ownership to root/wheel:
  file.directory:
    - name: /opt/nvm
    - user: root
    - group: wheel
    - recurse:
      - user
      - group
