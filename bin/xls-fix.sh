#!/bin/bash
src=$1
tmpfile=$(mktemp -u /tmp/xlsfix.XXXXXX)
die()
{
    zenity --error --text="Ошибка.\n$output"
    rm ${tmpfile}.{xls,csv}
}

output=$(cp "$src" ${tmpfile}.xls 2>&1)
[ $? ] && die

output=$(libreoffice --convert-to csv --outdir /tmp ${tmpfile}.xls 2>&1)
[ $? ] && die
mv "$src" "${src}.bak"
output=$(libreoffice --infilter=CSV:44,34,34 --convert-to xls --outdir /tmp ${tmpfile}.csv 2>&1)
[ $? ] && die
cp ${tmpfile}.xls "$src"
rm ${tmpfile}.{xls,csv}

#libreoffice "$src" &

