#!/bin/bash

BASEDIR="/android/clockworkmod/GT-I9070"
OUTDIR="$BASEDIR/out"
INITRAMFSDIR="$BASEDIR/ramdisk"
TOOLCHAIN="/android/ics/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi-"

cd kernel
case "$1" in
	clean)
        make mrproper ARCH=arm CROSS_COMPILE=$TOOLCHAIN
		;;
	*)
        make clockworkmod_i9070_defconfig ARCH=arm CROSS_COMPILE=$TOOLCHAIN

        make -j8 ARCH=arm CROSS_COMPILE=$TOOLCHAIN CONFIG_INITRAMFS_SOURCE=$INITRAMFSDIR modules

        mkdir -p $INITRAMFSDIR/lib/modules/2.6.35.7
        mkdir -p $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/bluetooth/bthid
        mkdir -p $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/net/wireless/bcm4330
        mkdir -p $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/samsung/j4fs
        mkdir -p $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/samsung/param
        mkdir -p $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/scsi

        cp fs/cifs/cifs.ko $INITRAMFSDIR/lib/modules/2.6.35.7/cifs.ko
        cp drivers/bluetooth/bthid/bthid.ko $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/bluetooth/bthid/bthid.ko
        cp drivers/net/wireless/bcm4330/dhd.ko $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/net/wireless/bcm4330/dhd.ko
        cp drivers/samsung/j4fs/j4fs.ko $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/samsung/j4fs/j4fs.ko
        cp drivers/samsung/param/param.ko $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/samsung/param/param.ko
        cp drivers/scsi/scsi_wait_scan.ko $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/scsi/scsi_wait_scan.ko

        make -j8 ARCH=arm CROSS_COMPILE=$TOOLCHAIN CONFIG_INITRAMFS_SOURCE=$INITRAMFSDIR zImage
        cp arch/arm/boot/zImage ${OUTDIR}/kernel.bin

        pushd ${OUTDIR}
        md5sum -t kernel.bin >> kernel.bin
        mv kernel.bin kernel.bin.md5
        tar cfv GT-I9070_GB_ClockworkMod-Recovery.tar kernel.bin.md5
        md5sum -t GT-I9070_GB_ClockworkMod-Recovery.tar >> GT-I9070_GB_ClockworkMod-Recovery.tar
        mv GT-I9070_GB_ClockworkMod-Recovery.tar GT-I9070_GB_ClockworkMod-Recovery.tar.md5
        popd
	;;
esac
