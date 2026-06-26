@echo off
setlocal

set "HOST=127.0.0.1"
set "PORT=8080"
set "FRONTEND_URL=http://%HOST%:%PORT%"

echo Iniciando MUVE Flutter Web...
echo Front-end: %FRONTEND_URL%
echo API:       fallback automatico do app
if not "%MUVE_API_BASE_URL%"=="" echo API override: %MUVE_API_BASE_URL%
echo.

start "" powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "$url='%FRONTEND_URL%'; $hostName='%HOST%'; $port=%PORT%; $deadline=(Get-Date).AddSeconds(90); do { Start-Sleep -Milliseconds 700; try { $client=New-Object Net.Sockets.TcpClient; $async=$client.BeginConnect($hostName,$port,$null,$null); if ($async.AsyncWaitHandle.WaitOne(250)) { $client.EndConnect($async); $client.Close(); $chromePaths=@($env:ProgramFiles + '\Google\Chrome\Application\chrome.exe', ${env:ProgramFiles(x86)} + '\Google\Chrome\Application\chrome.exe', $env:LOCALAPPDATA + '\Google\Chrome\Application\chrome.exe'); $chrome=$chromePaths | Where-Object { Test-Path $_ } | Select-Object -First 1; if ($chrome) { Start-Process $chrome $url } else { Start-Process $url }; exit 0 }; $client.Close() } catch {} } while ((Get-Date) -lt $deadline); exit 1"

if "%MUVE_API_BASE_URL%"=="" (
  flutter run -d web-server --web-hostname %HOST% --web-port %PORT%
) else (
  flutter run -d web-server --web-hostname %HOST% --web-port %PORT% --dart-define=MUVE_API_BASE_URL=%MUVE_API_BASE_URL%
)

endlocal
