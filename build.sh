source $stdenv/setup
set -e

d="$out/var/www/kellyandbrian.info"
mkdir -p "$d"
$jekyll_env/bin/jekyll build -s "$src" -d "$d"
