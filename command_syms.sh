#!/bin/bash
for i in a658 a670 a690 a6bc a6f1 a788 a799 a7c3 a7f7 a80d a818 a81a a83c a848 a85d a861 a873 ad2a ad3e
do
   echo $i `grep $i -A1 build/roms/ECO350E.lst  | tail -1 | awk '{print $1}' | tr "a-f" "A-F"`
done
