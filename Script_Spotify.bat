@echo off
call :RequestAdminElevation "%~dpfs0" %* || goto:eof
mode con: cols=60 lines=10
title -Script to block Spotify advertising-
echo +++++++++++++++++++++++++++++++++++++++++++++++++
echo + -Script to remove ads from Spotify- +
echo + Made by LemonizDev#2550 +
echo +++++++++++++++++++++++++++++++++++++++++++++++++
echo.
echo.
pause
TASKKILL /IM Spotify.exe /F 2> nul
copy %SystemRoot%\system32\drivers\etc\hosts %SystemRoot%\system32\drivers\etc\hosts.backup
echo. >>"%SystemRoot%\system32\drivers\etc\hosts"
echo. >>"%SystemRoot%\system32\drivers\etc\hosts"
echo #Bloqueo publicidad Spotify>>"%SystemRoot%\system32\drivers\etc\hosts"
echo 0.0.0.0 adclick.g.doublecklick.net>>"%SystemRoot%\system32\drivers\etc\hosts"
echo 0.0.0.0 googleads.g.doubleclick.net>>"%SystemRoot%\system32\drivers\etc\hosts"
echo 0.0.0.0 http://www.googleadservices.com>>"%SystemRoot%\system32\drivers\etc\hosts"
echo 0.0.0.0 pubads.g.doubleclick.net>>"%SystemRoot%\system32\drivers\etc\hosts"
echo 0.0.0.0 securepubads.g.doubleclick.net>>"%SystemRoot%\system32\drivers\etc\hosts"
echo 0.0.0.0 pagead2.googlesyndication.com>>"%SystemRoot%\system32\drivers\etc\hosts"
echo 0.0.0.0 spclient.wg.spotify.com>>"%SystemRoot%\system32\drivers\etc\hosts"
echo 0.0.0.0 audio2.spotify.com>>"%SystemRoot%\system32\drivers\etc\hosts"
echo # >>"%SystemRoot%\system32\drivers\etc\hosts"
cd %appdata%\Spotify\Apps
del /f /q ad.spa
IF NOT EXIST ad.spa echo. >ad.spa
cd..
Start Spotify.exe
msg * Poggies, All ads have been removed successfully
exit
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:RequestAdminElevation FilePath %* || goto:eof
:: 
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
setlocal ENABLEDELAYEDEXPANSION & set "_FilePath=%~1"
  if NOT EXIST "!_FilePath!" (echo/Read RequestAdminElevation usage information)
  :: UAC.ShellExecute only works with 8.3 filename, so use %~s1
  set "_FN=_%~ns1" & echo/%TEMP%| findstr /C:"(" >nul && (echo/ERROR: %%TEMP%% path can not contain parenthesis &pause &endlocal &fc;: 2>nul & goto:eof)
  :: Remove parenthesis from the temp filename
  set _FN=%_FN:(=%
  set _vbspath="%temp:~%\%_FN:)=%.vbs" & set "_batpath=%temp:~%\%_FN:)=%.bat"

  :: Test if we gave admin rights
  fltmc >nul 2>&1 || goto :_getElevation

  :: Elevation successful
  (if exist %_vbspath% ( del %_vbspath% )) & (if exist %_batpath% ( del %_batpath% )) 
  :: Set ERRORLEVEL 0, set original folder and exit
  endlocal & CD /D "%~dp1" & ver >nul & goto:eof

  :_getElevation
  echo/Please wait, youre going to see a UAC popup asking lF you want Windows command Processor to make changes to your device, please click on yes.
  :: Try to create %_vbspath% file. If failed, exit with ERRORLEVEL 1
  echo/Set UAC = CreateObject^("Shell.Application"^) > %_vbspath% || (echo/&echo/Unable to create %_vbspath% & endlocal &md; 2>nul &goto:eof) 
  echo/UAC.ShellExecute "%_batpath%", "", "", "runas", 1 >> %_vbspath% & echo/wscript.Quit(1)>> %_vbspath%
  :: Try to create %_batpath% file. If failed, exit with ERRORLEVEL 1
  echo/@%* > "%_batpath%" || (echo/&echo/Unable to create %_batpath% & endlocal &md; 2>nul &goto:eof)
  echo/@if %%errorlevel%%==9009 (echo/^&echo/Admin user could not read the batch file. If running from a mapped drive or UNC path, check if Admin user can read it.)^&echo/^& @if %%errorlevel%% NEQ 0 pause >> "%_batpath%"

  :: Run %_vbspath%, that calls %_batpath%, that calls the original file
  %_vbspath% && (echo/&echo/Failed to run VBscript %_vbspath% &endlocal &md; 2>nul & goto:eof)

  :: Vbscript has been run, exit with ERRORLEVEL -1
  echo/&echo/Elevation was requested on a new CMD window &endlocal &fc;: 2>nul & goto:eof
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
