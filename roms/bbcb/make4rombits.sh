#!/bin/env bash

# make .bit files suitable for reading into roms in non-bootstrapped Gowin boards

SCRIPTS=../../scripts
MMFS=MMFS

$SCRIPTS/bin2bitvector.pl --fill 11111111 --size 0x4000 os12.rom > os12.bit
$SCRIPTS/bin2bitvector.pl --fill 11111111 --size 0x4000 basic2.rom > basic2.bit
$SCRIPTS/bin2bitvector.pl --fill 11111111 --size 0x4000 ram_master_v6.rom > ram_master_v6.bit
$SCRIPTS/bin2bitvector.pl --fill 11111111 --size 0x4000 $MMFS/M/MMFS.rom > mmfs.bit

# make a 32K MOS+BASIC
cat os12.bit basic2.bit >os12_basic.bit
# make a 48K MOS+BASIC+MMFS
cat os12.bit mmfs.bit basic2.bit >os12_mmfs_basic.bit
# make a 64K MOS+BASIC+MMFS+RAMMASTER
cat os12.bit mmfs.bit ram_master_v6.bit basic2.bit >os12_mmfs_ram_basic.bit