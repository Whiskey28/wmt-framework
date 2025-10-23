# 修复所有文件中的 UTF-8 BOM 问题
Write-Host "开始修复 BOM 问题..." -ForegroundColor Green

$count = 0
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

# 修复所有 .imports 文件
Get-ChildItem -Recurse -Filter "*.imports" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    [System.IO.File]::WriteAllText($_.FullName, $content, $utf8NoBom)
    Write-Host "Fixed: $($_.FullName)" -ForegroundColor Yellow
    $count++
}

# 修复所有 .java 文件
Get-ChildItem -Recurse -Filter "*.java" | ForEach-Object {
    $bytes = [System.IO.File]::ReadAllBytes($_.FullName)
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        $content = Get-Content $_.FullName -Raw
        [System.IO.File]::WriteAllText($_.FullName, $content, $utf8NoBom)
        Write-Host "Fixed BOM in: $($_.Name)" -ForegroundColor Cyan
        $count++
    }
}

Write-Host "`n总共修复了 $count 个文件" -ForegroundColor Green
Write-Host "BOM 修复完成！" -ForegroundColor Green

