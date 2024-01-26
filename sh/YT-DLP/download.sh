#!/bin/bash
 
# 사용자에게 다운로드 경로를 입력받습니다.
read -p "Enter the download path: " download_path

# 사용자에게 YouTube 채널 ID를 입력받습니다.
read -p "Enter the YouTube channel ID (e.g., UCsXVk37bltHxD1rDPwtNM8Q): " channel_id

# 사용자에게 플레이리스트 또는 채널 동영상 중 선택을 입력받습니다.
read -p "Do you want to download all playlists (P) or all videos from the channel (C)? [P/C]: " download_choice

read -p "Enter the desired video resolution (e.g., 720, 1080) (default: 1080): " video_resolution

# 사용자에게 자막만 다운로드할지 묻습니다.
read -p "Do you want to download only subtitles? [Y/N] (default: N): " subtitles_only_choice
subtitles_only_choice=${subtitles_only_choice:-N}

 
video_resolution=${video_resolution:-1080}
video_options="--format bestvideo[height<=$video_resolution]+bestaudio/best[height<=$video_resolution]"


# 자막 다운로드 옵션을 설정
subtitle_options="--write-sub --write-auto-sub --convert-subs srt"



# 자막만 다운로드할 경우 옵션 설정
 
if [[ $subtitles_only_choice =~ [Yy] ]]; then
    video_options="--skip-download"
fi
 

# 다운로드 옵션에 따라 URL과 출력 형식 설정
if [[ $download_choice =~ [Pp] ]]; then
    url="https://www.youtube.com/c/$channel_id/playlists"
    output_template="$download_path/$channel_id/%(playlist_title)s/%(title)s.%(ext)s"
else
    url="https://www.youtube.com/c/$channel_id/videos"
    output_template="$download_path/$channel_id/%(title)s.%(ext)s"
fi

# yt-dlp 명령어를 실행합니다.
yt-dlp -v -o "$output_template" \
$video_options \
$subtitle_options \
--ignore-errors \
--external-downloader aria2c \
--external-downloader-args "-x 16 -k 1M" \
$url
