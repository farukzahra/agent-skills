@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0sync-faruk-skills.ps1" %*
exit /b %ERRORLEVEL%
