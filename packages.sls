install_nginx:
  pkg.installed:
    - name: nginx

start_nginx:
  service.running:
    - name: nginx
    - enable: True
    - require:
      - pkg: install_nginx

apache:
  pkg.installed:
    - name: {{pillar['apache']}}

git:
  pkg.installed:
    - name: {{pillar['git']}}