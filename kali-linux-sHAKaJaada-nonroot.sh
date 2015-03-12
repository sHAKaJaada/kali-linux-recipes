#!/bin/bash

# Kali Linux ISO recipe for Cordyceps non-root

# Update and install dependencies

apt-get update
apt-get install git live-build cdebootstrap devscripts -y

# Clone the default Kali live-build config.

git clone git://git.kali.org/live-build-config.git

# Get the source package of the debian installer. 

apt-get source debian-installer

# Let's begin...

cd live-build-config

# The user doesn't need the kali-linux-full metapackage, we overwrite with our own basic packages.
# This includes the debian-installer and the kali-linux-top10 metapackage (commented out for brevity of build, uncomment if needed).

cat > config/package-lists/kali.list.chroot << EOF
# kali-linux-top10
kali-root-login
kali-defaults
kali-desktop-gnome
kali-menu
kali-debtags
kali-archive-keyring
kali-linux
kali-desktop-live
abiword
alsa-tools
alsa-utils
armitage
bum
burpsuite
cgpt
cryptsetup
debian-installer-launcher
desktop-base
file-roller
firmware-atheros
firmware-b43legacy-installer
firmware-b43-installer
firmware-iwlwifi
firmware-linux
firmware-realtek
florence
gdebi
gedit
gnome-control-center
gnome-shell-extensions
gnome-tweak-tool
gparted
gzip
htop
hydra
hydra-gtk
icedove
iceweasel
intel-microcode
leafpad
locales-all
mesa-utils
metasploit
metasploit-framework
nautilus-open-terminal
network-manager
network-manager-gnome
network-manager-pptp
network-manager-pptp-gnome
nmap
p7zip-full
p7zip-rar
p7zip
pychess
rar
rhythmbox
simple-scan
synaptic
unace
unrar
unzip
vboot-utils
vboot-kernel-utils
xorg
zip
EOF

# NON-ROOT
mkdir -p config/debian-installer
cp ../debian-installer-*/build/preseed.cfg config/debian-installer/
sed -i 's/make-user boolean false/make-user boolean true/' config/debian-installer/preseed.cfg
echo "d-i passwd/root-login boolean false" >> config/debian-installer/preseed.cfg

# Run the build!
lb build
