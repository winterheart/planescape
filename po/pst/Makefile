LANG = ru


POT_FILES := $(subst pot/,, $(wildcard pot/*/*.pot))
PO_FILES := $(POT_FILES:.pot=.po)
OLD_FILES := $(wildcard $(LANG)/*/*.po~)

MSGINIT=/usr/bin/msginit --no-translator
MSGMERGE=/usr/bin/msgmerge --update


$(LANG)/%.po: pot/%.pot
	@if [ -a $@ ] ; then \
		echo "Updating $@" ; \
		$(MSGMERGE) $@ $^; \
	else \
		echo "Creating $@" ; \
		$(MSGINIT) -l $(LANG) -i $^ -o $@; \
	fi;

po: $(addprefix $(LANG)/, $(POT_FILES:.pot=.po))

clean:
	@rm $(OLD_FILES)

all: po
