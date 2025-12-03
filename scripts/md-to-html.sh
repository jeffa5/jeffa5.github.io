#!/usr/bin/env bash

from=${1:?"need from"}
to=${2:?"need to"}

cat templates/head.html templates/header.html > $to
lowdown $from >> $to
cat templates/footer.html templates/foot.html >> $to
./scripts/replace-vars.sh $to
