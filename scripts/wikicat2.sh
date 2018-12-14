#!/bin/sh
# clean up wiki for running through apertium-destxt
# http://wiki.apertium.org/wiki/Talk:Calculating_coverage#wikicat2.sh

# awk prints full lines, make sure each html element has one
#bzcat "$@" | sed 's/>/>\n/g' | sed 's/</\n</g' |\
cat "$@" | sed 's/>/>\n/g' | sed 's/</\n</g' |\
# want only stuff between <text...> and </text>
awk '
/<text.*>/,/<\/text>/ { print $0 }
' |\

sed 's/\[\[\([a-z]\{2,3\}\):[^]]\+\]\]//g' |\
# Drop all transwiki links

sed 's/\[\[[^]|]*|//g' | sed 's/\]\]//g' | sed 's/\[\[//g' |\
# wiki markup, retain bar and fie from [[foo|bar]] [[fie]]
sed 's/\[http[^ ]*\([^]]*\)\]/\1/g' |\
# wiki markup, retain `bar fie' from [http://foo bar fie]

sed 's/&.*;/ /g' |\
# remove entities greedily, so as to get rid of hidden html too

# isalgueiro
sed "s/''//g" |\
sed "s/^Categoría://g" |\

# Keep only lines starting with a capital letter, removing tables with style info etc.
grep '^[ \t]*[A-ZÆØÅÁÉÍÓÚÑ]' # Your alphabet here
