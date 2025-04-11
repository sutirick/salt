# /srv/salt/formulas/network/nmcli.sls
{% from "map.jinja" import network with context %}
{% set interfaces = salt['pillar.get']('network:interfaces', {}) %}

{% for iface, params in interfaces.items() %}
configure_{{ iface }}:
  cmd.run:
    - name: |
        nmcli con del "{{ params.get('conn_name', iface) }}" || true
        nmcli con add type {{ params.type }} \
          con-name "{{ params.get('conn_name', iface) }}" \
          ifname {{ iface }} \
          ipv4.method {{ 'auto' if params.get('dhcp', False) else 'manual' }} \
          {% if not params.get('dhcp', False) %}ipv4.addresses {{ params.ip }}/{{ params.get('netmask', '24') }} \
          {% if params.get('gateway') %}ipv4.gateway {{ params.gateway }}{% endif %}{% endif %}
    - unless: nmcli -g NAME con show | grep -q "{{ params.get('conn_name', iface) }}"
    - env:
      - DBUS_SESSION_BUS_ADDRESS: unix:path=/run/dbus/system_bus_socket

{% if not params.get('dhcp', False) and params.get('dns') %}
set_dns_for_{{ iface }}:
  cmd.run:
    - name: |
        nmcli con mod "{{ params.get('conn_name', iface) }}" \
          ipv4.dns "{{ params.dns|join(' ') }}"
    - unless: nmcli -g IP4.DNS con show "{{ params.get('conn_name', iface) }}" | grep -q "{{ params.dns[0] }}"
{% endif %}
{% endfor %}