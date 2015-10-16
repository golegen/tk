@echo off
rem Written by Nicholas B. Colins 9/27/2015
rem Purpose of this batch file is to download tools I use on a daily
rem basis for removing infections and cleaning up PCs
rem
rem Usage: tk mbam 
rem      
rem Setup defaults

set TOOL_DIR=vscan
set VSCAN=%SystemDrive%\%TOOL_DIR%
rem just incase,
if not exist %VSCAN% mkdir %VSCAN% 
set ERRORLEVEL=0 
set VSCAN_PATH_EXIST=NO

rem Adding VSCAN to PATH so things like sigcheck will work in any directory
set PATHQ=%PATH%
rem echo %VSCAN_PATH_EXIST%
:WHILE
if ["%PATHQ%"]==[""] goto WEND
for /F "delims=;" %%i in ("%PATHQ%") do (
rem echo [%%i]==[%VSCAN%]
if [%%i]==[%VSCAN%] set VSCAN_PATH_EXIST=YES
)     
for /F "delims=; tokens=1,*" %%i in ("%PATHQ%") do set PATHQ=%%j
rem echo %PATHQ% 
goto WHILE 
:WEND

if %VSCAN_PATH_EXIST%==NO set PATH=%PATH%;%VSCAN%
SetLocal 	
set LOG_FILE_NAME=tool_log.txt
set LOG_FILE=%VSCAN%\%LOG_FILE_NAME%
set UNZIP_FIRST=NO 
set ERRORLEVEL=0
set SECOND_LINK=NONE
set FIRST_LINK=NONE
set INSTALL_CMD=NONE
set INSTALL_ARGS= 
set LAUNCH_ARGS=
set LAUNCH_CMD=NONE
set ERROR_MSG=0
set DELETE_PREVIOUS_DL=NO 

rem check if 32bit or 64bit system
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set IS64=NO || set IS64=YES
rem Set PF - program files 
if %IS64%==YES (
set PF=%ProgramFiles(x86)%
) else (
set PF=%ProgramFiles%
)

rem echo 64bit system: %IS64%

rem Tool requested, first argument passed to the batch file
set TOOLNAME=%1
set REMOVE_DL=%2
rem If the second argument is X then it deletes the previous downloaded file
if [%REMOVEz_DL%]==[X] set DELETE_PREVIOUS_DL=YES 

if [%TOOLNAME%]==[] goto useage 

time /t > set %TIME%=%1 
date /t > set %DATE%=%1 

echo Time: %DATE% %TIME% - Command request %TOOLNAME% >> %LOG_FILE% 

rem Which tool did we want?
rem Make sure to add your tool name here if you add a new tool

if %TOOLNAME%==mbam goto mbam
if %TOOLNAME%==mbamun goto mbamun
if %TOOLNAME%==jrt goto jrt
if %TOOLNAME%==mbar goto mbar 
if %TOOLNAME%==mbarun goto mbarun
if %TOOLNAME%==cc goto cc
if %TOOLNAME%==hitman goto hitman
if %TOOLNAME%==tds goto tds
if %TOOLNAME%==cleanar goto cleanar
if %TOOLNAME%==listdlls goto listdlls
if %TOOLNAME%==handle goto handle
if %TOOLNAME%==autoruns goto autoruns
if %TOOLNAME%==geek goto geek 
if %TOOLNAME%==sigcheck goto sigcheck
if %TOOLNAME%==process goto process_explorer
if %TOOLNAME%==safeinst goto safe_mode_installs 
if %TOOLNAME%==remove goto remove_tools 
if %TOOLNAME%==adw goto adwcleaner
if %TOOLNAME%==zhp goto zhp 
if %TOOLNAME%==rogue goto roguekiller
if %TOOLNAME%==java goto java
if %TOOLNAME%==netreset goto network_reset 
if %TOOLNAME%==tfcnew goto tfc_new
if %TOOLNAME%==tfcold goto tfc_old
if %TOOLNAME%==help goto help 
if %TOOLNAME%==eclear goto clear_events
if %TOOLNAME%==nrt goto norton_removal_tool
if %TOOLNAME%==mrt goto mcafee_removal_tool
if %TOOLNAME%==art goto avast_removal_tool
if %TOOLNAME%==wrt goto webroot_removal_tool 
if %TOOLNAME%==krt goto kaspersky_removal_tool
if %TOOLNAME%==javara goto javara 
if %TOOLNAME%==checkapps goto check_instlled_apps
if %TOOLNAME%==rhelp goto  anti_virus_removal_help 
if %TOOLNAME%==esr goto eset_service_repair

echo %TOOLNAME% command requested. Not found >> %LOG_FILE%
:useage 
rem No tool found display usage
echo Usage: tk toolname 
echo Type tk help for full list of commands
goto done 

:anti_virus_removal_help 
echo Antivirus removal tool commands: 
echo nrt - Norton Removal Tool 
echo mrt - Mcafee Removal Tool 
echo art - Avast Removal Tool 
echo krt - Kaspersky Removal Tool 
echo wrt - WebRoot Removal Tool 
goto done 

:help
echo Available commands: 
echo checkapps - Record installed applications, then compare to after tuneup
echo cc        - CCleaner 
echo tfcold    - Temporary File Cleaner 
echo tfcnew    - Temporary File Cleaner New (No Java Required)
echo jrt       - Junk software removal tool
echo mbam      - Malwarebytes
echo mbar      - Malwarebytes Anti-Root Kit
echo hitman    - Hitman virus secondary scanner
echo zhp       - ZHPCleaner 
echo adw       - ADW Cleaner 
echo rogue     - RogueKiller 
echo tds       - Kapsersky rootkit scanner
echo cleanar   - Clean Autoruns
echo java      - Install java (offline installer) 
echo javara    - Java Remover
echo esr       - ESET service repair 
echo kb        - Kill browsers 
echo mbamun    - Remove Malwarebytes
echo mbarun    - Remove MBAR from Desktop
echo eclear    - Clear Events 
echo autoruns  - Autoruns
echo sigcheck  - Verifiy a files signature or upload it to virustotal.com
echo listdlls  - View running processes and the DLL's they have loaded
echo handle    - View files open on the system 
echo process   - Process explorer 
echo safeinst  - Enable safe mode installs 
echo netreset  - Network resets (winsock, int, winhttp, advfirewall)
echo rhelp     - Show Antivirus removal tools
echo remove    - Remove tool kit
echo -------------------------------------------
echo Usage: tk command
echo    IE: tk mbam 
echo        tk mbam X  (Deletes previous downloaded file)
echo        tk rhelp (Removal tool list)
goto done

rem Add new commands here
rem Make sure goto the approipiate label after setting up your command
rem IE goto download_file  or goto done
rem All variables are pre-set, no need to set them if its not required
rem
rem set UNZIP_FIRST=YES if you need your tool unzipped after downloading.
rem The downloaded file is always saved as %FILE_NAME% environment variable

rem :new_tool
rem set FILE_NAME=new_tool.exe 
rem set FIRST_LINK=http://toolhost.com/tool.exe
rem set SECOND_LINK=http://anothersitehost.org/new_tool.exe
rem set LAUNCH_CMD=%VSCAN%\new_tool.exe
rem [========== ADD NEW COMMANDS BELOW HERE ======== ]

:kill_browsers
taskkill /f /im iexplore.exe
taskkill /f /im chrome.exe
taskkill /f /im safari.exe
taskkill /f /im firefox.exe 
taskkill /f /im opera.exe 
goto done 

:eset_service_repair
set FILE_NAME=esr.exe
set FIRST_LINK=https://www.dropbox.com/s/2d9vnou8l6q0wis/ServicesRepair.exe?dl=0
set LAUNCH_CMD=%VSCAN%\%FILE_NAME%
goto download_file 

:check_instlled_apps
if exist check_apps.vbs (
cscript //nologo check_apps.vbs
) else (
echo File Missing: check_apps.vbs
echo File Missing: check_apps.vbs >> %LOG_FILE% 
)
goto done  

:norton_removal_tool 
set FILE_NAME=nrt.exe
set FIRST_LINK=ftp://ftp.symantec.com/public/english_us_canada/removal_tools/Norton_Removal_Tool.exe
set SECOND_LINK=https://www.dropbox.com/s/fca95h49l7id60z/Norton_Removal_Tool.exe?dl=0
set LAUNCH_CMD=%VSCAN%\%FILE_NAME%
goto download_file 

:mcafee_removal_tool 
set FILE_NAME=mcpr.exe 
set FIRST_LINK=http://download.mcafee.com/molbin/iss-loc/SupportTools/MCPR/MCPR.exe
set SECOND_LINK=https://www.dropbox.com/s/elvtqog9uwgyuhk/MCPR.exe?dl=0
set LAUNCH_CMD=%VSCAN%\%FILE_NAME%
goto download_file 

:avast_removal_tool 
set FILE_NAME=art.exe 
set FIRST_LINK=http://files.avast.com/iavs9x/avastclear.exe
set SECOND_LINK=https://www.dropbox.com/s/bqts2gdc0307o6q/avastclear.exe?dl=0
set LAUNCH_CMD=%VSCAN%\%FILE_NAME%
goto download_file 

:webroot_removal_tool 
set FILE_NAME=WRUpgradeTool.exe 
set FIRST_LINK=http://download.webroot.com/WRUpgradeTool.exe
set SECOND_LINK=https://www.dropbox.com/s/m1bzck3uvx29fy1/WRUpgradeTool.exe?dl=0
set LAUNCH_CMD=%VSCAN%\%FILE_NAME%
goto download_file 

:kaspersky_removal_tool
set FILE_NAME=krt.exe
set FIRST_LINK=http://devbuilds.kaspersky-labs.com/devbuilds/KVRT/latest/full/KVRT.exe
set SECOND_LINK=https://www.dropbox.com/s/630tm5u7sg9m7k6/KVRT.exe?dl=0
set LAUNCH_CMD=%VSCAN%\%FILE_NAME%
goto download_file

:java_removal_Tool
set UNZIP_FIRST=YES
set FILE_NAME=javara.zip
set FIRST_LINK=https://singularlabs.com/download/10306/
set SECOND_LINK=https://www.dropbox.com/s/5j0fb6rp6s9plg8/JavaRa-2.6.1.zip?dl=0
goto download_file

:remove_tools
if exist %LOG_FILE% (
echo Copying %LOG_FILE% to %SystemDrive%\%LOG_FILE_NAME%
copy %LOG_FILE% %SystemDrive%\%LOG_FILE_NAME%
)
cd\
echo Removing tool kit 
echo Removing tool kit >> %LOG_FILE% 
date /t >> %LOG_FILE% 
time /t >> %LOG_FILE%
echo Removing tool kit at: time /t >> %LOG_FILE%
rmdir /q /s %VSCAN%
goto done

rem Does not work on XP....
:clear_events
echo Clearing events
for /F "tokens=*" %%G in ('wevtutil.exe el') DO (
echo Clearing %%G
wevtutil.exe cl %%G
)
goto done 

:network_reset
echo Reseting network stack, winsock, firewall and winhttp 
netsh winsock reset >> %LOG_FILE%
netsh int ip reset >> %LOG_FILE%
netsh advfirewall reset >> %LOG_FILE%
netsh winhttp reset proxy >> %LOG_FILE% 
goto done 

:java 
echo Downloading java
set FILE_NAME=java.exe 
set FIRST_LINK=http://javadl.sun.com/webapps/download/AutoDL?BundleId=109706
if %IS64%==YES set FIRST_LINK=http://javadl.sun.com/webapps/download/AutoDL?BundleId=109708
set LAUNCH_CMD=%FILE_NAME%
goto download_file 

:safe_mode_installs
echo Starting safe mode installs 
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Network\MSIServer" /VE /T REG_SZ /F /D "Service"
net start msiserver
goto done 

:tfc_new
set FILE_NAME=tfc_new.exe 
set FIRST_LINK=https://www.dropbox.com/s/05vlzfbj638nxxf/tfcnew.exe?dl=0
set LAUNCH_CMD=%VSCAN%\tfc_new.exe
goto download_file 

:tfc_old
set FILE_NAME=tfc_old.exe 
set FIRST_LINK=https://www.dropbox.com/s/oqqu7ol276bux0i/tfcold.exe?dl=0
set LAUNCH_CMD=%VSCAN%\tfc_old.exe
goto download_file 


:process_explorer
set FILE_NAME=procexp.exe
set FIRST_LINK=https://live.sysinternals.com/procexp.exe
set LAUNCH_CMD=%VSCAN%\%FILE_NAME%
goto download_file 

:sigcheck 
set UNZIP_FIRST=YES
set FILE_NAME=sigcheck.zip
set FIRST_LINK=https://download.sysinternals.com/files/Sigcheck.zip
goto download_file 

:geek
set UNZIP_FIRST=YES
set FILE_NAME=geek.zip
set FIRST_LINK=http://www.geekuninstaller.com/geek.zip
set LAUNCH_CMD=%VSCAN%\geek.exe 
goto download_file

:handle 
set UNZIP_FIRST=YES
set FILE_NAME=handle.zip
set FIRST_LINK=https://download.sysinternals.com/files/Handle.zip
goto download_file 

:listdlls
set UNZIP_FIRST=YES
set FILE_NAME=listdll.zip
set FIRST_LINK=https://download.sysinternals.com/files/ListDlls.zip
goto download_file 

:adwcleaner
set FILE_NAME=adwcleaner.exe
set FIRST_LINK=https://www.dropbox.com/s/i6g8ckd1ffi1xk6/adwcleaner_5.013.exe?dl=0
set LAUNCH_CMD=%VSCAN%\%FILE_NAME%
goto download_file

:zhp
set FILE_NAME=zhp.exe
set FIRST_LINK=https://www.dropbox.com/s/cu9l458lseoc6g1/ZHPCleaner.exe?dl=0
set LAUNCH_CMD=%VSCAN%\%FILE_NAME%
goto download_file 

:roguekiller
set FILE_NAME=rogue.exe
set FIRST_LINK=https://www.dropbox.com/s/zhtc7gmhaa39hx1/RogueKiller.exe?dl=0
if %IS64%==YES set FIRST_LINK=https://www.dropbox.com/s/zk5kiigyema5mco/RogueKillerX64.exe?dl=0
set LAUNCH_CMD=%VSCAN%\%FILE_NAME%
goto download_file

:autoruns
set FILE_NAME=autoruns.exe
set FIRST_LINK=https://live.sysinternals.com/autoruns.exe
set LAUNCH_CMD=%VSCAN%\%FILE_NAME%
goto download_file 


:cleanar
set FILE_NAME=cleanautoruns.exe
set FIRST_LINK=http://media.kaspersky.com/utilities/VirusUtilities/RU/cleanautorun.exe
set LAUNCH_CMD=%VSCAN%\%FILE_NAME%
goto download_file


:tds
set FILE_NAME=tds.exe
set FIRST_LINK=http://media.kaspersky.com/utilities/VirusUtilities/EN/tdsskiller.exe
set LAUNCH_CMD=%VSCAN%\%FILE_NAME% 
set LAUNCH_ARGS=-sigcheck 
goto download_file


:hitman
set FILE_NAME=hitman.exe
if %IS64%==YES (
set FIRST_LINK=http://dl.surfright.nl/HitmanPro_x64.exe
) else (
set FIRST_LINK=http://dl.surfright.nl/HitmanPro.exe
)
set INSTALL_CMD=NONE
set LAUNCH_CMD=%VSCAN%\%FILE_NAME%
set LAUNCH_ARGS=/noinstall /scan
goto download_file


:cc
set UNZIP_FIRST=YES
set FILE_NAME=cc.zip
set FIRST_LINK=https://www.piriform.com/ccleaner/download/portable/downloadfile
set SECOND_LINK=https://www.dropbox.com/s/jacvuuh2mbnq591/ccsetup510.zip?dl=0
set INSTALL_CMD=NONE
if %IS64%==YES (
set LAUNCH_CMD=%VSCAN%\CCleaner64.exe
) else (
set LAUNCH_CMD=%VSCAN%\CCleaner.exe
)
goto download_file

:jrt
set FILE_NAME=jrt.exe
set FIRST_LINK=http://downloads.malwarebytes.org/file/jrt
set SECOND_LINK=https://www.dropbox.com/s/0x6d203gbq66bsw/JRT.exe?dl=0
set LAUNCH_CMD=%VSCAN%\%FILE_NAME%
goto download_file


:mbam
set FILE_NAME=mbam_setup.exe
set FIRST_LINK=https://downloads.malwarebytes.org/file/mbam_current/
set SECOND_LINK=https://www.dropbox.com/s/oo8mtg6y7jrb2s8/mbam-setup-2.1.8.1057.exe?dl=0
set INSTALL_CMD=%FILE_NAME%
set INSTALL_ARGS=/silent 
set LAUNCH_CMD="%PF%\Malwarebytes Anti-Malware\mbam.exe"
goto download_file

:mbamun
echo Attempting to remove MBAM
set LAUNCH_CMD="%PF%\Malwarebytes Anti-Malware\unins000.exe"
goto launch_tool
)

:mbar
set FILE_NAME=mbar_setup.exe
set FIRST_LINK=https://downloads.malwarebytes.org/file/mbar/
set SECOND_LINK=https://www.dropbox.com/s/ep0cuo6b6irrryz/mbar-1.09.3.1001.exe?dl=0
set LAUNCH_CMD=%VSCAN%\%FILE_NAME%
goto download_file

rem Removal commands
:mbarun
if exist "%USERPROFILE%\Desktop\mbar" (
echo Removing "%USERPROFILE%\Desktop\mbar"
rmdir /s /q "%USERPROFILE%\Desktop\mbar"
) else (
echo MBAR not found.
)
goto done

rem Downloads the file using wget
:download_file
Rem remove previous file?
if %DELETE_PREVIOUS_DL%==YES (
echo Removing %VSCAN%\%FILE_NAME%
del /f /q %VSCAN%\%FILE_NAME%
)

echo Downloading from: %FIRST_LINK%
echo Downloading from: %FIRST_LINK% >> %LOG_FILE%
%VSCAN%\wget.exe --max-redirect 5 -t 1 -c -O %VSCAN%\%FILE_NAME% %FIRST_LINK% --no-check-certificate
if %ERRORLEVEL%==0 (
	echo %FILE_NAME% download completed
	echo %FILE_NAME% download completed >> %LOG_FILE%
goto done_downloading
)
if %ERRORLEVEL%==1 (
	echo %FILE_NAME% file already downloaded
	echo %FILE_NAME% file already downloaded >> %LOG_FILE%
goto done_downloading
)
if %ERRORLEVEL% > 1 ( 
	echo Error downloading %FILE_NAME% >> %LOG_FILE% 
	echo Error downloading %FILE_NAME%
	if not %SECOND_LINK%==NONE (
		echo Attemping to download from backup link: %SECOND_LINK%
		echo Attemping to download from backup link: %SECOND_LINK% >> %LOG_FILE%
		%VSCAN%\wget.exe -t 1 -c -O %VSCAN%\%FILE_NAME% %SECOND_LINK% --no-check-certificate 
	) else (
goto done_downloading
)

if %ERRORLEVEL%= > 1 (
echo Backup link has failed
echo Backup link has failed >> %LOG_FILE%
goto error
) else (
echo Alternate download completed.
goto done_downloading
)

:done_downloading
if not exist %VSCAN%\%FILE_NAME% (
echo Downloaded file not found: %VSCAN%\%FILE_NAME% >> %LOG_FILE%
echo Downloaded file not found: %VSCAN%\%FILE_NAME%
goto error
)
if %UNZIP_FIRST%==YES (
echo Extracting archive.
%VSCAN%\7za x -o%VSCAN% -y %VSCAN%\%FILE_NAME% 
)

:install_cmd
if not %INSTALL_CMD%==NONE (
rem Run the install command 
start "Installing %LAUNCH%_%CMD%" /wait %VSCAN%\%INSTALL_CMD% %INSTALL_ARGS%
echo Install %INSTALL_CMD% completed. 
) 

:launch_tool
if %LAUNCH_CMD%==NONE (
  echo Download and uncompress only.
  echo Download and uncompress only. >> %LOG_FILE% 
) else if not exist %LAUNCH_CMD% (
echo Launch command not found: %LAUNCH_CMD% 
echo Launch command not found: %LAUNCH_CMD% >> %LOG_FILE%
) else (
echo Running file: %LAUNCH_CMD% %LAUNCH_ARGS% 
echo Running file: %LAUNCH_CMD% %LAUNCH_ARGS% >> %LOG_FILE% 
start "Starting" %LAUNCH_CMD% %LAUNCH_ARGS%
)
goto done

rem End of Script
:error
echo An error has ocoured. %ERROR_MSG% >> %LOG_FILE%
echo An error has occured. %ERROR_MSG% 

:done
EndLocal