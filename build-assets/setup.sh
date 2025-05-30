#!/bin/sh
pkg install -y podman-suite
cp /usr/local/etc/containers/pf.conf.sample /etc/pf.conf
sed -i '' 's/ix0/vtnet0/' /etc/pf.conf
echo -e "net.ip.forwarding=1\nnet.pf.filter_local=1" >> /etc/sysctl.conf
service pf enable
service pf start
sysctl net.inet.ip.forwarding=1
sysctl net.pf.filter_local=1
mkdir -p /usr/local/etc/cni/net.d/
cp build-assets/podman-bridge.conflist /usr/local/etc/cni/net.d/
sed -i '' -e 's/driver = "zfs"/driver = "vfs"/' /usr/local/etc/containers/storage.conf
