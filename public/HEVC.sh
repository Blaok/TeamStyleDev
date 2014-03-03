#!/bin/sh
height=`ffprobe -v quiet -print_format json -show_format -show_streams $1|grep height`
height=${height/\"height\":/}
height=${height/,/}
height=`echo $height`
echo $height
width=`ffprobe -v quiet -print_format json -show_format -show_streams $1|grep width`
width=${width/\"width\":/}
width=${width/,/}
width=`echo $width`
echo $width
fr=`ffprobe -v quiet -print_format json -show_format -show_streams $1|grep avg_frame_rate -m 1`
fr=${fr/\"avg_frame_rate\":/}
fr=${fr/,/}
fr=${fr/\"/}
fr=${fr/\"/}
fr=`echo $fr`
echo $fr
ffmpeg -i $1 -pix_fmt yuv420p -t 20 -f rawvideo -|x265 - --input-res ${width}x${height} --fps $fr --crf 12 -o $1.hevc
#ffmpeg -i $1 -vn -acodec aac -scodec copy $1.mka
