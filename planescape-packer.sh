#!/bin/sh

ITP='po/script/Infinity Text Parser/InfinityPacker.pl'
IN_TRA="po/trans/0-106496.tra"
OUT_TRA="installer/pst-l10n/tra/russian/0-106496.tra"
PO_FILES="po/ru/"
VERSION_PSTL10N="1.00-rc3"
VERSION_QWINN="4.13"

echo "==== Making *.tra ===="
"${ITP}" -t ${IN_TRA} -i ${PO_FILES} -o ${OUT_TRA}
"${ITP}" -t installer/PST-Fix/tra/english/fixpack.tra -i ${PO_FILES} -o installer/PST-Fix/tra/russian/fixpack.tra
"${ITP}" -t installer/PST-Fix/tra/english/subtitles.tra -i ${PO_FILES} -o installer/PST-Fix/tra/russian/subtitles.tra


echo "==== Recoding *.tra ===="
recode utf8..windows-1251 ${OUT_TRA}
recode utf8..windows-1251 installer/PST-Fix/tra/russian/fixpack.tra
recode utf8..windows-1251 installer/PST-Fix/tra/russian/subtitles.tra

echo "==== Compressing archive ===="
cat readme.md | Markdown.pl > installer/readme.html
cd installer
zip -9 -r ~/pst-l10n-${VERSION_PSTL10N}_pst-fix-${VERSION_QWINN}.zip .
