# /srv/salt/formulas/network/init.sls
{% from "map.jinja" import network with context %}

include:
  - service
  - network