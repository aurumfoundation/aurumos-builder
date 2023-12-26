#!/bin/bash

# Create aurumOS filesystem structure
mkdir -p /aurumOS/system/boot/kernel
mkdir -p /aurumOS/system/boot/configs

# Copy compiled files to aurumOS
cp -r /system/boot/kernel /aurumOS/system/boot/
cp -r /system/boot/configs /aurumOS/system/boot/

# Create limine.cfg file (customize as needed)
echo "default 0
timeout 0

image /system/boot/kernel/vmlinuz
    label aurumOS
    initrd /system/boot/initrd.img
    cmdline 'root=/dev/ram0 init=/init'" > /aurumOS/system/boot/configs/limine.cfg

# Create initrd.img (customize as needed)
cd /aurumOS
find . | cpio -o -H newc | gzip > /system/boot/initrd.img
cd /

# Create ISO image
mkdir -p /aurumOS_iso
cp -r /aurumOS/* /aurumOS_iso/
limine-install /limine/limine.bin /aurumOS_iso/

# Create ISO file
xorriso -as mkisofs -b limine-cd.bin -no-emul-boot -boot-load-size 4 -boot-info-table -o /tmp/aurumOS_unstable.iso /aurumOS_iso
