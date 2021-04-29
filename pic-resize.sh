#!/bin/sh

# requires imagemagick and perl-image-exiftool

set -e

targetDir="$1"
shift

widths="$1"
shift

for img in $@; do
    echo $img

    # make target directories
    dir=$(dirname "$img") # gets directory
    for targetWidth in $widths; do
        mkdir -p $targetDir/${targetWidth}px
    done

    # get width
    width=$(identify "$img" | awk '{print $3}' | cut -dx -f1)
    echo -e "\toriginal width: $width"

    #echo -e "\tremoving metadata"
    #exiftool -all= "$img" 2>/dev/null
    #rm -f "${img}_original" # exiftool makes a copy of the original, delete it

    for targetWidth in $widths; do
        targetFile=$targetDir/${targetWidth}px/$(basename "$img")
        echo -en "\tresizing into $targetFile... "
        if [ -e "$targetFile" ]; then
            echo -e "\tskipping, target file exists"
            continue
        elif [ "$targetWidth" -ge "$width" ]; then
            echo -e "\tskipping resize, original image too small"
            cp "$img" "$targetFile"
            continue
        fi
        convert "$img" -resize $targetWidth "$targetFile"
        echo -e "\tdone"
    done
done
