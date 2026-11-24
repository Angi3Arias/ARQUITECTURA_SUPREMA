$ErrorActionPreference = "Continue"
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $dir
python generar_pasos.py
$edge = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$items = @(
  @{n="paso1_pic_mclr";       w=1100; h=620},
  @{n="paso2_lcd_pot";        w=1200; h=680},
  @{n="paso3_teclado";        w=1150; h=680},
  @{n="paso4_leds";           w=1150; h=790},
  @{n="paso5_botones_buzzer"; w=1200; h=620},
  @{n="paso6_compim_uart";    w=1150; h=620}
)
foreach ($i in $items) {
  $svg = Join-Path $dir ($i.n + ".svg")
  $png = Join-Path $dir ($i.n + ".png")
  $uri = "file:///" + ($svg -replace '\\','/')
  & $edge --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 "--window-size=$($i.w),$($i.h)" "--screenshot=$png" $uri 2>&1 | Out-Null
  Start-Sleep -Milliseconds 350
  Write-Output "PNG -> $png"
}
