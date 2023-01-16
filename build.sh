#!/bin/bash

echo "Building original #A000 version"
beebasm -i AtomEco350.asm -D BASE=0xA000 -D IO=0xB400 -v -o ECO350A.rom > ECO350A.lst

if md5sum -c ECO350A.md5 --quiet
then
    echo "MD5SUM matches original"
else
    exit
fi

echo "Building new #E000 ROM"
beebasm -i AtomEco350.asm -D BASE=0xE000 -D IO=0xB408 -v -o ECO350E.rom > ECO350E.lst

echo "Building new #E000 AtoMMC file"
beebasm -i AtomEco350.asm -D BASE=0xE000 -D IO=0xB408 -D ATOMMCHDR=1 -v -o ECO350E > ECO350E.lst
