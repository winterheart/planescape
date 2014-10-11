#!/bin/sh

ITP='po/script/Infinity Text Parser/InfinityPacker.pl'
IN_TRA="po/trans/0-106496.tra"
OUT_TRA="installer/pst-l10n/tra/russian/0-106496.tra"
PO_FILES="po/ru/"
VERSION="1.00-rc3"

echo "==== Making 0-106496.tra ===="
"${ITP}" -t ${IN_TRA} -i ${PO_FILES} -o ${OUT_TRA}

echo "==== Recoding 0-106496.tra ===="
recode utf8..windows-1251 ${OUT_TRA}

echo "==== Compressing archive ===="
cd installer
zip -9 -r ~/pst-l10n-${VERSION}.zip .
