@echo off
:: Verifica se é administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Solicitando permissao de administrador...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

:: Executa o script remoto
powershell -Command "irm https://massgrave.dev/get | iex"

:: Aguarda o script abrir o CMD
timeout /t 15 >nul

:: Envia a opção 1 com foco garantido na janela CMD
powershell -Command ^
    "$wshell = New-Object -ComObject wscript.shell; " ^
    "Start-Sleep -Seconds 2; " ^
    "if ($wshell.AppActivate('Administrador: Prompt de Comando') -or $wshell.AppActivate('Prompt de Comando')) { " ^
        "$wshell.SendKeys('1{ENTER}'); " ^
    "} else { " ^
        "Write-Host 'Janela CMD nao encontrada'; exit 1; " ^
    "}"

:: Espera 15 segundos para garantir execução antes de fechar
timeout /t 15 >nul

:: Fecha janelas cmd e powershell
powershell -Command ^
"Get-Process -Name cmd -ErrorAction SilentlyContinue | ForEach-Object { $_.CloseMainWindow() | Out-Null; Start-Sleep -Milliseconds 500; if (!$_.HasExited) { $_.Kill() } }; " ^
"Get-Process -Name powershell -ErrorAction SilentlyContinue | ForEach-Object { $_.CloseMainWindow() | Out-Null; Start-Sleep -Milliseconds 500; if (!$_.HasExited) { $_.Kill() } }"

:: destruidor de windows FX

