$ErrorActionPreference = "Stop"

Write-Host "=== USER MANAGEMENT - ANDROID + FIREBASE ===" -ForegroundColor Cyan

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    throw "Khong tim thay Flutter. Hay cai Flutter va them flutter/bin vao PATH."
}

Write-Host "[1/3] Tao cau hinh nen tang Android..."
flutter create --platforms=android .

Write-Host "[2/3] Cai dependencies..."
flutter pub get

if (-not (Get-Command flutterfire -ErrorAction SilentlyContinue)) {
    Write-Host "Chua co FlutterFire CLI. Cai bang: dart pub global activate flutterfire_cli" -ForegroundColor Yellow
    Write-Host "Sau do chay: flutterfire configure"
} else {
    Write-Host "[3/3] Cau hinh Firebase..."
    flutterfire configure
}

Write-Host ""
Write-Host "Neu FlutterFire CLI chua duoc cai, hay cai va chay 'flutterfire configure'." -ForegroundColor Green
Write-Host "Sau khi cau hinh Firebase, chay: flutter run"
