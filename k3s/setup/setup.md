# install required packages
```
sudo apt install -y nfs-common
```

# config no password sudo
```sh
echo "ubuntu ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/ubuntu
```
# config static ip
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

sudo netplan apply

# resize disk
sudo lvm
lvm> lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
lvm> exit
sudo resize2fs /dev/ubuntu-vg/ubuntu-lv

# install k3s on master node
curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=stable sh -s - server \
  --disable local-storage \
  --disable traefik \
  --disable servicelb \
  --disable metrics-server \
  --write-kubeconfig-mode 0644 \
  --flannel-backend none \
  --disable-network-policy \
  --disable-kube-proxy \
  --etcd-s3 \
  --etcd-s3-bucket=k3s \
  --etcd-s3-folder=backups/etcd \
  --etcd-s3-access-key=${ETCD_S3_ACCESS_KEY} \
  --etcd-s3-secret-key=${ETCD_S3_SECRET_KEY} \
  --etcd-s3-endpoint=minio-storage.parmernas.synology.me \
  --cluster-init

# install k3s on agent nodes
curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=stable sh -s - agent \
  --token ${K3S_TOKEN} \
  --server ${K3S_URL}

# if k3s install script doesn't work run
sudo chmod 777 /tmp/

# restore k3s server
curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=stable sh -s - server \
  --disable local-storage \
  --disable traefik \
  --disable servicelb \
  --write-kubeconfig-mode 0644 \
  --cluster-init \
  --cluster-reset \
  --etcd-s3 \
  --etcd-s3-bucket=k3s \
  --etcd-s3-folder=backups/etcd \
  --etcd-s3-access-key=${ETCD_S3_ACCESS_KEY} \
  --etcd-s3-secret-key=${ETCD_S3_SECRET_KEY} \
  --etcd-s3-endpoint=minio-storage.parmernas.synology.me \
  --cluster-reset-restore-path=${PATH} \
  --token=${TOKEN}

# manual etcd backup
sudo k3s etcd-snapshot save \
  --etcd-s3 \
  --etcd-s3-bucket=k3s \
  --etcd-s3-folder=backups/etcd \
  --etcd-s3-access-key=${ETCD_S3_ACCESS_KEY} \
  --etcd-s3-secret-key=${ETCD_S3_SECRET_KEY} \
  --etcd-s3-endpoint=minio-storage.parmernas.synology.me

# install cilium
```sh
# https://docs.cilium.io/en/stable/network/kubernetes/kubeproxy-free/#kubeproxy-free
helm repo add cilium https://helm.cilium.io

helm install cilium cilium/cilium -n kube-system -f cilium.values.yaml
```


---

# edit `/etc/hosts` file to include names and address of cluster nodes

# edit DNS settings in /etc/systemd/resolved.conf
/etc/systemd/resolved.conf --> update `DNS=192.168.1.1`
sudo rm -f /etc/resolv.conf
sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
sudo reboot
