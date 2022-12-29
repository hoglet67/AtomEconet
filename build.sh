#!/bin/bash
beebasm -i AtomEco350.asm -D BASE=0xE000 -D IO=0xB408 -v -o ECOTST > ECOTST.lst
