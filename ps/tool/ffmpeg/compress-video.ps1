$sourceFolder = Read-Host "압축할 비디오가 있는 폴더 경로를 입력하세요" 
$compressValue = Read-Host "압축률 선택 (최소 28 추천)"
$files = Get-ChildItem -Path $sourceFolder -Recurse -Include *.mp4,*.mkv,*.avi

foreach ($file in $files) { 
    $metadata = ffprobe -v quiet -show_format -print_format json "$file.FullName"
    $metadataJson = $metadata | ConvertFrom-Json
    $alreadyCompressed = $false
    
    if ($metadataJson.format.tags) {
        $alreadyCompressed = $metadataJson.format.tags.compressed -eq 'true'
    }

    if ($alreadyCompressed) {
        Write-Host "파일은 이미 압축되었습니다: $($file.FullName)"
        continue
    } 
    $tempFile = [System.IO.Path]::GetTempFileName() + ".mp4" 
    ffmpeg -i $file.FullName -c:v h264_nvenc -preset slow -cq:v $compressValue -c:a aac -b:a 96k -metadata compressed=true -y $tempFile 
    if ($? -and (Get-Item $tempFile).Length -lt (Get-Item $file.FullName).Length) {
        Move-Item -Path $tempFile -Destination $file.FullName -Force
    } else {
        Write-Host "압축된 파일이 원본보다 크거나 오류가 발생했습니다: $file"
        Remove-Item -Path $tempFile
    }
}