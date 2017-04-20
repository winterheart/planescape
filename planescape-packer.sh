#!/bin/sh

ITP='po/script/Infinity Text Parser/InfinityPacker.pl'
IN_TRA="po/pst/trans/0-106496.tra"
OUT_TRA="installer/pst-l10n/tra/russian/0-106496.tra"
PO_FILES="po/pst/ru/"
PO_NAMES="po/pst/names/"

VERSION_PSTL10N="1.02"
VERSION_QWINN="4.13"

echo "==== Making *.tra ===="
"${ITP}" -t ${IN_TRA} -i ${PO_FILES} -o ${OUT_TRA}
"${ITP}" -t installer/PST-Fix/tra/english/fixpack.tra -i ${PO_FILES} -o installer/PST-Fix/tra/russian/fixpack.tra
"${ITP}" -t installer/PST-Fix/tra/english/subtitles.tra -i ${PO_FILES} -o installer/PST-Fix/tra/russian/subtitles.tra
"${ITP}" -t installer/pst-l10n/tra/english/names.tra -i ${PO_NAMES} -o installer/pst-l10n/tra/russian/names.tra

echo "==== Recoding *.tra ===="
recode utf8..windows-1251 ${OUT_TRA}
recode utf8..windows-1251 installer/PST-Fix/tra/russian/fixpack.tra
recode utf8..windows-1251 installer/PST-Fix/tra/russian/subtitles.tra
recode utf8..windows-1251 installer/pst-l10n/tra/russian/names.tra

echo "==== Compressing archive ===="
cat readme.md | Markdown.pl > installer/readme.html
cd installer
zip -9 -r ~/pst-l10n-${VERSION_PSTL10N}_pst-fix-${VERSION_QWINN}.zip .
