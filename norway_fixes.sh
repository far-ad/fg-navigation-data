#!/bin/bash

wget "https://www.ippc.no/norway_aip/current/aip/EN_ENR_4_4_en.pdf"
pdf_file="EN_ENR_4_4_en.pdf"

uneven_offset=70
even_offset=40

v_offset=100

title_height=80

width=175
height=700

# extract the text from the PDFs
for i in {1..49}
do
    if (( "$i" == "1" ))
    then
        # title page
        pdftotext -f $i -l $i -x $uneven_offset -y $(( $v_offset + $title_height )) \
	                      -W $width -H $(( $height - $title_height )) \
			      -layout -nopgbrk \
			      "$pdf_file" norway_fixes$i.txt
    else
        pdftotext -f $i -l $i -x $(( $i%2==1 ? $uneven_offset : $even_offset )) -y $v_offset \
	                      -W $width -H $height \
			      -layout -nopgbrk \
			      "$pdf_file" norway_fixes$i.txt
    fi
done

# pack to one file
cat norway_fixes{1..49}.txt | grep '^[[:upper:][:digit:]]\{5\}' | awk -f format_coord.awk | tr -s ' ' ',' > norway_fixes.csv
rm -f norway_fixes*.txt "$pdf_file" "$pdf_file".*

