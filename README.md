# OpenCore: macOS version specific DeviceProperties
**I made a more flexible kext for this purpose so this repo is archived.**

https://github.com/b00t0x/OSIEnhancer

## What is this repository?
In the [OpenCore](https://github.com/acidanthera/OpenCorePkg)'s config.plist, the `DeviceProperties` section doesn't have `MinKernel` / `MaxKernel`, which means you can't insert different values per macOS versions.

Normally this is not a problem, but it can be an issue in multi-boot environments. For example, my ThinkPad X280 can run macOS from El Capitan (10.11) to the latest Sonoma (14), but for El Capitan, I need to insert Skylake `device-id` because which doesn't have Kaby Lake driver, and for macOS 13 onwards, I need to insert Kaby Lake `device-id` because which doesn't have Skylake driver.

In this repository, I provide samples for applying different `DeviceProperties` per macOS versions by manipulating `_OSI`.

## kext patch
In the `Kernel` / `Patch` section of the `config.plist`, patch is applied to `AppleACPIPlatform`.

`AppleACPIPlatform` sets the OS name in the `_OSI` method used in DSDT / SSDT to `Darwin`, regardless of the macOS version. This patch replaces it with `Darw15`, indicating the El Capitan kernel version. Since `MinKernel` / `MaxKernel` can be set in the `Kernel / Patch` section, this change can be limited to specific macOS versions (here, El Capitan).

## SSDT-UHD620
By defining the `_DSM` method, SSDT files can insert `DeviceProperties`. Here, I set Skylake's `device-id` and `ig-platform-id` when `Darw15` is detected, and otherwise Kaby Lake's values.

Note that if other SSDT files are using `If (_OSI("Darwin"))`, you may need to change them to `If (_OSI("Darwin") || _OSI("Darw15"))`.

## _DSM to XDSM
At least in the case of my ThinkPad X280's SSDT, `_DSM` was already defined, so I had to rename the predefined `_DSM` to `XDSM` to allow `_DSM` to be reinserted.

Please note that whether `_DSM` is defined in DSDT or SSDT, and if it is defined in SSDT, `OemTableId` differs depending on the PC.

## Acknowledgments
* Slice : For the [idea](https://www.insanelymac.com/forum/topic/355374-how-to-make-ssdt-if-_osi-darwin-to-a-specific-version-of-macos/?do=findComment&comment=2800041) about AppleACPIPlatform patch
* RehabMan : [Guide](https://www.tonymacx86.com/threads/guide-hackrnvmefamily-co-existence-with-ionvmefamily-using-class-code-spoof.210316/) on DeviceProperties Injection via SSDT
