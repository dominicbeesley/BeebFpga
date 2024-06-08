#!/bin/bash

# Create the 64KB minimal ROM image for the Tang 9K build
#
# This contains:

# 16x 16K ROMS images for the Model B
# 16x 16K ROMS images for the Master 128

MMFS=MMFS

# Beeb ROM Images

IMAGE=/tmp/tang25_image_beeb_500000.bin
rm -f $IMAGE
cat bbcb/os12.rom              > $IMAGE
cat bbcb/${MMFS}/M/SWMMFS.rom  >> $IMAGE
cat bbcb/ram_master_v6.rom     >> $IMAGE
cat bbcb/basic2.rom            >> $IMAGE

# Master ROM Images

IMAGE=/tmp/tang25_image_master_510000.bin
rm -f $IMAGE
cat m128/mos.rom               > $IMAGE

IMAGE=/tmp/tang25_image_master_540000.bin
rm -f $IMAGE

cat generic/blank.rom          > $IMAGE
cat generic/blank.rom          >> $IMAGE
cat generic/blank.rom          >> $IMAGE
cat generic/blank.rom          >> $IMAGE

# Note: It's not possible to pre-load the sideways RAM banks (4-7)
cat m128/mos.rom               >> $IMAGE
cat generic/blank.rom          >> $IMAGE
cat generic/blank.rom          >> $IMAGE
cat generic/blank.rom          >> $IMAGE

cat m128/dfs.rom               >> $IMAGE # Retain this for SRAM Utils
cat m128/${MMFS}/M/MAMMFS.rom  >> $IMAGE # MMFS in a higher slot
cat m128/viewsht.rom           >> $IMAGE
cat m128/edit.rom              >> $IMAGE

cat m128/basic4.rom            >> $IMAGE
cat m128/adfs.rom              >> $IMAGE
cat m128/view.rom              >> $IMAGE
cat m128/terminal.rom          >> $IMAGE