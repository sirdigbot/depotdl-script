@echo off

rem ---- Path of DepotDownloader. ----
set DEPOTPATH=E:\Programs\DepotDownloader\DepotDownloader.exe

rem ---- Path to the list of files to download FOR ALL GAMES. ----
rem ---- Invalid files are just ignored so this can be a single file for all games. ----
set FILELIST=E:\Documents\SourceEngine\depotdlscript_filelist.txt

rem ---- Final binary output directory. ----
set OUTDIR=E:\Documents\SourceEngine\Binaries

rem ---- DepotDownloader temporary download directory. ----
set TEMPDIR=E:\Documents\SourceEngine\Binaries\temp

rem ---- Example ----
rem E:\Programs\DepotDownloader\DepotDownloader.exe -app 240 -depot 232331 -filelist E:\Documents\SourceEngine\depotdownloader_filelist.txt -dir E:\Documents\SourceEngine\Binaries


set EXITKEY=9
set ALLGAMESKEY=0
set TF2KEY=1
set CSGOKEY=2
set CSSKEY=3
set L4D2KEY=4


echo ----------------------------------------------------------------------------
echo Digby's DepotDownloader Script
echo.
echo DepotDownloader Path: %DEPOTPATH%
echo File List:            %FILELIST%
echo Temp Directory:       %TEMPDIR%
echo Output Directory:     %OUTDIR%
echo.
echo Select Download Option:
echo.
echo     %ALLGAMESKEY%. All games listed below
echo.
echo         or
echo.
echo     %TF2KEY%. TF2
echo     %CSGOKEY%. CSGO
echo     %CSSKEY%. CSS
echo     %L4D2KEY%. L4D2
echo.
echo     %EXITKEY%. Exit
echo.
echo ----------------------------------------------------------------------------
set /p menuopt=:


if %menuopt%==%EXITKEY% exit



rem Prevent downloading if temp directory is not empty,
rem because I don't want to have to rmdir it and I dont want invalid binaries.
CALL :CheckTempDirIsEmpty



rem TF2 (App 232250)
rem Win Depot = 232255, Linux Depot = 232256
rem https://steamdb.info/app/232250/depots/
for %%a in (%ALLGAMESKEY% %TF2KEY%) do if %menuopt%==%%a (
    %DEPOTPATH% -app 232250 -depot 232255 -filelist %FILELIST% -dir %TEMPDIR%
    %DEPOTPATH% -app 232250 -depot 232256 -filelist %FILELIST% -dir %TEMPDIR%
    CALL :MoveTempFiles %TEMPDIR%\bin, tf2
    CALL :MoveTempFiles %TEMPDIR%\tf\bin, tf2
)


rem CSGO (App 740)
rem https://steamdb.info/app/740/depots/
for %%a in (%ALLGAMESKEY% %CSGOKEY%) do if %menuopt%==%%a (
    %DEPOTPATH% -app 740 -filelist %FILELIST% -dir %TEMPDIR%
    CALL :MoveTempFiles %TEMPDIR%\bin, csgo
    CALL :MoveTempFiles %TEMPDIR%\csgo\bin, csgo
)


rem CSS (App 240)
rem https://steamdb.info/app/240/depots/
for %%a in (%ALLGAMESKEY% %CSSKEY%) do if %menuopt%==%%a (
    %DEPOTPATH% -app 240 -depot 232331 -filelist %FILELIST% -dir %TEMPDIR%
    %DEPOTPATH% -app 240 -depot 232333 -filelist %FILELIST% -dir %TEMPDIR%
    CALL :MoveTempFiles %TEMPDIR%\bin, css
    CALL :MoveTempFiles %TEMPDIR%\cstrike\bin, css
)


rem L4D2 (App 222860)
rem https://steamdb.info/app/222860/depots/
for %%a in (%ALLGAMESKEY% %L4D2KEY%) do if %menuopt%==%%a (
    %DEPOTPATH% -app 222860 -depot 222862 -filelist %FILELIST% -dir %TEMPDIR%
    %DEPOTPATH% -app 222860 -depot 222863 -filelist %FILELIST% -dir %TEMPDIR%
    CALL :MoveTempFiles %TEMPDIR%\bin, l4d2
    CALL :MoveTempFiles %TEMPDIR%\left4dead2\bin, l4d2
)




:Done
echo.
echo.
echo.
echo ================================================================
echo FINISHED.
echo.
echo Remember to delete the temp directory:
echo     "%TEMPDIR%"
echo.
echo Temp directory must be empty before downloading again.
echo.
echo Press any key to close.
echo ================================================================
pause > nul
EXIT




rem --------------------------------------
rem Move and rename files with a prefix.
rem DepotDownloader has weird folder structure I don't like.
rem param1 = Source Directory
rem param2 = File prefix
rem --------------------------------------
:MoveTempFiles
echo ----------------------------------------------------------------
echo Moving temp files from "%~1" to %OUTDIR%
echo Prefixing with "%~2"
echo ----------------------------------------------------------------
for %%a in ("%~1\*") do move /Y "%%~fa" "%OUTDIR%\%~2_%%~nxa"
EXIT /b 0



rem --------------------------------------
rem As opposed to using rmdir which I don't trust to not obliterate things accidentally.
rem --------------------------------------
:CheckTempDirIsEmpty
if not exist %TEMPDIR% (
    echo ----------------------------------------------------------------
    echo "%TEMPDIR%" does not exist.
    echo Will be created.
    echo ----------------------------------------------------------------
    EXIT /b 0
)
for /F %%A in ('dir /b /a %TEMPDIR%') do (
    rem Already prints a message at :Done
    goto :Done
)
EXIT /b 0
