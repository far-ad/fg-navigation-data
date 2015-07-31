#!/bin/bash

width=160
height=680

wget "https://www.aro.lfv.se/Editorial/View/56/ES_ENR_4_4_en"
file_name="ES_ENR_4_4_en"

# extract the text from the PDFs
# title page
pdftotext -f 1 -l 1 -x 50 -y 180 -W $width -H 600 -layout -nopgbrk $file_name sweden_fixes1.txt
# uneven pages
for i in {3,5,7,9,11}
do
    pdftotext -f $i -l $i -x 50 -y 100 -W $width -H $height -layout -nopgbrk $file_name sweden_fixes$i.txt
done
# even pages
for i in {2,4,6,8,10,12}
do
    pdftotext -f $i -l $i -x 20 -y 100 -W $width -H $height -layout -nopgbrk $file_name sweden_fixes$i.txt
done

# pack to one csv file
cat sweden_fixes{1..12}.txt | sed '/^$/d' | awk -f format_coord.awk | tr -s ' ' ',' > sweden_fixes.csv
rm sweden_fixes*.txt "$file_name"
