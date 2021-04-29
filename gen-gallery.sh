#!/bin/sh

# requires imagemagick and perl-image-exiftool

set -e

srcFiles=$@

target_thumb_w=500
target_w=1920

echo "generating images ..."
#./pic-resize.sh "src/img/gallery" "$target_thumb_w $target_w" $srcFiles

gallery_yml=src/_data/gallery.yml
echo "generating $gallery_yml ..."

echo "target_thumb_w: $target_thumb_w" > $gallery_yml
echo "target_w: $target_w" >> $gallery_yml
echo 'imgs:' >> $gallery_yml

for img_orig in $srcFiles; do
    img=$(basename $img_orig)
    echo "$img"

    thumb_dim=$(identify "src/img/gallery/${target_thumb_w}px/$img" | awk '{print $3}')
    thumb_w=$(echo "$thumb_dim" | cut -dx -f1)
    thumb_h=$(echo "$thumb_dim" | cut -dx -f2)

    dim=$(identify "src/img/gallery/${target_w}px/$img" | awk '{print $3}')
    w=$(echo "$dim" | cut -dx -f1)
    h=$(echo "$dim" | cut -dx -f2)

    echo '- {"file":"'$img'","thumb_w":'$thumb_w',"thumb_h":'$thumb_h',"w":'$w',"h":'$h'}' >>$gallery_yml
done
