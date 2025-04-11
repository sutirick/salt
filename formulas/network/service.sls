# /srv/salt/formulas/network/service.sls
{% from "map.jinja" import network with context %}

network_manager_service:
  service.running:
    - name: {{ network.service_name }}
    - enable: True
    - reload: True