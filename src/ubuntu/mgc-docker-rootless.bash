sudo apt-get -y install uidmap

sudo modprobe nf_tables

rm -f /etc/apparmor.d/home.ubuntu.bin.rootlesskit

cat <<EOT | sudo tee "/etc/apparmor.d/home.ubuntu.bin.rootlesskit"
# ref: https://ubuntu.com/blog/ubuntu-23-10-restricted-unprivileged-user-namespaces
abi <abi/4.0>,
include <tunables/global>

/home/ubuntu/bin/rootlesskit flags=(unconfined) {
  userns,

  # Site-specific additions and overrides. See local/README for details.
  include if exists <local/home.ubuntu.bin.rootlesskit>
}
EOT

sudo systemctl restart apparmor.service

curl -fsSL https://get.docker.com/rootless | sh

echo 'export PATH=/home/ubuntu/bin:$PATH' >> .bashrc
echo 'export DOCKER_HOST=unix:///run/user/1000/docker.sock' >> .bashrc
