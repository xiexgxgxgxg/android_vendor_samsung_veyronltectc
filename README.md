# Vendor blobs — Samsung W2017 (SM-W2017 / veyronltectc)

> **STATUS: THE BLOB SET BOOTS THE ROM (2026-11-18).**
> Most blobs are still extracted from the last official firmware
> (`W2017KEU1ARG1`, Android 6.0.1) and pinned with sha1. Two parts had to
> change to make Android 11 boot:
>
> * the **Adreno userspace driver** (`vendor/lib*/egl/*`, `libgsl`,
>   `libadreno_utils`, `libllvm-glnext`, `librs_adreno*`) now comes from a
>   Xiaomi Note 2 MIUI 11 (Android 8.0) image: the 6.0.1 EGL calls private
>   gralloc0 entry points and cannot work with the gralloc1 that the A11
>   display HAL builds, while the Android 8 generation talks gralloc1.
>   The kgsl ioctl ABI is unchanged between the two (the
>   `drivers/gpu/msm/kgsl_ioctl.h` diff against the S7 lineage-18.1 kernel is
>   empty), so the 6.0.1 kgsl driver still drives it;
> * the **a530 GPU firmware** (`vendor/firmware/a530*`) is added — without it
>   `request_firmware()` fails with EAGAIN and SurfaceFlinger aborts.
>
> The 6.0.1 **SDM display blobs** (`libsdmextension.so`, `libsdm-color.so`,
> the stock `hwcomposer.msm8996.so`) were **removed**: they are built against
> the SDM 1.x C++ ABI and crash the Android 11 display HAL.
> The remaining 6.0.1 blobs (camera HAL1, SecRIL, audio) still need shims.

## Status

| Item | State |
|---|---|
| Blob extraction | ✅ from `W2017KEU1ARG1` |
| sha1 pins | ✅ in `proprietary-files.txt` |
| `veyronltectc-vendor.mk` | ✅ generated copy rules |
| Blob set matches the phone | ✅ device confirmed on `W2017KEU1ARG1` (2026-11-15) |
| LineageOS 18.1 build | ✅ eng build passes (2026-11-18) |
| Boot / HAL bring-up | ✅ boots to the setup wizard (2026-11-18) |
| GPU: Adreno driver + `a530*` firmware | ✅ imported (Android 8 generation) |
| Display: 6.0.1 SDM blobs | ✅ dropped (ABI mismatch with the A11 HAL) |
| HAL shims (camera / audio / RIL / fingerprint / GNSS) | ❌ not written |
| Wi-Fi firmware (`bcmdhd_*.bin`, `nvram_net.txt`) | ❌ not in the blob set yet |

## Source

| | |
|---|---|
| Firmware | `W2017KEU1ARG1` (CTC, China Telecom) |
| Build | `MMB29M` / Android 6.0.1 / security patch 2018-06-01 |
| Fingerprint | `samsung/veyronltectc/veyronltectc:6.0.1/MMB29M/W2017KEU1ARG1:user/release-keys` |
| Kernel | 3.18.20-9512355, built 2018-07-16 |
| Files | 870 (`vendor/**`, `lib{,64}/hw` HALs, Samsung/RIL/audio system libs), ~268 MB |

`proprietary-files.txt` is generated from this image and carries sha1 pins; the
files under `proprietary/` are the actual blobs. The boot image layout is
identical between `W2017KEU1ARG1` and `W2017KEU1APJ7`, so mixing blobs from
either build will not break the boot header — only the blobs themselves differ.

## Refreshing

From the device tree:

```bash
./extract-files.sh /path/to/system_root   # or "adb"
./setup-makefiles.sh                       # regenerates veyronltectc-vendor.mk
```

Then copy the resulting `proprietary-files.txt` and `veyronltectc-vendor.mk` here.

## Known gaps

* **No HIDL HALs.** 6.0.1 shipped pre-Treble HALs; 18.1 expects
  `android.hardware.*@1.x` services. The device tree will need shims or a much
  older API target.
* **Camera is HAL1** (`libmmcamera_*` + chromatix data) — not usable as-is on 18.1.
* **`libsec-ril.so` is the Samsung 6.0.1 RIL**, not `radio@1.4` + secbridge. This
  is the hardest part of the port, especially for China Telecom (CDMA).
* **Encryption**: `/data` uses FDE with a footer (`encryptable=footer`); FBE
  tooling in 18.1 does not apply.
