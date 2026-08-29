# kenchan-chiba-rail.html（Artifact 用のフラグメント）から、
# GitHub Pages 用の完全な HTML 文書 index.html を生成します。
#
#   pwsh ./build.ps1
#
# Artifact は <head> を自動で付けてくれますが、GitHub Pages で配信するには
# charset と viewport を自分で持った文書にする必要があるため、この一手間を挟みます。
# ページを直すときは kenchan-chiba-rail.html だけを編集し、これを実行してください。

$ErrorActionPreference = 'Stop'
$src = Join-Path $PSScriptRoot 'kenchan-chiba-rail.html'
$out = Join-Path $PSScriptRoot 'index.html'

$body = Get-Content -Raw -Encoding UTF8 $src

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
  <meta name="description" content="サンキューちばフリーパスで千葉の鉄道を2日間乗り倒す行程表。1日目は小湊鉄道とトロッコ、2日目は銚子ループ。">
  <meta name="theme-color" content="#F3F6EF" media="(prefers-color-scheme: light)">
  <meta name="theme-color" content="#0D1411" media="(prefers-color-scheme: dark)">
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

Set-Content -Path $out -Value $doc -Encoding UTF8
Write-Host "index.html を生成しました ($((Get-Item $out).Length) bytes)"
