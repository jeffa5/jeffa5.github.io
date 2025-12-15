# `make` your static site

This website is just a static site, and I'm trying to move more things to static sites now that I want to self-host more things, like [my git repos](https://git.jeffas.net), a personal knowledge-base/wiki and files on my NAS server.

I'm more of a person who wants to know how my things work, to some extent at least, and don't feel like I often want a lot of the bells and whistles of full-featured mainstream tools.
This site used to be built with [Zola](https://getzola.com), which means the structure is pretty similar now to what it was before, but instead, I now build it with Make directly.
There are trade-offs to this approach and it was more manual, but also more customisable without having to understand the Zola codebase.

The main work the `Makefile` does is converting markdown files to html files.
For this I have a script (below) that takes a file to read from, and a path to write to.
This builds the page with my templates, converting the markdown content with `lowdown`.
I store the date in the path to keep the blog entries unique and aid in building the list of articles.
Templates are just simple snippets of html that are intended to be sequenced.

```bash
from=${1:?"need from"}
to=${2:?"need to"}

cat templates/head.html templates/header.html > $to

if [[ "$from" == content/blog/* ]]; then
  date=$(basename $from | cut -d- -f -3)
  echo "<em>$date</em>" >> $to
fi

lowdown $from >> $to
cat templates/footer.html templates/foot.html >> $to
./scripts/replace-vars.sh $to
```

The `./scripts/replace-vars.sh` script is a simple one that just runs a `sed` command to replace some placeholder I have in the templates, aiming to make the site fully relocatable under other URLs if needed, and make it work when viewing as a filesystem.

```bash
file=${1:?"need a file as the argument"}

BASE_URL_RELATIVE="$(echo "$1" | sed -e 's#public/##' | sed -e 's#[^/]\+/#../#g' | xargs dirname)"
sed -i -e "s#BASE_URL_RELATIVE#$BASE_URL_RELATIVE#" "$1"
```

That's mostly it, static files are copied as is to the build directory and I commit the built website so that I can see and track the diff there as not all changes will have a come from the content of articles.
I can also use that to check if I break the build process.

The final interesting script for me, not that its complex, is the page-tree builder, that builds the listing of blog articles.
Its a python script that just goes through the articles and finds the title.

```python
import os.path
import sys

pages = sys.argv[1:]
if not pages:
    print("need a list of pages to process", file=sys.stderr)
    sys.exit(1)

prefix = "content/blog/"

pages = [page.removeprefix(prefix) for page in pages]

pages.sort(reverse=True)

print("# Blog")

for page in pages:
    file = f"{prefix}{page}"
    if not os.path.isfile(file):
        continue

    page = os.path.splitext(page)[0]

    dirname = os.path.dirname(page)
    if not dirname:
        dirname = "."

    stem = os.path.basename(page)

    date = "-".join(stem.split("-")[:3])

    title = open(file, 'r').readline().strip()
    if title.startswith("# "):
        title = title.removeprefix("# ")
        print(f"\n_{date}_ [{title}](./{page}/index.html)")
    else:
        raise Exception(f"invalid file {file}")
```

The other piece that brings it all together is the `Makefile`.
I wrote a version and then was curious to see how Gemini would handle it so there is some AI-generated influence here.

Could it be more efficient? Maybe.
But its incremental so I don't need it to be hugely efficient anyway, its only a small blog.
Scaling this out to other projects I have, like building a static site of my personal cloud files will likely be something based on [`ninja`](https://ninja-build.org) as I'm curious about it and it has some nice features like build graph visualisation, parallelism built-in (yes, I know I could use `-j` with Make), and an interesting split in generating the build description somehow else before `ninja` builds it optimally.

I'm happy with this for now, its easy to use, doesn't have a lot of dependencies and feels easy to reconfigure if I want to switch to authoring in another format, e.g. `typst`.

```make
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
```
