<div align="center">
  <h1>📡 MediaTek MT7902 Linux Driver (gen4-mt7902)</h1>
  <p>
    An out-of-tree Linux kernel driver for the MediaTek MT7902 PCIe Wi-Fi card.
  </p>

<!-- Badges -->
<p>
  <a href="https://github.com/hmtheboy154/gen4-mt7902">
    <img src="https://img.shields.io/badge/Status-Work_In_Progress-orange.svg" alt="Status" />
  </a>
  <a href="https://wireless.docs.kernel.org/en/latest/en/users/drivers/mediatek.html">
    <img src="https://img.shields.io/badge/Mainline_Support-Pending-yellow.svg" alt="Mainline Support" />
  </a>
  <a href="https://discord.gg/JGhjAxEFhz">
    <img src="https://img.shields.io/badge/Discord-Join_Community-7289da.svg" alt="Discord" />
  </a>
</p>
</div>

---

> [!WARNING]
> **Project Notice**: This community driver is currently discontinued. MediaTek has begun releasing [official patches to support MT7902 on the mainline `mt76` driver](https://www.phoronix.com/news/Mediatek-MT7902-Linux-Patches) (including both SDIO & PCIe). Official `mt76` support will be available soon. You can also monitor experimental [backporting attempts](https://github.com/hmtheboy154/mt7902/tree/backport).

> [!CAUTION]
> **Experimental Software**: This driver is in a **Work-In-Progress** state. It is not fully stabilized for strict daily-driver use, and installing it requires some manual configuration. See the Known Issues section below.

## 📖 About The Project

This is a driver for the **MediaTek MT7902 M.2 PCIe Wi-Fi card**, based on the `gen4-mt79xx` driver provided by MediaTek to Android OEMs. Originally extracted from [Xiaomi's Rodin BSP](https://github.com/MiCode/MTK_kernel_modules/tree/bsp-rodin-v-oss/connectivity/wlan/core/gen4-mt79xx), this codebase has been refactored and modified to specifically target and support the MT7902.

Until the MT7902 chip is officially supported by the kernel's built-in `mt76` module, this `.ko` kernel module serves as a bridge to provide usable Wi-Fi for this hardware on Linux.

## 📊 Current Status & Known Issues

The driver compiles successfully and is capable of connecting to 2.4GHz Wi-Fi networks. However, several bugs and architectural limitations are known:

### 🔴 Known Bugs
- **Band Switching**: Switching to 5GHz networks may fail if connecting to an SSID broadcasting both 2.4GHz and 5GHz.
- **WPA3 Compatibility**: WPA3 authentication is broken when using the `iwd` daemon. **Workaround:** Ensure you are using `wpa_supplicant` instead.
- **Hotspot**: Creating a Wi-Fi hotspot (AP mode) to function as a repeater is currently non-functional.
- **Power Management (S3 Sleep)**: Suspend-to-RAM (S3) is broken and causes a black screen/kernel panic upon wake. 
  - **Workaround:** S2idle works correctly. Otherwise, unload the module before sleeping (`sudo rmmod mt7902`).
- **Binary Size**: The compiled driver size is bloated (~100MB) due to extensive debug code remaining in the OEM sources.

### 🟡 Untested
- Bluetooth (Not covered by this specific module).
- Wi-Fi 6 / 6E throughput and functionality.

## ⚙️ Installation & Usage

For detailed instructions on compiling the kernel module, deploying the firmware, and setting up DKMS for automatic updates on your Linux distro, please see the dedicated installation guide:

👉 [**View the Comprehensive Installation Guide (INSTALL.md)**](./INSTALL.md)

## 💻 Tested Hardware Environment

This driver has been compiled and tentatively tested against:
- **Linux Kernel Versions:** `5.4+` recommended.
- **Wi-Fi Cards:** 
  - `WMDM-257AX` 
  - `AW-XB552NF` (Note: Frequent kernel panics have been reported on some ASUS hardware containing this card).

## 💬 Frequently Asked Questions (FAQ)

<details>
<summary><b>Can we just add MT7902 support to the official mt76 driver?</b></summary>
Yes and no. Adding the PCI ID to <code>mt76</code> isn't enough. MediaTek shipped a very unique firmware structure for the MT7921 family. Figuring out how to initialize the MT7902 using the Windows firmware inside <code>mt76</code> is a complex reverse-engineering task. Thankfully, MediaTek's engineers are working on this right now for the mainline kernel.
</details>

<details>
<summary><b>What about Bluetooth support?</b></summary>
This module is solely for WLAN. For Bluetooth, an out-of-tree patch for <code>btmtk</code> (based on the Rodin BSP) has been compiled. If you compile your own kernels, you can view the reference patch <a href="https://gist.github.com/hmtheboy154/b2675e02d5f9a0bb861598e77ec2f38f">here</a>.
</details>

<details>
<summary><b>Will you provide bug fixes and maintain this?</b></summary>
As an experimental community project from developers with limited free time, comprehensive maintenance is not guaranteed. Contributions and Pull Requests are incredibly welcome!
</details>

<details>
<summary><b>Is there an active gen4m driver we can port from?</b></summary>
Xiaomi's <a href="https://github.com/MiCode/MTK_kernel_modules/tree/bsp-rodin-v-oss/connectivity/wlan/core/gen4m">gen4m</a> seems properly maintained. However, bringing the MT7902 info from <code>gen4-mt79xx</code> to <code>gen4m</code> involves significant architectural differences. It's theoretically possible for ambitious contributors.
</details>

## 🤝 Community & Support

Need help, have a log dump to share, or want to contribute to testing? 
Join the development discussions out in the field:

- 💬 [**Discord Development Group**](https://discord.gg/JGhjAxEFhz) - Chat with other users testing out the MT7902 Linux ecosystem.

---
*Disclaimer: Using experimental kernel modules bears the risk of data loss and system instability. Always ensure you have a backup of your kernel configuration and data.*
