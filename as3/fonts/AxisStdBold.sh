#! /bin/sh
filename=$(basename $0)
filename="${filename%%.sh}"
dir=$(cd $(dirname $0) && pwd)
cd $dir
file=$dir'/Main.as'
~/flex_sdk_4/bin/mxmlc  -output ./$filename.swf --static-link-runtime-shared-libraries=true -omit-trace-statements=false -default-size 1024 768 -default-frame-rate=30 -default-background-color=0x000000 $filename.as
open -a /Applications/Safari.app $dir'/index.html'
tail -f ~/Library/Preferences/Macromedia/Flash\ Player/Logs/flashlog.txt