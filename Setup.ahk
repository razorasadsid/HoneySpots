#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

ifNotExist, accounts.csv 
{
    MsgBox, You do not have an accounts.csv file in the operating directory!
    exitapp
}


MsgBox, 4,, Would you like to have ST be same for all workers? (press Yes or No)
IfMsgBox Yes
    STglobal = 1
else
    STglobal = 0
MsgBox, 4,, Would you like to have SD be same for all workers? (press Yes or No)
IfMsgBox Yes
    SDglobal = 1
else
    SDglobal = 0
MsgBox, 4,, Would you like to have accounts be same for all workers? (press Yes or No)
IfMsgBox Yes
    accglobal = 1
else
    accglobal = 0
MsgBox, 4,, Read locations per worker from locations.csv? (press Yes or No)
IfMsgBox Yes
    locread = 1
else
    locread = 0
if locread = 1
{
	ifNotExist, locations.csv 
{
    MsgBox, You do not have an locations.csv file in the operating directory!
    exitapp
}
InputBox, usernamecolumn, Enter as whole number, enter the column in which your latitude value is stored, , , , , , , ,1
InputBox, passwordcolumn, Enter as whole number, enter the column in which your latitude value is stored, , , , , , , ,2
Loop, read, locations.csv
{
LineNumber = %A_Index%
Loop, parse, A_LoopReadLine, CSV
   {
    FieldNumber = %A_Index%
    
        if (FieldNumber = usernamecolumn)
        {
        Lat%LineNumber% = %A_LoopField%    
        }
        else if (FieldNumber = passwordcolumn)
        {
        Long%LineNumber% = %A_LoopField%
        }
        else
        {
        }
    }
	LOC%A_Index% := Lat%A_Index% . ", " . Long%A_Index%
	testvar22 := loc%A_Index%
}
Loop, read, locations.csv
{
    last_line := A_LoopReadLine  ; When loop finishes, this will hold the last line.
    totlocnum = %A_index%
}
    MsgBox, %totlocnum% locations detected in .csv file.
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

ifequal, locread, 1
{
}
else
{
	InputBox, LOC%A_Index%, ,Location or Coords (lat`,long) for instance %A_Index%
if ErrorLevel = 1
{
	exitapp
}
}

IfEqual, A_index, 1
{
	InputBox, ST%A_Index%, ,ST for instance %A_Index%
	if ErrorLevel = 1
		{
		exitapp
		}
}
else
{
	if STglobal = 1
	{
	
	}
	else
	{
		InputBox, ST%A_Index%, ,ST for instance %A_Index%
		if ErrorLevel = 1
			{
			exitapp
			}
	}
}

IfEqual, A_index, 1
{
	InputBox, SD%A_Index%, ,SD for instance %A_Index%
	if ErrorLevel = 1
		{
		exitapp
		}
}
else
{
	if SDglobal = 1
	{
	}
	else
	{
		InputBox, SD%A_Index%, ,SD for instance %A_Index%
		if ErrorLevel = 1
			{
			exitapp
			}
	}
}

IfEqual, A_Index, 1
{
	
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
else
{
	if accglobal = 1
	{
	}
	else
	{
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
}



}





FileDelete config.ini

	IniWrite, %Instances%, Config.ini, Main, InstanceAmount
	IniWrite, 500, Config.ini, Main, MaxConnections

Loop, %Instances%
{
	insttemp = Instance%A_Index%
	if STglobal = 1
	{
		Iniwrite, global, config.ini, Main, ST
		sttemp := ST1
	}
	else
	{
		Iniwrite, local, config.ini, Main, ST
		sttemp := ST%A_Index%
	}
	
	loctemp := LOC%A_Index%
	if SDglobal = 1
	{
		Iniwrite, global, config.ini, Main, SD
		sdtemp := SD1
	}
	else
	{
		Iniwrite, local, config.ini, Main, ST
		sdtemp := SD%A_Index%
	}
		if accglobal = 1
	{
		Iniwrite, global, config.ini, Main, accounts
		acctemp := Acc1
	}
	else
	{
		Iniwrite, local, config.ini, Main, ST
		acctemp := Acc%A_Index%
	}
	
	IniWrite, %sttemp%, Config.ini, %insttemp%, ST
	IniWrite, %GMAPSkey%, Config.ini, %insttemp%, GMapskey
	IniWrite, %loctemp%, Config.ini, %insttemp%, Location
	IniWrite, %sdtemp%, Config.ini, %insttemp%, SD
	IniWrite, %UserC%, Config.ini, %insttemp%, usernamecolumn
	IniWrite, %PassC%, Config.ini, %insttemp%, passwordcolumn
	IniWrite, %acctemp%, Config.ini, %insttemp%, accounts
}

	IniWrite, Start "Server" /min python runserver.py, Config.ini, Main, serverstartparam
	IniWrite, Start "Moveable" /min python runserver.py, Config.ini, Main, workerstartparam
	IniWrite, ping 127.0.0.1 -n 6 > nul, Config.ini, Main, endparam
	IniWrite, -dc --db-max_connections 500, Config.ini, Main, customparam

msgbox config.ini generated!
return