#!/bin/bash

set -e

echo "=== MedOS Full Build Starting ==="

# Settings
ARCH="arm64"
SUITE="trixie"
MIRROR="http://deb.debian.org/debian"
ROOTFS="rootfs"

# Clean previous build
echo "[1] Cleaning..."
sudo rm -rf "$ROOTFS"

# Install debootstrap if missing
if ! command -v debootstrap &> /dev/null; then
    echo "[2] Installing debootstrap..."
    sudo apt update
    sudo apt install -y debootstrap
fi

# Create rootfs
echo "[3] Creating root filesystem..."
sudo debootstrap --arch=$ARCH $SUITE $ROOTFS $MIRROR

# Mount system dirs
echo "[4] Mounting..."
sudo mount --bind /dev $ROOTFS/dev
sudo mount --bind /proc $ROOTFS/proc
sudo mount --bind /sys $ROOTFS/sys

# Configure system inside chroot
echo "[5] Configuring system..."

sudo chroot $ROOTFS /bin/bash <<EOF

set -e

apt update
apt install -y sudo systemd vim

# os-release
cat > /etc/os-release <<EOL
PRETTY_NAME="MedOS GNU/Linux 2 'Ankara'"
NAME="MedOS GNU/Linux"
VERSION_ID="2"
VERSION="2 'Ankara'"
VERSION_CODENAME=Ankara
DEBIAN_VERSION_FULL=12
ID=medos
HOME_URL="https://www.medcell.tr/medos/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
EOL

# First boot script
cat > /root/firstboot.sh <<'EOL'
#!/bin/bash

echo "=== MedOS First Boot Setup ==="

read -p "Username: " USERNAME
read -s -p "Password: " PASSWORD
echo

useradd -m -G sudo \$USERNAME
echo "\$USERNAME:\$PASSWORD" | chpasswd

systemctl disable firstboot.service
rm -f /etc/systemd/system/firstboot.service
EOL

chmod +x /root/firstboot.sh

# First boot service
cat > /etc/systemd/system/firstboot.service <<EOL
[Unit]
Description=MedOS First Boot Setup
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/root/firstboot.sh
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOL

systemctl enable firstboot.service

EOF

# Unmount
echo "[6] Cleaning mounts..."
sudo umount $ROOTFS/dev
sudo umount $ROOTFS/proc
sudo umount $ROOTFS/sys

echo "=== Build Finished ==="
echo "Rootfs is ready at: $ROOTFS"