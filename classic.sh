#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root or using sudo."
    exit 1
fi

# Detect the distribution and locate the grub configuration file
if [ -f /etc/default/grub ]; then
    GRUB_FILE="/etc/default/grub"
elif [ -f /etc/default/grub.d/parrot.cfg ]; then
    GRUB_FILE="/etc/default/grub.d/parrot.cfg"
elif [ -f /boot/cmdline.txt ]; then
    GRUB_FILE="/boot/cmdline.txt"
else
    echo "Unable to locate the GRUB configuration file. Exiting."
    exit 1
fi

# Add net.ifnames=0 biosdevname=0 to GRUB_CMDLINE_LINUX
if grep -q "^GRUB_CMDLINE_LINUX=" "$GRUB_FILE"; then
    sed -i 's/\(^GRUB_CMDLINE_LINUX=".*\)"/\1 net.ifnames=0 biosdevname=0"/' "$GRUB_FILE"
else
    echo 'GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"' >> "$GRUB_FILE"
fi

# Update GRUB configuration
if [ -f /etc/default/grub ]; then
    update-grub
fi

echo "Changes applied. Reboot your system to take effect."
