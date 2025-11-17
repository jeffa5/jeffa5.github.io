# no need for implicits here
.SUFFIXES:

OUT_DIR=public
MARKDOWN_FILES=$(addprefix $(OUT_DIR)/,$(patsubst content/%.md,%/index.html,$(shell find content -name '*.md' -type f)))
PDF_FILES=$(addprefix $(OUT_DIR)/,$(patsubst content/%.pdf,%.pdf,$(shell find content -name '*.pdf' -type f)))
STATIC_FILES=$(patsubst static/%,$(OUT_DIR)/%,$(shell find static -type f))
TEMPLATES=$(wildcard templates/*)

all: $(MARKDOWN_FILES) $(OUT_DIR)/index.html $(PDF_FILES) $(STATIC_FILES)

$(OUT_DIR)/%/index.html: content/%.md $(TEMPLATES)
	mkdir -p $$(dirname $@)
	cat templates/head.html > $@
	cat templates/header.html >> $@
	lowdown $< >> $@
	cat templates/footer.html >> $@
	cat templates/foot.html >> $@
	./scripts/replace-vars.sh $@

$(OUT_DIR)/index.html: content.md $(TEMPLATES)
	mkdir -p $$(dirname $@)
	cat templates/head.html > $@
	cat templates/header.html >> $@
	lowdown $< >> $@
	cat templates/footer.html >> $@
	cat templates/foot.html >> $@
	./scripts/replace-vars.sh $@

$(OUT_DIR)/%.pdf: content/%.pdf
	mkdir -p $$(dirname $@)
	cp $< $@

$(OUT_DIR)/%: static/%
	mkdir -p $$(dirname $@)
	cp $< $@

.PHONY: clean
clean:
	rm -rf public
