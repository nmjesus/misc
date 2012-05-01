#!/bin/bash

#TODO FOR WITH PREFIXS AND DIMENSIONS
#prefixs=("th1_resize" "th2_resize")
#dims=("200x165", "500x400")

get_path() {
    local PATHPHOTOS
    read -p 'Path: ' PATHPHOTOS

    if [ -d $PATHPHOTOS ]
    then
        echo "Starting..."
        resizer
        return 0 
    else
        echo "Invalid path"
        return 1
    fi
}

resizer() {
    FILES=$(ls -A $PATHPHOTOS | grep -E -i .*\(jpg\|jpeg\))
    THUMBS="thumbs"

    mkdir $PATHPHOTOS/$THUMBS

    for FILE in $FILES
    do
        FILENAME=${FILE%%.*}
        EXTENSION=${FILE##*.}
        SOURCE=$PATHPHOTOS/$FILENAME.$EXTENSION
        RESIZE_DESTINY=$PATHPHOTOS/$THUMBS/$FILENAME.$EXTENSION

        #Resize to 800
        convert $SOURCE -resize 800 $RESIZE_DESTINY

        #TODO LIST AND FOR
        CROP_DESTINY1="$PATHPHOTOS/$THUMBS/th1_resize_$FILENAME.$EXTENSION"
        CROP_DESTINY2="$PATHPHOTOS/$THUMBS/th2_resize_$FILENAME.$EXTENSION"

        #Crop the resized photos
        convert -define jpeg:size=200x165 $RESIZE_DESTINY -thumbnail '200x165>' -gravity center  -crop 200x165+0+0\! -background white -flatten $CROP_DESTINY1
        convert -define jpeg:size=500x400 $RESIZE_DESTINY -thumbnail '500x400>' -gravity center  -crop 500x400+0+0\! -background white -flatten $CROP_DESTINY2

        echo "$FILE processed"
    done

    return 1
}

get_path 
exit $?
