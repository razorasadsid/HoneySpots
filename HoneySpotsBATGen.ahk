#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;;;Important variables. 
IniRead, InstanceAmount, config.ini, Main, InstanceAmount

instanceN = 1

;;;Load variables from config.ini
IniRead, STValue, config.ini, Instance%instanceN%, ST
IniRead, GMapskey, config.ini, Instance%instanceN%, GMapskey
IniRead, UseCoords, config.ini, Instance%instanceN%, UseCoords
IniRead, Location, config.ini, Instance%instanceN%, Location
IniRead, Lat, config.ini, Instance%instanceN%, Lat
IniRead, Long, config.ini, Instance%instanceN%, Long
IniRead, SDValue, config.ini, Instance%instanceN%, SD



MsgBox  These are your settings `n Instances = %InstanceAmount% `n ST = %StValue% `n GMapskey = %GMapskey% `n Location = %location% `n Lat = %lat% & Long = %Long% `n UseCoords = %UseCoords% `n SD = %SDValue%



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
    
        if (FieldNumber = 1)
        {
        UserN%LineNumber% = %A_LoopField%    
        }
        else if (FieldNumber = 2)
        {
        PassN%LineNumber% = %A_LoopField%
        }
        else
        {
            MsgBox Your CSV file is not properly formatted!
            return
        }
        
        
    }
}


;;This section is dedicated to writing out the .bat file used to run the server in the end.
FileDelete HoneySpots.bat ;Deletes any previous batch files in this programs directory.

;Writes out the initial server start to .bat
FileAppend,
(
python runserver.py
), HoneySpots.bat

;Writes out the required amount of "auths" to .bat
;;Will be modified later to become toggleable/improved
loop, %TotalLineNumber% 
{
    FileAppend,
    (
    %A_Space%-a ptc
    ), HoneySpots.bat
}

;Writes out -u (username) to .bat
loop, %TotalLineNumber% 
{
    Username := UserN%A_Index%
    FileAppend,
    (
    %A_Space%-u %Username%
    ), HoneySpots.bat
}
;Writes out -p (passwords) to .bat
loop, %TotalLineNumber% 
{
    Username := PassN%A_Index%
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

if UseCoords = 1
{
;Adds the coords declared as variable into .bat
FileAppend,
(
%A_Space%-l `"%lat%,%long%`"
), HoneySpots.bat
}
else
{
;Adds the location declared as variable into .bat
FileAppend,
(
%A_Space%-l `"%location%`"
), HoneySpots.bat
}

;Adds the SD value & the DC argument declared as variable into .bat
FileAppend,
(
%A_Space%-sd %SDValue% -dc
), HoneySpots.bat

;Adds a pause so you don't need special eyes to see bugs haha
FileAppend,
(
`n pause
), HoneySpots.bat
return
ExitApp