# Vendor blobs — Samsung W2017 (SM-W2017 / veyronltectc)

> **STATUS: WORK IN PROGRESS — EMPTY.**
>
> This repository currently contains **no binaries**. It only carries the file
> list, the extraction script and the makefile skeleton. The device tree that
> uses it will not build until blobs are extracted.

## Where the blobs come from

Preferred (once the device is rooted / TWRP is available):

```bash
adb pull /system/vendor   # or dd the system partition and mount it
./extract-files.sh ./system_dump
```

Alternative: extract `system.img.ext4` from an official Odin AP package, mount it
(or use `debugfs -R rdump`) and point `extract-files.sh` at the mounted root.

`proprietary-files.txt` in this repo is a **placeholder inherited from the
Galaxy S7 (heroqlte) tree**. The W2017 runs Android 6.0.1 and its blob set is
different (no Treble, no radio@1.4 secbridge, HAL1 camera). It must be
regenerated from the actual W2017 system image before the blobs are usable, e.g.:

```bash
# from the device tree directory
./extract-files.sh /path/to/system_root
./setup-makefiles.sh
```

## Layout

```
proprietary/            blobs, mirrored to $(TARGET_COPY_OUT_VENDOR) (git-ignored)
proprietary-files.txt   paths to pull, one per line, optional |sha1
extract-files.sh        pull blobs from a dump
veyronltectc-vendor.mk  PRODUCT_COPY_FILES rules
Android.mk              included by the build
BoardConfigVendor.mk    board-level vendor config
```

## Note on scope

The 6.0.1 blobs are *much* older than LineageOS 18.1 expects. Expect to have to
write shims (camera HAL1, SecRIL, audio) rather than "just copy the blobs".
