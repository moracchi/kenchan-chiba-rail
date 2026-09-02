# kenchan-chiba-rail.html（Artifact 用のフラグメント）から、
# GitHub Pages 用の完全な HTML 文書 index.html を生成します。
#
#   pwsh ./build.ps1        （Windows PowerShell 5.1 なら powershell -File build.ps1）
#
# Artifact は <head> を自動で付けてくれますが、GitHub Pages で配信するには
# charset と viewport を自分で持った文書にする必要があるため、この一手間を挟みます。
# ページを直すときは kenchan-chiba-rail.html だけを編集し、これを実行してください。

$ErrorActionPreference = 'Stop'
$src = Join-Path $PSScriptRoot 'kenchan-chiba-rail.html'
$out = Join-Path $PSScriptRoot 'index.html'

$body = [System.IO.File]::ReadAllText($src, [System.Text.Encoding]::UTF8)

# 先頭に並んでいる <title> と <link> を <head> へ移す
$headTags = ''
while ($body -match '^\s*(<(?:title|link)\b[^>]*>(?:[^<]*</title>)?)') {
    $headTags += '  ' + $Matches[1] + "`n"
    $body = $body.Substring($Matches[0].Length)
}

$icon = "data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>&#128691;</text></svg>"

$doc = @"
<!doctype html>
<html lang="ja">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
  <meta name="description" content="サンキューちばフリーパスで千葉のローカル線をめぐる2日間の行程表。1日目は小湊鉄道とトロッコ、2日目は東海神から銚子ループ。">
  <meta name="theme-color" content="#FBF7EE" media="(prefers-color-scheme: light)">
  <meta name="theme-color" content="#101A1F" media="(prefers-color-scheme: dark)">
  <meta name="color-scheme" content="light dark">
  <link rel="icon" href="$icon">
  <link rel="apple-touch-icon" href="$icon">
  <meta name="apple-mobile-web-app-capable" content="yes">
$headTags</head>
<body>
$($body.TrimEnd())
</body>
</html>
"@

[System.IO.File]::WriteAllText($out, $doc, (New-Object System.Text.UTF8Encoding($false)))
Write-Host "index.html を生成しました ($((Get-Item $out).Length) bytes)"
