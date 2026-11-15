# Vendor blobs — Samsung W2017 (SM-W2017 / veyronltectc)

> **STATUS: BLOBS COMPLETE — NOT BUILT, NOT TESTED.**
> All blobs are extracted from the last official firmware, pinned with sha1 and
> wired into generated copy rules. No LineageOS 18.1 build has been attempted and
> nothing has run on hardware yet. The blobs are Android 6.0.1-era and will need
> shims (camera HAL1, SecRIL, audio) before 18.1 can use them.

## Status

| Item | State |
|---|---|
| Blob extraction | ✅ 894 files / 268 MB from `W2017KEU1ARG1` |
| sha1 pins | ✅ in `proprietary-files.txt` |
| `veyronltectc-vendor.mk` | ✅ generated, 894 `PRODUCT_COPY_FILES` rules |
| Blob set matches the phone | ✅ device confirmed on `W2017KEU1ARG1` (2026-11-15) |
| LineageOS 18.1 build | ❌ not attempted |
| Boot / HAL bring-up | ❌ not started |
| HAL shims (camera / audio / RIL) | ❌ not written |

## Source

| | |
|---|---|
| Firmware | `W2017KEU1ARG1` (CTC, China Telecom) |
| Build | `MMB29M` / Android 6.0.1 / security patch 2018-06-01 |
| Fingerprint | `samsung/veyronltectc/veyronltectc:6.0.1/MMB29M/W2017KEU1ARG1:user/release-keys` |
| Kernel | 3.18.20-9512355, built 2018-07-16 |
| Files | 894 (`vendor/**`, `lib{,64}/hw` HALs, Samsung/RIL/audio system libs), ~268 MB |

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
