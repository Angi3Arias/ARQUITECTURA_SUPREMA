$ErrorActionPreference = "Continue"
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $dir
python generar_bocetos_lcd.py
$edge = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$items = @(
  @{n="proteus_vista_real_lcd"; w=2000; h=1140},
  @{n="protoboard_fisico_lcd";  w=1800; h=1120}
)
foreach ($i in $items) {
  $svg = Join-Path $dir ($i.n + ".svg")
  $png = Join-Path $dir ($i.n + ".png")
  $uri = "file:///" + ($svg -replace '\\','/')
  & $edge --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 "--window-size=$($i.w),$($i.h)" "--screenshot=$png" $uri 2>&1 | Out-Null
  Start-Sleep -Milliseconds 500
  Write-Output "PNG -> $png"
}
