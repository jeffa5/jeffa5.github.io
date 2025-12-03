#!/usr/bin/env python3

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
        print(f"\n{date} [{title}](./{page}/index.html)")
    else:
        raise Exception(f"invalid file {file}")
