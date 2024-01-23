#!/bin/bash
 
read -p "Enter the download path: " download_path 
read -p "Enter the YouTube channel name (e.g., @SebastianLague): " channel_name
yt-dlp -o "$download_path/%(uploader)s/%(playlist)s/%(title)s.%(ext)s" \
--yes-playlist \
--format "bestvideo[height<=1080]+bestaudio/best[height<=1080]" \
--merge-output-format mp4 \
--write-sub \
--write-auto-sub \
--sub-langs 'en' \
--convert-subs srt \
--external-downloader aria2c \
--external-downloader-args "-x 16 -k 1M" \
https://www.youtube.com/$channel_name/playlists
