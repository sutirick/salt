network:
  eth1:
    type: ethernet
    ip: 192.168.2.100
    netmask: 24
    gateway: 192.168.2.1
    dns: [8.8.8.8, 8.8.4.4]
  eth2:
    type: ethernet
    ip: 192.168.2.101
    netmask: 24
    gateway: 192.168.2.1
    dns: [8.8.8.8, 8.8.4.4]
  eth3:
    type: ethernet
    ip: 192.168.2.102
    netmask: 24
    gateway: 192.168.2.1
    dns: [8.8.8.8, 8.8.4.4]
  bond1:
    type: bond
    ip: 10.1.0.50
    bond_opts:
    mode: 802.3ad
    xmit_hash_policy: layer3+4
    slaves:
      - eth2
      - eth3