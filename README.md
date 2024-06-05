# Install Script to APT Auto Update a Zoom Deb Package

* Install downloader script and configure apt by running 'apt-auto-zoom-install.sh'.
* Can be part of an Ansible playbook.
* Next manual steps would be:
```
apt update
apt install zoom
```
* Combined with apt unattended update zoom will be kept up-to-date along with
  all other packages on your system.
