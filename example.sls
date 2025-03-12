show_pillar:
  cmd.run:
    - name: echo "Pillar value is {{ pillar.get['some_value'] }}"
=