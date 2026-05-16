# GitHub Pages 자동 배포 스크립트
# index.html / service.html 저장 감지 → 자동 git add + commit + push

$folder = Split-Path -Parent $MyInvocation.MyCommand.Path

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $folder
$watcher.Filter = "*.html"
$watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite
$watcher.EnableRaisingEvents = $true

Write-Host "감시 시작: $folder\*.html"
Write-Host "index.html / service.html 저장 시 자동으로 GitHub에 push됩니다."
Write-Host "종료하려면 Ctrl+C"

while ($true) {
    $changed = $watcher.WaitForChanged([System.IO.WatcherChangeTypes]::Changed, 3000)
    if (-not $changed.TimedOut) {
        $changedFile = $changed.Name
        Write-Host "`n[$((Get-Date).ToString('HH:mm:ss'))] $changedFile 변경 감지 → push 시작..."
        Set-Location $folder
        git add $changedFile
        git commit -m "auto: update $changedFile $((Get-Date).ToString('yyyy-MM-dd HH:mm'))"
        git push
        Write-Host "push 완료."
    }
}
