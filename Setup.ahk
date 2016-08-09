#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

ifNotExist, accounts.csv 
{
    MsgBox, You do not have an accounts.csv file in the operating directory!
    exitapp
}
InputBox, Instances, As a number value, How many instances would you like to use?
if ErrorLevel = 1
{
	exitapp
}
InputBox, GMAPSkey, , Enter GMAPS key
if ErrorLevel = 1
{
	exitapp
}
InputBox, UserC, , Enter the number of the "username" column in your .csv file, , , , , , , ,2
if ErrorLevel = 1
{
	exitapp
}
InputBox, PassC, , Enter the number of the "password" column in your .csv file, , , , , , , ,3
if ErrorLevel = 1
{
	exitapp
}
;Reads how many lines there are in the CSV file
Loop, read, accounts.csv
{
    last_line := A_LoopReadLine  ; When loop finishes, this will hold the last line.
    TotalLineNumber = %A_index%
}
    MsgBox, %TotalLineNumber% accounts detected in .csv file.
	tampaccnum := totallinenumber - instances
	Availacc := tampaccnum + 1

StartAcc1 = 0

Loop, %Instances%
{
Startactemp = StartAcc%A_Index%	
UsedNum := TotalLineNumber - Startactemp
Int2d := A_Index - 1
Int2Go := Instances - Int2d

ToBeFloored := UsedNum / Int2Go
FlooredAcc := Floor(ToBeFloored)
MultidFloor := FlooredAcc * Int2Go
TestNum := TotalLineNumber - MultidFloor
	
IfEqual, A_Index, %Instances%
{
	RecVal := FlooredAcc + TestNum
}
else
{
	RecVal = %FlooredAcc%
}
	
InputBox, ST%A_Index%, ,ST for instance %A_Index%
if ErrorLevel = 1
{
	exitapp
}
InputBox, LOC%A_Index%, ,Location or Coords (lat`,long) for instance %A_Index%
if ErrorLevel = 1
{
	exitapp
}
InputBox, SD%A_Index%, ,SD for instance %A_Index%
if ErrorLevel = 1
{
	exitapp
}
IfNotEqual, A_index, 1
{
Lastind := A_index - 1
}
else
{
	lastind = 1
}

tempvalst := StartAcc%Lastind%
InputBox, Acc%A_Index%, ,
(
Enter the accounts that should be allocated to instance %A_Index%, you have allocated %tempvalst% / %TotalLineNumber%
)
if ErrorLevel = 1
{
	exitapp
}


IfNotEqual, A_Index, 1
{
PrevInst := A_Index - 1
StartAcc%A_Index% := StartAcc%PrevInst% + Acc%A_Index%
}
else
{
	StartAcc%A_Index% := Acc%A_Index%
}

testvaltemp := Acc%A_Index%

ifGreater, testvaltemp, %TotalLineNumber%
{
	msgbox, you have entered more accounts than your total available! Exiting app.
	exitapp
}

ifGreater, testvaltemp, %Availacc%
{
	msgbox, There are not enough accounts left for each instance!
	exitapp
}


}

FileDelete config.ini

	IniWrite, %Instances%, Config.ini, Main, InstanceAmount
	IniWrite, 500, Config.ini, Main, MaxConnections

Loop, %Instances%
{
	insttemp = Instance%A_Index%
	sttemp := ST%A_Index%
	loctemp := LOC%A_Index%
	sdtemp := SD%A_Index%
	acctemp := Acc%A_Index%
	IniWrite, %sttemp%, Config.ini, %insttemp%, ST
	IniWrite, %GMAPSkey%, Config.ini, %insttemp%, GMapskey
	IniWrite, %loctemp%, Config.ini, %insttemp%, Location
	IniWrite, %sdtemp%, Config.ini, %insttemp%, SD
	IniWrite, %UserC%, Config.ini, %insttemp%, usernamecolumn
	IniWrite, %PassC%, Config.ini, %insttemp%, passwordcolumn
	IniWrite, %acctemp%, Config.ini, %insttemp%, accounts
}
msgbox config.ini generated!
return