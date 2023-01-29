#!/bin/bash
export PYTHONPATH=../../../py8dis/py8dis:..

for file in DISCS INF PROT REMOTE RUN UNPROT USERS VIEW
do

cat > ${file}.py <<EOF
from commands import *

from eco_common import *

config.set_label_references(False)
config.set_show_char_literals(False)
config.set_show_autogenerated_labels(False)
config.set_hex_dump(False)

load(0x2800, "${file}", "6502")

add_common_labels()

entry(0x2800, "START")
go()
EOF

python ${file}.py > ${file}.asm
beebasm -i ${file}.asm -o ${file}.bin
md5sum ${file} ${file}.bin
rm -f ${file}.py ${file}.bin

done
