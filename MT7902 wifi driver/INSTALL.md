# MT7902 Wi-Fi Driver Installation Guide

This guide details the steps to compile, install, and load the MediaTek MT7902 out-of-tree Wi-Fi driver, with a focus on Fedora Linux.

## 1. Prerequisites

Before building the driver, ensure you have the necessary build tools and kernel headers installed. On Fedora, you can install these by running:

```bash
sudo dnf update
sudo dnf install kernel-devel kernel-headers dh-make gcc make dkms
```
*Note: Make sure your system is fully updated so the kernel headers match your currently loaded kernel.*

## 2. Choosing an Installation Method

There are two ways to install this driver:
- **Method A (DKMS):** Recommended. The driver will automatically rebuild when your kernel updates.
- **Method B (Manual):** You build and install it once, but will need to manually rebuild it every time Fedora updates your kernel.

---

### Method A: Automatic Installation (Recommended - via DKMS)

DKMS (Dynamic Kernel Module Support) ensures the module stays functional across kernel updates.

**Step 1: Install the required firmware**
```bash
cd "/home/ragul/Projects/Linux_Drivers/MT7902 wifi driver"
sudo make install_fw
```

**Step 2: Copy the source to the DKMS directory**
```bash
sudo mkdir -p /usr/src/gen4-mt7902-0.1
sudo cp -r * /usr/src/gen4-mt7902-0.1/
```

**Step 3: Register, build, and install with DKMS**
```bash
sudo dkms add -m gen4-mt7902 -v 0.1
sudo dkms build -m gen4-mt7902 -v 0.1
sudo dkms install -m gen4-mt7902 -v 0.1
```

Once finished, the driver is installed. Proceed to **Step 3: Reboot and Verify**.

---

### Method B: Manual Installation

**Step 1: Clean any previous builds (Optional but recommended)**
```bash
cd "/home/ragul/Projects/Linux_Drivers/MT7902 wifi driver"
make clean
```

**Step 2: Build the driver**
```bash
make -j$(nproc)
```

**Step 3: Install the driver and firmware**
```bash
sudo make install -j$(nproc)
sudo make install_fw
```

---

## 3. Reboot and Verify

Once you have installed the driver (either via DKMS or manually), load it or restart the system:

**Option A:** Load immediately without rebooting:
```bash
sudo modprobe mt7902
```

**Option B:** Reboot the system:
```bash
sudo reboot
```

**Verification:**
After rebooting/loading, use the following commands to check if the driver loaded successfully and is creating a Wi-Fi interface:

```bash
# Check if the kernel object is loaded:
lsmod | grep mt7902

# Check for kernel messages relating to the firmware or mt7902
dmesg | grep -i mt7902
```

## Useful Troubleshooting Tips

- **Disappearing Wi-Fi post-sleep:** This driver currently has bugs with deep sleep (S3). If you lose Wi-Fi after waking up your laptop, run:
  ```bash
  sudo rmmod mt7902
  sudo modprobe mt7902
  ```
- **Firmware errors:** If `dmesg` complains about missing firmware, verify that `sudo make install_fw` successfully placed the binaries in `/lib/firmware/mediatek/`.
