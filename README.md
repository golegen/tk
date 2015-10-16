# tk
TK.BAT is a command line based tool kit for virus scanning computers.

TK.EXE is a self extracting executable that creates a tool kit directory in %SYSTEMDRIVE%\VSCAN typically
depending on the configuration of the environment variables in the tk.bat. The executable also launches a 
command line in the tool directory which is typically C:\VSCAN

IE
C:\VSCAN\TK HELP - To display the full list of commands

IE:
C:\VSCAN\TK cc - Would download the portable version of CCleaner to the computer and launch the correct executable
depending if the machine was a 32bit machine or a 64it machine.

I created this batch file as an easy way to deploy up to date tools to remote computers mostly for use through 
LogMeIn Rescue and Teamviewer.
