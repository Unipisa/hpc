#!/bin/sh
# compress all *.jpg files in the current directory
# and place them in ./compressed directory
# with the same modification date as original files.

for i in *.png; do jpegoptim --size=2000kb -d ./compressed -p "$i"; done
