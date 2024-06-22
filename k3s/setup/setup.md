# config no password sudo
```sh
echo "ubuntu ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/ubuntu
```

# config static ip
remove/backup any existing /etc/netplan files

sudo vi /etc/netplan/99-config.yaml

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp1s0:
      addresses:
        - 192.168.2.20/22
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
        addresses: [192.168.1.1, 1.1.1.1]
```

sudo chmod 600 /etc/netplan/99-config.yaml
sudo netplan apply

# resize disk
sudo lvm
lvm> lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
lvm> exit
sudo resize2fs /dev/ubuntu-vg/ubuntu-lv

# install required packages
```sh
sudo apt update
sudo apt upgrade -y
sudo apt install -y nfs-common

wget https://repo.radeon.com/amdgpu-install/latest/ubuntu/jammy/amdgpu-install_6.1.60102-1_all.deb
sudo apt install ./amdgpu-install_6.1.60102-1_all.deb
sudo apt update
amdgpu-install
```

# install k3s on master node
curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=stable sh -s - server \
  --disable local-storage \
  --disable traefik \
  --disable servicelb \
  --disable metrics-server \
  --disable-network-policy \
  --disable-kube-proxy \
  --flannel-backend none \
  --write-kubeconfig-mode 0644 \
  --etcd-s3 \
  --etcd-s3-bucket k3s \
  --etcd-s3-folder backups/etcd \
  --etcd-s3-access-key ${ETCD_S3_ACCESS_KEY} \
  --etcd-s3-secret-key ${ETCD_S3_SECRET_KEY} \
  --etcd-s3-endpoint minio-storage.parmernas.synology.me \
  --cluster-init \
  --tls-san 192.168.1.200

# install k3s multi-master
curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=stable sh -s - server \
  --disable local-storage \
  --disable traefik \
  --disable servicelb \
  --disable metrics-server \
  --disable-network-policy \
  --disable-kube-proxy \
  --flannel-backend none \
  --token ${K3S_TOKEN} \
  --server https://192.168.2.20:6443 \
  --tls-san 192.168.1.200

# install k3s on agent nodes
curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=stable sh -s - agent \
  --token ${K3S_TOKEN} \
  --server 192.168.1.200 # haproxy address

# install cilium
```sh
# https://docs.cilium.io/en/stable/network/kubernetes/kubeproxy-free/#kubeproxy-free
helm repo add cilium https://helm.cilium.io

helm install cilium cilium/cilium -n kube-system -f cilium.values.yaml
```

# configure global reg creds
# https://docs.k3s.io/installation/private-registry
```sh
sudo bash -c "cat << EOF > /etc/rancher/k3s/registries.yaml
configs:
  ghcr.io:
    auth:
      username: rparmer
      password: ${GITHUB_TOKEN}
EOF"
```

# restore k3s server
```sh
sudo systemctl stop k3s
sudo k3s server \
  --cluster-init \
  --cluster-reset \
  --cluster-reset-restore-path=<SNAPSHOT> \
  --etcd-s3 \
  --etcd-s3-bucket=k3s \
  --etcd-s3-folder=backups/etcd \
  --etcd-s3-access-key=${ETCD_S3_ACCESS_KEY} \
  --etcd-s3-secret-key=${ETCD_S3_SECRET_KEY} \
  --etcd-s3-endpoint=minio-storage.parmernas.synology.me
```

# manual etcd backup
sudo k3s etcd-snapshot save \
  --etcd-s3 \
  --etcd-s3-bucket=k3s \
  --etcd-s3-folder=backups/etcd \
  --etcd-s3-access-key=${ETCD_S3_ACCESS_KEY} \
  --etcd-s3-secret-key=${ETCD_S3_SECRET_KEY} \
  --etcd-s3-endpoint=minio-storage.parmernas.synology.me

---

# if k3s install script doesn't work run
sudo chmod 777 /tmp/

# edit `/etc/hosts` file to include names and address of cluster nodes

# edit DNS settings in /etc/systemd/resolved.conf
/etc/systemd/resolved.conf --> update `DNS=192.168.1.1`
sudo rm -f /etc/resolv.conf
sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
sudo reboot
