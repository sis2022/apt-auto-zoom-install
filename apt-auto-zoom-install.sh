#!/bin/bash
# Copyright 2023, 2024 N. Radtke
# License: GPLv2

### This installer script is configuring apt and is auto-generating a script to
### be called by apt::update::pre-invoke.
script="/usr/local/sbin/getZoomDeb.sh";

url="https://zoom.us/client/latest/zoom_amd64.deb";
debDlDir="/var/cache/zoom_debdl";
aptConf="/etc/apt/apt.conf.d/100-update_zoom";
srcListFile="/etc/apt/sources.list.d/zoom_debdl.list";

sudo mkdir -p "$debDlDir";
sudo mkdir -p "$(dirname $script)";
cat <<EndOfScript | sudo tee "$script";
#!/bin/bash
### auto-generated by "$0"

url="$url";
debDlDir="$debDlDir";

canonUrl="\$(curl "\$url" -ILs -o /dev/null -w '%{url_effective}')";
filename="\$(echo "\$canonUrl" | sed 's#.*prod##g; s#/\(.*\)/zoom#zoom_\1#g')";

cd "\$debDlDir" && wget -qN --content-disposition "\$url" && apt-ftparchive packages . > Packages && apt-ftparchive release . > Release && ln -sf "\$(basename "\$url")" "\$filename";

EndOfScript
sudo chown root: "$script";
sudo chmod 755 "$script";

### inspired by: https://askubuntu.com/a/1316231/780918
echo 'APT::Update::Pre-Invoke {"'$script'"};' | sudo tee "$aptConf";
echo 'deb [trusted=yes lang=none] file:'"$debDlDir"' ./' | sudo tee "$srcListFile";

### EOF
### vim:tw=256:et:sts=2:st=2:sw=2:com+=b\:###:fo+=cqtr:tags=ctags:
