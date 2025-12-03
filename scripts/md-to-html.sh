#!/usr/bin/env bash

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
