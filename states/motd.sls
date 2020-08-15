/etc/motd:
  file.managed:
    - user: root
    - group: root
    - mode: 0644
    - source: salt://files/motd.j2
    - template: jinja
