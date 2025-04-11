# /srv/salt/formulas/network/network.sls
{% set network_config = salt['pillar.get']('network:interfaces', {}) %}

ensure_network_manager_running:
  service.running:
    - name: NetworkManager
    - enable: True

{% for iface, params in network_config.items() %}
configure_{{ iface }}:
  nmcli.managed:
    - name: {{ iface }}
    - conn_name: {{ params.get('conn_name', iface) }}
    - type: {{ params.type }}
    - autoconnect: True
    - state: up

    {# DHCP или статический IP #}
    {% if params.get('dhcp', False) %}
    - ip4: dhcp
    {% else %}
    - ip4: {{ params.ip }}/{{ params.get('netmask', '24') }}
    - gw4: {{ params.gateway }}
    {% endif %}

    {# DNS (если указано) #}
    {% if params.get('dns') %}
    - dns:
      {% for server in params.dns %}
      - {{ server }}
      {% endfor %}
    {% endif %}

    {# Bonding-опции #}
    {% if params.type == 'bond' %}
    - bond_opts:
      {% for opt, value in params.get('bond_opts', {}).items() %}
      - {{ opt }}={{ value }}
      {% endfor %}
    {% endif %}

    {# Slave-интерфейсы для bonding #}
    {% if params.get('slaves') %}
      {% for slave in params.slaves %}
configure_slave_{{ slave }}:
  nmcli.managed:
    - name: {{ slave }}
    - conn_name: {{ slave }}-slave
    - type: bond-slave
    - master: {{ iface }}
    - autoconnect: True
      {% endfor %}
    {% endif %}

{% endfor %}