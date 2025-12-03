OUT_DIR := public
TEMPLATES := $(wildcard templates/*)

# --- 1. Dependency Calculation ---

# Use shell find once, then filter/transform the results using Make functions
# Find all files in 'content/' and 'static/' directories
ALL_CONTENT_FILES := $(shell find content -type f)
ALL_STATIC_FILES := $(shell find static -type f)

# A. Markdown Files (Target: public/path/to/index.html)
# Filter for .md files, then transform the paths.
MARKDOWN_SRCS := $(filter %.md, $(ALL_CONTENT_FILES))
MARKDOWN_TARGETS := $(patsubst content/%.md, $(OUT_DIR)/%/index.html, $(MARKDOWN_SRCS))

BLOG_SRCS := $(wildcard content/blog/*)

# Handle the root index file separately if it exists (assuming content/index.md for simplicity)
ROOT_INDEX_MD := content/index.md
ROOT_INDEX_TARGET := $(patsubst content/index.md, $(OUT_DIR)/index.html, $(ROOT_INDEX_MD))

# B. Direct Content Files (Target: public/path/to/image.png)
# Filter for non-markdown content files and transform paths.
CONTENT_SRCS := $(filter-out %.md, $(ALL_CONTENT_FILES))
CONTENT_TARGETS := $(patsubst content/%, $(OUT_DIR)/%, $(CONTENT_SRCS))

# C. Static Files (Target: public/style.css)
STATIC_TARGETS := $(patsubst static/%, $(OUT_DIR)/%, $(ALL_STATIC_FILES))

# Combine all final targets
all: $(MARKDOWN_TARGETS) $(ROOT_INDEX_TARGET) $(CONTENT_TARGETS) $(STATIC_TARGETS)

# --- 2. Directory Creation (Order-Only Prerequisite) ---

# Extract the directory paths from the dynamic targets.
# $(dir $(patsubst content/%.md, $(OUT_DIR)/%/index.html, content/%.md)) -> $(OUT_DIR)/%
# For public/foo/index.html, this extracts public/foo.

# Get the list of unique directories that need to exist for all targets
ALL_TARGET_DIRS := $(sort $(dir $(MARKDOWN_TARGETS) $(ROOT_INDEX_TARGET) $(CONTENT_TARGETS) $(STATIC_TARGETS)))

# Directory creation rule (Phony target pattern)
# Use a pattern rule for directories, although an explicit list is faster if stable.
$(ALL_TARGET_DIRS):
	mkdir -p $@

# --- 3. Consolidated Rules ---

# Rule for all Markdown files (including nested ones)
# Uses the directory as an order-only prerequisite to ensure it's created first.
$(OUT_DIR)/%/index.html: content/%.md $(TEMPLATES) ./scripts/md-to-html.sh | $(ALL_TARGET_DIRS)
	./scripts/md-to-html.sh $< $@

# Rule for the Root Index file (content.md -> public/index.html)
# It's an explicit target, but can share the same recipe logic.
$(OUT_DIR)/index.html: content.md $(TEMPLATES) ./scripts/md-to-html.sh | $(ALL_TARGET_DIRS)
	./scripts/md-to-html.sh $< $@

# Consolidated rule for ALL direct file copies (png, svg, pdf, and static files)
# The prerequisite uses VPATH-like syntax (%). We only use the content/ and static/ prefixes
# to ensure the right source file is found by Make's pattern matching.
$(OUT_DIR)/%: content/% | $(ALL_TARGET_DIRS)
	cp $< $@

$(OUT_DIR)/%: static/% | $(ALL_TARGET_DIRS)
	cp $< $@

content/blog.md: $(BLOG_SRCS) ./scripts/page-tree.py
	./scripts/page-tree.py $(BLOG_SRCS) > $@

# --- Cleanup ---
.PHONY: all clean
clean:
	rm -rf $(OUT_DIR)
