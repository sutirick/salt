show_pillar:
  cmd.run:
    - name: echo "Pillar value is {{ pillar['some_value'] }}"
=