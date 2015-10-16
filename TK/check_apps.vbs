Const HKLM = &H80000002 'HKEY_LOCAL_MACHINE 
strComputer = "." 
strKey = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" 
strEntry1a = "DisplayName" 
strEntry1b = "QuietDisplayName" 
strEntry2 = "InstallDate" 
strEntry3 = "VersionMajor" 
strEntry4 = "VersionMinor" 
strEntry5 = "EstimatedSize" 
APP_FILENAME = "installed-apps.txt"

Set fso = CreateObject("Scripting.FileSystemObject")

If not fso.FileExists(APP_FILENAME) then 
    Wscript.Echo "No installed application data file found creating."
	
	Set objReg = GetObject("winmgmts://" & strComputer & "/root/default:StdRegProv") 
	objReg.EnumKey HKLM, strKey, arrSubkeys 
    Set objFile = fso.CreateTextFile(APP_FILENAME,True)
	For Each strSubkey In arrSubkeys 
		intRet1 = objReg.GetStringValue(HKLM, strKey & strSubkey, strEntry1a, strValue1) 
			If intRet1 <> 0 Then 
				objReg.GetStringValue HKLM, strKey & strSubkey, strEntry1b, strValue1 
			End If 
			If strValue1 <> "" Then 
			objReg.GetStringValue HKLM, strKey & strSubkey, strEntry2, strValue2 
			objFile.WriteLine(strValue1) 
			End If 
	Next
	objFile.Close 
	Wscript.Echo "Application data file created. Run again at end of session."
Else
' Generate list of applications removed 
    Wscript.Echo "Application data file found loading contents."
    Set objApps = CreateObject("System.Collections.ArrayList")
	Set objAppsInstalled = CreateObject("System.Collections.ArrayList")
	Set objAppsRemoved = CreateObject("System.Collections.ArrayList")
	Set objOriginalApps = CreateObject("System.Collections.ArrayList")
	Set objReg = GetObject("winmgmts://" & strComputer & "/root/default:StdRegProv") 
	objReg.EnumKey HKLM, strKey, arrSubkeys 
    Set objFile = fso.OpenTextFile(APP_FILENAME,1)
	'Load APP_FILENAME information into a dictionary
	Do Until objFile.AtEndOfStream
		objOriginalApps.Add objFile.Readline
	Loop
	objFile.Close 
	orig_app_count = objOriginalApps.Count 
	
	'Check currently installed apps 
	line = 0
	Set objReg = GetObject("winmgmts://" & strComputer & "/root/default:StdRegProv") 
	objReg.EnumKey HKLM, strKey, arrSubkeys 
	For Each strSubkey In arrSubkeys 
		intRet1 = objReg.GetStringValue(HKLM, strKey & strSubkey, strEntry1a, strValue1) 
			If intRet1 <> 0 Then 
				objReg.GetStringValue HKLM, strKey & strSubkey, strEntry1b, strValue1 
			End If 
			If strValue1 <> "" Then 
			line = line + 1 
			objReg.GetStringValue HKLM, strKey & strSubkey, strEntry2, line
			if strValue1 <> "" Then objApps.Add strValue1
			End If 
	Next

	found = false 
	Wscript.Echo "Checking for newly installed applications."
	For Each obj_cur in objApps
	   if Not objOriginalApps.Contains(obj_cur) Then 
        objAppsInstalled.Add(obj_cur)
	   End If 
	Next 
	
	Wscript.Echo "Checking for removed applications."
	For Each obj_cur in objApps 
		 objOriginalApps.Remove(obj_cur)
	Next 
	For Each obj_cur in objOriginalApps
		objAppsRemoved.Add(obj_cur)
	Next 

    Wscript.Echo "[Installed Applications]: " & Cstr(objAppsInstalled.Count)	
	For Each obj_cur in objAppsInstalled
		Wscript.Echo obj_cur
	Next 
	
	Wscript.Echo "[Removed Applications]: " & Cstr(objAppsRemoved.Count)
	For Each obj_cur in objAppsRemoved
	    Wscript.Echo obj_cur 
	Next 

		
End If 