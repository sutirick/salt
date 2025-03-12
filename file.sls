copy_file:
  file.managed:
    - name: /etc/myconfig.conf
    - source: salt://myconfig.conf
    - user: root
    - group: root
    - mode: 644