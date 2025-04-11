# /srv/salt/formulas/network/nmcli.sls
{% from "network/map.jinja" import network with context %}
{% set interfaces = salt['pillar.get']('network:interfaces', {}) %}

{% for iface, params in interfaces.items() %}
configure_{{ iface }}:
  nmcli.managed:
    - name: {{ iface }}
    - conn_name: {{ params.get('conn_name', iface) }}
    - type: {{ params.type }}
    - autoconnect: {{ params.get('autoconnect', True) }}

    {# DHCP или статический IP #}
    {% if params.get('dhcp', False) %}
    - ip4: dhcp
    {% else %}
    - ip4: {{ params.ip }}/{{ params.get('netmask', '24') }}
    - gw4: {{ params.gateway }}
    {% endif %}

    {# DNS #}
    {% if params.get('dns') %}
    - dns: {{ params.dns | to_json }}
    {% endif %}

    {# Опции для bonding #}
    {% if params.type == 'bond' %}
    - bond_opts: {{ params.get('bond_opts', {}) | dictsort | join(',') }}
    {% endif %}

    {# Slave-интерфейсы #}
    {% for slave in params.get('slaves', []) %}
configure_slave_{{ slave }}:
  nmcli.managed:
    - name: {{ slave }}
    - conn_name: {{ slave }}-slave
    - type: bond-slave
    - master: {{ iface }}
    - autoconnect: True
    - require:
      - nmcli: configure_{{ iface }}
    {% endfor %}

{% endfor %}