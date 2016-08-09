#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;;;Important variables. 
IniRead, InstanceAmount, config.ini, Main, InstanceAmount
IniRead, MaxConnections, config.ini, Main, MaxConnections

instanceN = 1

;;;Load variables from config.ini
IniRead, STValue, config.ini, Instance%instanceN%, ST
IniRead, GMapskey, config.ini, Instance%instanceN%, GMapskey
IniRead, UseCoords, config.ini, Instance%instanceN%, UseCoords
IniRead, Location, config.ini, Instance%instanceN%, Location
IniRead, Lat, config.ini, Instance%instanceN%, Lat
IniRead, Long, config.ini, Instance%instanceN%, Long
IniRead, SDValue, config.ini, Instance%instanceN%, SD
IniRead, Usernamecolumn, config.ini, Instance%instanceN%, usernamecolumn
IniRead, Passwordcolumn, config.ini, Instance%instanceN%, passwordcolumn
IniRead, Accounts, config.ini, Instance%instanceN%, Accounts

ifNotExist, accounts.csv 
{
    MsgBox, You do not have an accounts.csv file in the operating directory!
    exitapp
}

MsgBox  These are your settings `n Instances = %InstanceAmount% `n ST = %StValue% `n GMapskey = %GMapskey% `n Location = %location% `n Lat = %lat% & Long = %Long% `n UseCoords = %UseCoords% `n SD = %SDValue% `n Username Column = %usernamecolumn% & password column = %passwordcolumn%



;Reads how many lines there are in the CSV file
Loop, read, accounts.csv
{
    last_line := A_LoopReadLine  ; When loop finishes, this will hold the last line.
    TotalLineNumber = %A_index%
}
    MsgBox, .bat will include %TotalLineNumber% accounts.


Loop, read, accounts.csv
{
LineNumber = %A_Index%
Loop, parse, A_LoopReadLine, CSV
   {
    FieldNumber = %A_Index%
    
        if (FieldNumber = usernamecolumn)
        {
        UserN%LineNumber% = %A_LoopField%    
        }
        else if (FieldNumber = passwordcolumn)
        {
        PassN%LineNumber% = %A_LoopField%
        }
        else
        {
        }
        
        
    }
}

;;This section is dedicated to writing out the .bat file used to run the server in the end.
FileDelete HoneySpots.bat ;Deletes any previous batch files in this programs directory.
;Writes out the initial server start to .bat
FileAppend,
(
taskkill /IM python.exe /F
`n Start "Server" /min python runserver.py
), HoneySpots.bat

loop, %InstanceAmount%
{
    
IfNotEqual, A_Index, 1
{
FileAppend,
(
`n
`nStart `"Moveable%A_Index%`" /min python runserver.py
), HoneySpots.bat
}
    
 InstanceN = %A_Index%

;;;Load variables from config.ini
IniRead, STValue, config.ini, Instance%instanceN%, ST
IniRead, GMapskey, config.ini, Instance%instanceN%, GMapskey
IniRead, UseCoords, config.ini, Instance%instanceN%, UseCoords
IniRead, Location, config.ini, Instance%instanceN%, Location
IniRead, Lat, config.ini, Instance%instanceN%, Lat
IniRead, Long, config.ini, Instance%instanceN%, Long
IniRead, SDValue, config.ini, Instance%instanceN%, SD
IniRead, Usernamecolumn, config.ini, Instance%instanceN%, usernamecolumn
IniRead, Passwordcolumn, config.ini, Instance%instanceN%, passwordcolumn
IniRead, Accounts, config.ini, Instance%instanceN%, Accounts   



 
	
IndexAcc%A_Index% = %Accounts% ;Saves the accounts value for this index

IfNotEqual, A_Index, 1
{
PrevInst := A_Index - 1
StartAcc%A_Index% := EndAcc%PrevInst%
EndAcc%A_Index% := StartAcc%A_Index% + IndexAcc%A_Index% - 1
}
else
{
	StartAcc%A_Index% = 1
	EndAcc%A_Index% := IndexAcc%A_Index%
}

Cherry := StartAcc%A_Index%
Balb := EndAcc%A_Index%
Runs := Balb - Cherry
    
    
    
    
    
    

;Writes out the required amount of "auths" to .bat
;;Will be modified later to become toggleable/improved
IfEqual, A_Index, 1
{
    Runs := Runs + 1
}
loop, %Runs% 
{
    FileAppend,
    (
    %A_Space%-a ptc
    ), HoneySpots.bat
}

;Writes out -u (username) to .bat
loop, %Runs% 
{
    
IfNotEqual, A_Index, 1
{
SetDex := Cherry + A_Index
}
else
{
	SetDex := Cherry
}   
    
    
    
    Username := UserN%SetDex%
    FileAppend,
    (
    %A_Space%-u %Username%
    ), HoneySpots.bat
}
;Writes out -p (passwords) to .bat
loop, %Runs% 
{
    
IfNotEqual, A_Index, 1
{
SetDex := Cherry + A_Index  
}
else
{
	SetDex := Cherry
}  
    Username := PassN%SetDex%
    FileAppend,
    (
    %A_Space%-p %Username%
    ), HoneySpots.bat
}

;Adds the ST value declared as variable into .bat
FileAppend,
(
%A_Space%-st %STValue%
), HoneySpots.bat

;Adds the google maps api key declared as variable into .bat
FileAppend,
(
%A_Space%-k %GMAPSkey%
), HoneySpots.bat

;Adds the location declared as variable into .bat
FileAppend,
(
%A_Space%-l `"%location%`"
), HoneySpots.bat

IfNotEqual, A_Index, 1
{
;Adds an -ns into .bat
FileAppend,
(
%A_Space%-ns
), HoneySpots.bat
}

;Adds the SD, DC, max connections argument declared as variable into .bat
FileAppend,
(
%A_Space%-sd %SDValue% -dc --db-max_connections %MaxConnections%
), HoneySpots.bat

;Adds a pause so you don't need special eyes to see bugs haha
FileAppend,
(
`n ping 127.0.0.1 -n 6 > nul
), HoneySpots.bat




}
;Adds a pause so you don't need special eyes to see bugs haha
FileAppend,
(
`npause
), HoneySpots.bat

return
ExitApp