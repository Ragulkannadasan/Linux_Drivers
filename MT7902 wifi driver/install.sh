#!/bin/bash

#!/bin/bash

# Exit on any error
set -e

echo "=================================================="
echo "🚀 MediaTek MT7902 Wi-Fi Driver Auto-Installer"
echo "=================================================="
echo "This script will install the driver and necessary"
echo "firmware using DKMS so it automatically rebuilds"
echo "whenever you update your kernel."
echo ""

# Check if running in a VM
if systemd-detect-virt 2>/dev/null | grep -q -E "(kvm|qemu|virtualbox|vmware)"; then
    echo "⚠️  Detected running in a virtual machine (e.g., GNOME Boxes)."
    echo "Note: Wi-Fi functionality may require hardware passthrough (PCIe)."
    echo "If Wi-Fi doesn't work, ensure the MT7902 card is passed through to the VM."
    echo ""
fi

# Check for required packages
echo "🔎 Checking for necessary build tools..."
if ! command -v dkms &> /dev/null; then
    echo "⚠️  DKMS is not installed. Attempting to install it..."
    if command -v apt &> /dev/null; then
        # Ubuntu/Debian
        sudo apt update
        sudo apt install -y dkms linux-headers-$(uname -r) build-essential
    else
        echo "❌ Unsupported package manager. Please install dkms, kernel headers, gcc, and make manually."
        exit 1
    fi
fi

echo "📦 1. Installing MT7902 firmware matching your region/card..."
sudo make install_fw

echo "📂 2. Preparing DKMS source directory (/usr/src/gen4-mt7902-0.1)..."
sudo mkdir -p /usr/src/gen4-mt7902-0.1
sudo cp -r ./* /usr/src/gen4-mt7902-0.1/

echo "🔨 3. Compiling and installing the driver into the kernel via DKMS..."
# Try removing any old installation first to prevent crash/overlap
sudo dkms remove -m gen4-mt7902 -v 0.1 --all 2>/dev/null || true

sudo dkms add -m gen4-mt7902 -v 0.1
sudo dkms build -m gen4-mt7902 -v 0.1
sudo dkms install -m gen4-mt7902 -v 0.1

echo "🔄 4. Injecting module into the running network stack..."
sudo modprobe mt7902 || echo "⚠️ Warning: Failed to load module immediately. You may just need to reboot."

echo ""
echo "✅ Installation Complete! Your Wi-Fi should now be connected."
echo "If you do not see the Wi-Fi interface, please restart your computer."
echo "=================================================="
