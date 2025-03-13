{% if grains['os'] == 'RedHat' %}
apache: httpd
git: git
{% elif grains['os'] == 'Debian' or grains['os'] == 'Ubuntu'%}
apache: apache2
git: git-core
{% endif %}