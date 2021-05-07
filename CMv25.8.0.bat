
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::created by Clayton Stephenson
::for the purpose of monitoring any number of machines
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::SETTINGS LOCATION 1
@echo off
Setlocal EnableDelayedExpansion
title Constant Multi-Ping
::::::::::::::::
set pingflag=off
set dhcpflag=off
set timeout=1000
::::::::::::::::
set count=10
set choice=6
set /a num=0
set modeflag=off
set addingamachine=no
set temptimeout=!timeout!
set echoonoff=echo.
set multistoreflag=off
set machinearguments=
set temptimeout=!timeout!

	if [!pingflag!]==[on] set whichpingtoshow=:showtime
	if [!pingflag!]==[off] set whichpingtoshow=:showon
	if [!dhcpflag!]==[off] set checkdhcp=
	if [!dhcpflag!]==[on] set checkdhcp=call :checkdhcp
	
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::MAIN MENU
:menu
title Constant Multi-Ping
set isthisastorenum=0
set /a num=0
set allarguments=
set snum=
color 7
set count=20
set choice=7
set addingamachine=no
if not [%*]==[] (
	set allarguments=%*
	goto skipmenu
)
cls
echo.
echo Store Numbers or Machines
echo.
set /p allarguments=:
:skipmenu
	set tovalidate=!allarguments!
	call :validation
	call :distributearguments
	set allarguments=!leftoverarguments!
	if [!isthisastore!]==[yes] (
		call :storenumbermode
	)
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::SETTINGS LOCATION 2
cls
call :setdisplaylist

	:::::::::::::::::::::::
::	call :showtable
:addsubtractmachinegoto1
	echo press capital "T" to show the table
	echo.
	call :showallarguments
	:::::::::::::::::::::::












:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::MAIN LOOP
:mainloop
	set /a mlnum=0
	for /l %%z in (1,0,10) do (
		!echoonoff!
		if [!echoonoff!]==[] set echoonoff=echo.
		for %%a in (!allarguments!) do (
			set currentmachine=%%a
			for /f "tokens=2,6,7 delims=:=<> " %%g in ('ping /n 1 /l 10 /w !timeout! %%a^|find /i "re"') do (
				if [%%h]==[unreachable.] call :showtimeu
				if [%%h]==[time] set online=%%i & call !whichpingtoshow!
				if [%%g]==[timed] call :showtimet
				if [%%g]==[transit.] call :showtimev
			)
		)
		:ppgoto1
		!checkdhcp!
		set /a mlnum+=1
		call :variablechange
		if !mlnum! GTR 49 (
			echo.
			call :showallarguments
			set /a mlnum=0
		)
	)
pause
exit
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::SUBROUTINES

















::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:switchshowontime
	if [!dhcpflag!]==[on] (echo|set /p word=Turn off DHCP first & goto :EOF)
	if [!pingflag!]==[off] (
		set pingflag=on
		set whichpingtoshow=:showtime
		set temptimout=!timeout!
		set timeout=5000
		echo|set /p word=ping times ON
		goto :EOF
	)
	if [!pingflag!]==[on] (
		set pingflag=off
		set whichpingtoshow=:showon
		set timeout=!temptimeout!
		echo|set /p word=ping times OFF
		goto :EOF
	)
goto :EOF
:showon
	:::::::::::::::::::::::
	echo|set /p online=on       
	:::::::::::::::::::::::
goto :EOF
:showtime
	set online=!online!          
	set online=!online:~,9!
	echo|set /p word=!online!
goto :EOF
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:showtimet
	:::::::::::::::::::::::
	for /f "tokens=1,2,3 delims=:." %%t in ("!time!") do (
		set time1=_%%t:%%u      
		echo|set /p time2=!time1:~,9!
	)
	:::::::::::::::::::::::
goto :EOF
:showtimeu
	:::::::::::::::::::::::
	for /f "tokens=1,2,3 delims=:." %%t in ("!time!") do (
		set time1=_%%t:%%u      
		echo|set /p time2=!time1:~,9!
	)
	:::::::::::::::::::::::
goto :EOF
:showtimev
	:::::::::::::::::::::::
		set word=TTL         
		echo|set /p TTL=!word:~,9!
	:::::::::::::::::::::::
goto :EOF
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:variablechange
	echo|set /p symbol=:
	choice /c 1234567890rqTwsadxtSgDcb /n /cs /t %count% /d %choice% >nul
		if "%errorlevel%"=="24" call :bumpbars
		if "%errorlevel%"=="23" call :cuplabelers
		if "%errorlevel%"=="22" call :dttimer
		if "%errorlevel%"=="21" call :showgateway
		if "%errorlevel%"=="20" call :switchshowontime
		if "%errorlevel%"=="19" goto pingtimeout
		if "%errorlevel%"=="18" call :xop
		if "%errorlevel%"=="17" call :dhcponoff
		if "%errorlevel%"=="16" call :addmachine
		if "%errorlevel%"=="15" call :subtractmachine
		if "%errorlevel%"=="14" call :modetoggle
		if "%errorlevel%"=="13" echo.& call :showtable
		if "%errorlevel%"=="12" set count=3&set choice=3&goto menu
		if "%errorlevel%"=="11" cls & call :showallarguments
		if "%errorlevel%"=="10" set count=300&if not [%choice%]==[0] echo|set /p ping=pausing for 5 minutes&set choice=0
		if "%errorlevel%"=="9" set count=60&if not [%choice%]==[9] echo|set /p ping=pausing for 1 minute&set choice=9
		if "%errorlevel%"=="8" set count=30&if not [%choice%]==[8] echo|set /p ping=pausing for 30 seconds&set choice=8
		if "%errorlevel%"=="7" set count=20&if not [%choice%]==[7] echo|set /p ping=pausing for 20 seconds&set choice=7
		if "%errorlevel%"=="6" set count=10&if not [%choice%]==[6] echo|set /p ping=pausing for 10 seconds&set choice=6
		if "%errorlevel%"=="5" set count=5&if not [%choice%]==[5] echo|set /p ping=pausing for 5 seconds&set choice=5
		if "%errorlevel%"=="4" set count=4&if not [%choice%]==[4] echo|set /p ping=pausing for 4 seconds&set choice=4
		if "%errorlevel%"=="3" set count=3&if not [%choice%]==[3] echo|set /p ping=pausing for 3 seconds&set choice=3
		if "%errorlevel%"=="2" set count=2&if not [%choice%]==[2] echo|set /p ping=pausing for 2 seconds&set choice=2
		if "%errorlevel%"=="1" set count=1&if not [%choice%]==[1] echo|set /p ping=pausing for 1 second&set choice=1

:endofselection
goto :EOF
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:storenumbermode
::::::::set variables
	set allarguments=
	set snum2=
	set snum3=
	set gateway=
::::::::finds gateway IP
	echo.
	echo ...if store number is not valid, this script will freeze here and eventually
	echo 	start over...
	set snum2=00000%snum%
	set snum3=%snum2:~-5%
	FoR %%c IN (cadg0 frdg0 dedg0 gbdg0 iedg0 usdg0 dg dg0) DO (
		FOR /F "tokens=2 skip=1 delims=: " %%N IN ('nslookup %%c%snum3% 2^>nul ^|FINDSTR "Address:"') DO (
			IF NOT "%%N"=="" set gateway=%%N
		)
	)
	if [!gateway!]==[] goto skip3
::::::::sets correct range of IPs
	if "%gateway:~-1%"=="1" (
		set gateway123=%gateway:~,-2%
		set iprange=1 30 31 32 33 34 35 40 41 42 10 11
		set dhcprange=126 125 124 123 122 121 120 119 118 117
		set bumpbars=50 51 52
		set cuplabelers=20 21 22 23
		set xop=25 55
		set dttimergateway=!gateway123!.87
	) else (
		set gateway123=%gateway:~,-4%
		set iprange=129 158 159 160 161 162 163 164 168 169 170 138 139
		set dhcprange=254 253 252 251 250 249 248 247 246 245
		set bumpbars=178 179 180
		set cuplabelers=148 149 150 151
		set xop=153 183
		set dttimergateway=!gateway123!.215
	)
::::::::checks range of IPs for existing machines
	for %%a in (%iprange%) do (
		for /f "tokens=2 delims=:. " %%b in ('nslookup %gateway123%.%%a^|find /i "name:"') do (
			if not "%%b"==[] set allarguments=!allarguments! %%b
		)
	)2>nul
	:skip3
	if [!allarguments!]==[] goto menu
::::::::SETTINGS
	title %snum% Constant Multi-Ping Tool
goto :EOF
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:showtable
	:::::::::::::::::::::::
	echo.
	echo ----------O----------
	echo Enter an option when you see ":"
	echo Case sensitive
	echo.
	echo pause for:
	echo 1 = 1 second 
	echo 2 = 2 seconds
	echo 3 = 3 seconds
	echo 4 = 4 seconds
	echo 5 = 5 seconds
	echo 6 = 10 seconds
	echo 7 = 20 seconds
	echo 8 = 30 seconds
	echo 9 = 1 minute
	echo 0 = 5 minutes
	echo.
	echo other features:
	echo a = Add machine (can add multiple stores / machines)
	echo b = add Bump bars (3)
	echo c = add Cup labelers (4)
	echo d = DHCP check on/off
	echo D = DT Timer (opens in chrome or IE if not available)
	echo g = show Gateway
	echo q = Quit and start over
	echo r = Refresh screen
	echo s = Subtract machine (can subtract multiple)
	echo S = Show ping times (toggle view)
	echo t = change ping Timeouts
	echo T = show Table again
	echo w = Wide screen
	echo x = add Xop devices (2)
	echo ----------O----------
	:::::::::::::::::::::::

::	all available:
::		bcehijklmnopuvyz
::		ABCEFGHIJKLMNOPQRSUVWXYZ
::	left hand:
::		bcehvz
::		ABCEFGHQRVWXZ
::	right hand:
::		bhijklmnopuy
::		BGHIJKLMNOPUY

goto :EOF
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:setdisplaylist
	set tnum=0
	set listarguments1=
	set listarguments2=
	set choices=
	for %%a in (!allarguments!) do (
		set /a iseven=tnum%%2
		set currentmachine1=%%a                  
		if [!isthisastore!]==[yes] (
			if [!tnum!]==[0] (
				set listarguments1=!listarguments1!^<g^> !currentmachine1:~0,14!
				set choices=!choices!g
			)
			if !tnum! GTR 0 (
				if [!iseven!]==[0] (
					set listarguments1=!listarguments1!^<!tnum!^> !currentmachine1:~0,14!
				) else (
					set listarguments2=!listarguments2!^<!tnum!^> !currentmachine1:~0,14!
				)
				set choices=!choices!!tnum!
			)
		)
		if [!isthisastore!]==[no] (
			set /a ttnum=tnum+1
			if [!iseven!]==[0] (
				set listarguments1=!listarguments1!^<!ttnum!^> !currentmachine1:~0,14!
			) else (
				set listarguments2=!listarguments2!^<!ttnum!^> !currentmachine1:~0,14!
			)
			set choices=!choices!!ttnum!
		)
		set /a tnum+=1
	)
	set numofmachines=!tnum!
goto :EOF
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:modetoggle
	if [!modeflag!]==[off] (
		set modeflag=on
		mode 200,999
		call :showtable
		call :showallarguments
		set mlnum=
		goto :EOF
	)
	if [!modeflag!]==[on] (
		set modeflag=off
		mode 80,300
		call :showtable
		call :showallarguments
		set mlnum=
		goto :EOF
	)
goto :EOF
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:subtractmachine
	set /p subtract=subtract: 
	set tempallarguments=!allarguments!
	set tnum=0
	if [!isthisastore!]==[no] (
		for %%a in (!allarguments!) do (
			set /a tnum+=1
			set argument!tnum!=%%a
		)
		for %%a in (!subtract!) do (
			for %%b in (!allarguments!) do (
				::echo does !argument%%a! = %%b
				if [!argument%%a!]==[%%b] (
					::echo we have a match: !argument%%a!
					set tempallarguments=!tempallarguments:%%b=!
				)
			)
		)
	)
	if [!isthisastore!]==[yes] (
		for %%a in (!allarguments!) do (
			if [!tnum!]==[0] (
				set argumentg=%%a
			)
			if not [!tnum!]==[0] (
				set argument!tnum!=%%a
			)
			set /a tnum+=1
		)
		for %%a in (!subtract!) do (
			for %%b in (!allarguments!) do (
				::echo does !argument%%a! = %%b
				if [!argument%%a!]==[%%b] (
					::echo we have a match: !argument%%a!
					set tempallarguments=!tempallarguments:%%b=!
					if [!argument%%a!]==[!argumentg!] set isthisastore=no
				)
			)
		)
	)
	set allarguments=!tempallarguments!
	call :setdisplaylist
	if !numofmachines! EQU 0 goto menu
	call :showallarguments
goto mainloop
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:addmachine
::::::::enter machine
	set newarguments=
	set /p newarguments=Add: 
	set tovalidate=!newarguments!
	set addingamachine=yes
	call :validation
	if [!machinearguments!]==[] (
		if not [!storearguments!]==[] (
			for %%a in (!storearguments!) do start cmd /k call "%~f0" %%a
		)
		set echoonoff=
		goto mainloop
	)
	set /a num=0
	for %%a in (!allarguments!) do (
		set /a num+=1
	)
::::::::create choice options 1 through blank
	set numbers=
::::::::place machine^(s^) after blank
	echo.
	set mychoice=
	set errorlevel=
	choice /c 0!choices! /n /m "Place after^[0!choices!]:"
		set mychoice=%errorlevel%
	
::::::::place before the first machine if user types 0
	set /a num=1
	set newallarguments=
	if [%mychoice%]==[1] set newallarguments=!machinearguments!
	if [%mychoice%]==[1] set mychoice=0
::::::::place after selection
:xopgoto1
	for %%a in (!allarguments!) do (
		set /a num+=1
		if not [!num!]==[%mychoice%] set newallarguments=!newallarguments! %%a
		if [!num!]==[%mychoice%] set newallarguments=!newallarguments! %%a !machinearguments!
	)
::::::::set new all arguments
	set allarguments=!newallarguments!
::::::::set display list
	call :setdisplaylist
	echo.
	echo !listarguments1!
	echo _        !listarguments2!
	set mlnum=0
goto mainloop
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:dhcponoff
	if [!whichpingtoshow!]==[:showtime] (
		echo|set /p word=Toggle view first
		goto :EOF
		)
	if [!DHCPflag!]==[off] (
		set dhcpflag=on
		set checkdhcp=call :checkdhcp
		echo|set /p echo=DHCP ON
		goto :EOF
	)
	if [!DHCPflag!]==[on] (
		set dhcpflag=off
		set checkdhcp=
		echo|set /p echo=DHCP OFF
		color 7
		goto :EOF
	)
goto :EOF
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:checkdhcp
	set tnum=0
	set colorflag=off
	for %%a in (!dhcprange!) do (
		for /f "tokens=6 delims=:=<> " %%g in ('ping /n 1 /w !timeout! !gateway123!.%%a^|find /i "reply"') do (
			if [%%g]==[time] (
				set /a tnum+=1
				if [!tnum!]==[1] echo|set /p word=DHCP: 
				echo|set /p word=!gateway123!.%%a 
				set colorflag=on
			)
		)
	)
	if [!colorflag!]==[on] color 47
	if [!colorflag!]==[off] color 7
goto :EOF
::Reply from 172.17.137.27: Destination host unreachable.
::Reply from 127.0.0.1: bytes=32 time<1ms TTL=128
::10.157.170.1
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:xop
	for %%a in (!xop!) do (
		set allarguments=!allarguments! %gateway123%.%%a
	)
	call :setdisplaylist
	echo.
	call :showallarguments
goto :EOF
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:pingtimeout
	set /p temptimeout=milliseconds:
	if !temptimeout! LSS 500 (
		echo.
		echo invalid option
		goto :EOF
	)
	if !temptimeout! GTR 5000 (
		echo.
		echo invalid option
		goto :EOF
	)
	set timeout=!temptimeout!
	set echoonoff=
goto :mainloop
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:showallarguments
	echo.
	echo !listarguments1!
	echo _        !listarguments2!
	echo.
	echo !time!
goto :EOF
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:validation
for %%a in (machine store) do (
	set validationtype=%%a
	set tempvalidated=
	set tempunvalidated=
	set unvalidated=
	set validated=
	set snum1=
	set snum2=
	set snum3=
	if [!validationtype!]==[machine] (
		for %%a in (!tovalidate!) do (
			if not [%%a]==[.] if not [%%a]==[1] if not [%%a]==[2] (
					(nslookup %%a|find /i "name" )>nul 2>&1 && set tempvalidated=!tempvalidated!%%a || set tempunvalidated=!tempunvalidated!%%a 
			)
		)
		set machinearguments=!tempvalidated!
		set tovalidate=!tempunvalidated!
	)
	if [!validationtype!]==[store] (
		for %%a in (!tovalidate!) do (
			set snum1=%%a
			set snum2=00000!snum1!
			set snum3=!snum2:~-5!
			FoR %%b IN (cadg0 frdg0 dedg0 gbdg0 iedg0 usdg0 dg dg0) do (
				(nslookup %%b!snum3! | find /i "name")>nul 2>&1 && set tempvalidated=!tempvalidated!!snum1! 
			)
		)
		set storearguments=!tempvalidated!
		if [!addingamachine!]==[no] (
			for /f "tokens=1" %%a in ("!storearguments!") do set snum=%%a
		)
		if [!addingamachine!]==[yes] (
			set addingamachine=no
		)
	)
)
goto :EOF
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:distributearguments
set leftoverarguments=
if not [!machinearguments!]==[] (
	if not [!storearguments!]==[] (
		for %%a in (!storearguments!) do (
			start cmd /k call "%~f0" %%a
		)
	)
	set leftoverarguments=!machinearguments!
	set isthisastore=no
)
if [!machinearguments!]==[] (
	if not [!storearguments!]==[] (
		for %%a in (!storearguments!) do (
			if not [%%a]==[!snum!] (
				start cmd /k call "%~f0" %%a
			)
		)
		set isthisastore=yes
		set /a isthisastorenum+=1
		if !isthisastorenum! GTR 1 (
			set isthisastore=no
		)
	)
	if [!storearguments!]==[] (
		goto menu
	)
)
::results are called "leftoverarguments"
goto :EOF
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:showgateway
	echo|set /p word=gateway: !gateway!
goto :EOF
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:dttimer
	if exist "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" (
		"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --incognito --disable-simplified-fullscreen-ui http:\\%dttimergateway%:1080
	)
	if not exist "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" (
		"C:\Program Files\Internet Explorer\iexplore.exe" -private http:\\%dttimergateway%:1080
	)
goto :EOF
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:cuplabelers
	for %%a in (!cuplabelers!) do (
		set allarguments=!allarguments! %gateway123%.%%a
	)
	call :setdisplaylist
	echo.
	call :showallarguments
goto :EOF
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:bumpbars
	for %%a in (!bumpbars!) do (
		set allarguments=!allarguments! %gateway123%.%%a
	)
	call :setdisplaylist
	echo.
	call :showallarguments
goto :EOF
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::






























