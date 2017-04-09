DIR = .

FILES = $(basename $(subst $(DIR)/pot/,, $(wildcard $(DIR)/pot/*.pot)))

MSGINIT=/usr/bin/msginit --no-translator
MSGMERGE=/usr/bin/msgmerge --update

LANG = ru

echo :
	for file in $(FILES) ; do \
		echo "$$file"; \
	done

po :
	for lang in $(LANG) ; do \
		for file in $(FILES) ; do \
			$(MSGINIT) -l $$lang -i pot/$$file.pot -o po/$$lang/$$file.po; \
		done; \
	done

po-update :
	for lang in $(LANG) ; do \
		for file in $(FILES) ; do \
			if [ -e po/$$lang/$$file.po ] ; then \
				echo -n "Updating $$lang/$$file"; \
				$(MSGMERGE) po/$$lang/$$file.po pot/$$file.pot; \
			else \
				$(MSGINIT) -l $$lang -i pot/$$file.pot -o po/$$lang/$$file.po; \
			fi; \
		done; \
	done

use-compendium:
	for lang in $(LANG) ; do \
		for file in $(FILES); do \
			echo -n "Updating $$lang/$$file with compendium"; \
			$(MSGMERGE) -U -C rest.po po/$$lang/$$file.po pot/$$file.pot; \
		done; \
	done

clean:
	for lang in $(LANG) ; do \
		rm -fr po/$$lang/*~; \
	done
