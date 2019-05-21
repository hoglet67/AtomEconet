#!/bin/bash

# Disassemble
../tools/beebdis AtomEco350.dis

# Assemble
rm -f AtomEco350.bin
../tools/beebasm -v -i AtomEco350.asm

# Test
md5sum AtomEco350.rom
md5sum AtomEco350.bin

