#!/bin/bash
#
# What:
# This script will find all *.png files in the current directory and:
# - optimise them using optipng (lossy)
# - optimise them using pngout  (lossless)

# How to use:
# Drag and drop this script into the folder of images to be optimised
# Run the script, either via terminal, or in VSCode (right-click and Run Code)

# Script:

# Get size of all PNG files before compression
BEFORE=`du -bch *.png|tail -1`

# Loop through all PNG files in folders and sub-folders
for f in $(find . -type f -name "*.png")
do
    echo "Optimising PNG: $f"

    # Rename the file to have a `-src`` suffix
    mv "$f" "${f%.*}-src.png"

    # Attempt to lossy compress, within a quality range:
    pngquant --speed 2 --quality 80-95 -f "${f%.*}-src.png" -o "$f"

    # Check that a lossy version was generated
    # If NOT, copy the src file
    if [ ! -f $f ]
    then
        echo "pngquant was unable to compress the file $f"
        cp "${f%.*}-src.png" "$f"
    fi

    # Losslessly optimise the output
    pngout $f

    # Remove the `-src` variant
    rm "${f%.*}-src.png"

    echo "--------------------------------------------"
done


AFTER=`du -bch *.png|tail -1`
NUMPNG=`find . -name "*.png" | wc -l`

echo ""
echo "--------------------------------------------"
echo "||       Finished optimising!             ||"
echo "--------------------------------------------"
echo "|| File count:    $NUMPNG"
echo "|| Starting size: $BEFORE"
echo "|| Final size:    $AFTER"
echo "--------------------------------------------"
echo ""
