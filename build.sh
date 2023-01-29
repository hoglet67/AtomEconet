#!/bin/bash

function make_include {
    grep "^.econet_" $1 | cut -c2- > tmp.1
    grep -A1 "^.econet_" $1 | grep -v "\.econet" | grep -v "\-\-" | awk '{print "= &"$1}' > tmp.2
    paste -d" " tmp.1 tmp.2 > $2
    rm -f tmp.1 tmp.2
}

BUILD=build/roms

mkdir -p ${BUILD}

echo "Building original #A000 version"
beebasm -i AtomEco350.asm -D BASE=0xA000 -D IO=0xB400 -v -o ${BUILD}/ECO350.rom > ${BUILD}/ECO350.lst

pushd $BUILD
cat >> ECO350.md5 <<EOF
f499ed413146f59ed67e24e74a8188c2  ECO350.rom
EOF
if md5sum -c ECO350.md5 --quiet
then
    echo "MD5SUM matches original"
else
    exit
fi
popd

echo "Building new #A000 ROM"
beebasm -i AtomEco350.asm -D BASE=0xA000 -D IO=0xB408 -v -o ${BUILD}/ECO350A.rom > ${BUILD}/ECO350A.lst

echo "Building new #A000 AtoMMC file"
beebasm -i AtomEco350.asm -D BASE=0xA000 -D IO=0xB408 -D ATOMMCHDR=1 -v -o ${BUILD}/ECO350A > ${BUILD}/ECO350E.lst

echo "Building new #E000 ROM"
beebasm -i AtomEco350.asm -D BASE=0xE000 -D IO=0xB408 -v -o ${BUILD}/ECO350E.rom > ${BUILD}/ECO350E.lst

echo "Building new #E000 AtoMMC file"
beebasm -i AtomEco350.asm -D BASE=0xE000 -D IO=0xB408 -D ATOMMCHDR=1 -v -o ${BUILD}/ECO350E > ${BUILD}/ECO350E.lst

echo "Building commands"

for i in 350A 350E
do
    echo "Building ${i} commands"
    CBUILD=build/ATOMLIB${i}
    mkdir -p ${CBUILD}
    make_include ${BUILD}/ECO${i}.lst econet.inc
    for j in DISCS INF PROT REMOTE RUN UNPROT USERS VIEW
    do
        beebasm -i commands/${j}.asm -v -o ${CBUILD}/${j} > ${CBUILD}/${j}.lst
    done
done
