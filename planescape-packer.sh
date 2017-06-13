#!/bin/sh

CUR=$(pwd)
ITP="${CUR}/po/script/Infinity Text Parser/InfinityPacker.pl"
PST_BASE="${CUR}/po/pst"
PST_IN_TRA="${PST_BASE}/trans/0-106496.tra"
PST_OUT_TRA="${PST_BASE}/installer/pst-l10n/tra/russian/0-106496.tra"
PST_PO_FILES="${PST_BASE}/ru/"
PST_PO_NAMES="${PST_BASE}/names/"

# REMINDER Don't forget modify tp2 file
PST_VERSION_PSTL10N="1.06"
PST_VERSION_QWINN="4.13"

PSTEE_BASE="${CUR}/po/pst-ee"
PSTEE_IN_TRA="${PSTEE_BASE}/trans/0-106833.tra"
PSTEE_OUT_TRA="${PSTEE_BASE}/installer/pst-ee-l10n/lang/ru_RU/0-106833.tra"
PSTEE_PO_FILES="${PSTEE_BASE}/ru/"

PSTEE_INSTALL="/home/$(whoami)/.local/share/Steam/SteamApps/common/Project P"



echo "== Making PST pack =="

echo "==== Making *.tra ===="
"${ITP}" -t ${PST_IN_TRA} -i ${PST_PO_FILES} -o ${PST_OUT_TRA}
"${ITP}" -t ${PST_BASE}/installer/PST-Fix/tra/english/fixpack.tra -i ${PST_PO_FILES} -o ${PST_BASE}/installer/PST-Fix/tra/russian/fixpack.tra
"${ITP}" -t ${PST_BASE}/installer/PST-Fix/tra/english/subtitles.tra -i ${PST_PO_FILES} -o ${PST_BASE}/installer/PST-Fix/tra/russian/subtitles.tra
"${ITP}" -t ${PST_BASE}/installer/pst-l10n/tra/english/names.tra -i ${PST_PO_NAMES} -o ${PST_BASE}/installer/pst-l10n/tra/russian/names.tra

echo "==== Recoding *.tra ===="
recode utf8..windows-1251 ${PST_OUT_TRA}
recode utf8..windows-1251 ${PST_BASE}/installer/PST-Fix/tra/russian/fixpack.tra
recode utf8..windows-1251 ${PST_BASE}/installer/PST-Fix/tra/russian/subtitles.tra
recode utf8..windows-1251 ${PST_BASE}/installer/pst-l10n/tra/russian/names.tra

echo "==== Compressing archive ===="
cat readme.md | Markdown.pl > ${PST_BASE}/installer/readme.html
cd ${PST_BASE}/installer
zip -9 -r "${CUR}/out/pst-l10n-${PST_VERSION_PSTL10N}_pst-fix-${PST_VERSION_QWINN}.zip" .

echo "== Making PST:EE pack =="

echo "==== Making *.tra ===="

cd "${PSTEE_INSTALL}"
# Uninstall and remove old files
wine weidu.exe setup-pst-ee-l10n.tp2 --uninstall
rm -f lang/ru_RU/dialog.tlk

# Generate new TLK and install mod
cd "${CUR}/po/script/Infinity Text Parser"
./InfinityPackerTLK.pl -t "${PSTEE_INSTALL}/lang/en_US/dialog.tlk" -i "${CUR}/po/pst-ee/ru/" -o "${PSTEE_INSTALL}/lang/ru_RU/dialog.tlk"
cd "${PSTEE_INSTALL}"
wine weidu.exe setup-pst-ee-l10n.tp2 --yes

# All set. We ready to generate archives
cp "${CUR}/readme.md" readme.txt
zip -9 -r "${CUR}/out/pst-ee-l10n-${PST_VERSION_PSTL10N}.zip" override lang/ru_RU readme.txt

zip -0 -r "${CUR}/out/pst-ee-l10n-Android-${PST_VERSION_PSTL10N}.zip" override lang/ru_RU readme.txt
./centralfix "${CUR}/out/pst-ee-l10n-Android-${PST_VERSION_PSTL10N}.zip"

