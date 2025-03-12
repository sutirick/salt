printenv:
  cmd.run:
    - env: {{ salt['pillar.get']('example:key', {}) }}