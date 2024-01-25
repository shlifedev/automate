if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
    $userResponse = Read-Host "FFmpeg가 설치되어 있지 않습니다. 설치하시겠습니까? (Y/N)"
    if ($userResponse -eq 'Y') {
        # FFmpeg 설치
        choco install ffmpeg -y
    } else {
        Write-Host "FFmpeg 설치를 취소했습니다."
        exit
    }
}