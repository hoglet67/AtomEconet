#!/bin/bash

export PYTHONPATH=../../../py8dis/py8dis

file=AtomEco350
python ${file}.py > ${file}.asm
beebasm -i ${file}.asm -o ${file}.bin
md5sum ${file}.rom ${file}.bin
