:: Created by:		Brad Arrowood
:: Created on:		2019.03.15
:: Last updated:    	2019.04.29
:: Script name:		IT_service_desk_masterkey_v1.bat
:: Description:		A command line batch script tool for helping an IT Service Desk technician to locally and remotely
::			work on computers on the company network and to be able to search Active Directory account info. This
::			script is a combination of what was once several individual scripts I'd made and wanted to make their
::			use more readily accessable to the rest of my team by creating 1 script that had all their features together.
::			The setup is based off helping stores with a 4-digit store number so parts of the code are set up for 
::			that format in various parts, but this can be edited as needed for others needing parts of it. I will
::			add, at the time of making this script I don't know if we'd been given admin rights on the network at this
::			point, but after making an updated version with more features using Powershell (another script I'll be
::			uploading) I know we did have admin rights. So depending on your network access rights parts of this may
::			or may not work.

:start
	CLS
	@ECHO off
	::set the device choice options and clear all variables each time the program runs from the start
	SET confirmOpt=
	SET defaultTitle=Device Master Key Script
	SET deviceName=
	SET deviceOpt=
	SET option1=Delete cache and temporary files
	SET option2=Reboot a device
	SET option3=Restart printer spooler and clear queue
	SET option4=Shutdown a device
	SET option5=Cash Wrap or Sales Floor PC
	SET option6=Back Office PC - Store Account
	SET option7=Back Office PC - Store Manager Account
	SET option8=Stockroom PC
	SET option9=Employee Account Info Check
	SET rebootCWPC=
	SET rebootDevice=
	SET rebootSFPC=
	SET ststmOpt= 
	SET string2=
	SET storenum=
	SET cnt_filesSTA_A=
	SET cnt_filesST_A=
	SET cnt_filesSTM_A=
	SET rootpathSTA_A=
	SET rootpathST_A=
	SET rootpathSTM_A=
	SET cwpc20choiceA=
	SET cwpc20resultA=
	SET cwpc20clearA=
	SET empPClist=
	SET empPCchoice=
	TITLE %defaultTitle%
	COLOR 0F
	MODE 90,25
	GOTO deviceChoice

	:deviceChoice
		ECHO.
		ECHO Choose from the following options:
		ECHO 1. %option1%
		ECHO 2. %option2%
		ECHO 3. %option3%
		ECHO 4. %option4%
		ECHO.
		ECHO 9. %option9%
		ECHO 0. Exit
		ECHO.
		SET /P deviceOpt=Enter the number associated with your choice: 
		
		:: code to take the users input and direct to verify the choice.
		:: if no answer, start script over
		IF "%deviceOpt%"=="" GOTO start
		:: if user inputs something less than 1, start script over
		IF %deviceOpt% LSS 0 GOTO start
		IF %deviceOpt% EQU 0 GOTO endChoice
		for %%? in (1) do IF /I "%deviceOpt%"=="%%?" GOTO deviceInput
		for %%? in (2) do IF /I "%deviceOpt%"=="%%?" GOTO deviceInput
		for %%? in (3) do IF /I "%deviceOpt%"=="%%?" GOTO deviceInput
		for %%? in (4) do IF /I "%deviceOpt%"=="%%?" GOTO deviceInput
		for %%? in (9) do IF /I "%deviceOpt%"=="%%?" GOTO empInfo
		IF %deviceOpt% GTR 4 GOTO start
		
		:: IF input is not one of the number options, they get an error message before the script starts over
		ECHO.
		ECHO Error in selection. Please input the number associated with what you want to do.
		PAUSE
		GOTO start

	:deviceInput
		ECHO.
		SET /p deviceName=Enter the computer name: 
		IF "%deviceName%"=="" GOTO start
		IF "%deviceName%"=="0" GOTO empPClist
		GOTO sortingA

	:sortingA
		IF %deviceOpt% EQU 1 GOTO StStmChoice
		IF %deviceOpt% EQU 2 GOTO confirmInfo
		IF %deviceOpt% EQU 3 GOTO confirmInfo
		IF %deviceOpt% EQU 4 GOTO confirmInfo

	:StStmChoice
		ECHO.
		ECHO.
		ECHO What type of device or account will this be for?
		ECHO 1. %option5%
		ECHO 2. %option6%
		ECHO 3. %option7%
		ECHO 4. %option8%
		ECHO.
		SET /P ststmOpt=Enter the number associated with your choice: 
		
		:: code to take the users input and direct to verify the choice.
		:: if no answer, start script over
		IF "%ststmOpt%"=="" GOTO start
		:: if user inputs something less than 1, start script over
		IF %ststmOpt% LSS 1 GOTO start
		for %%? in (1) do IF /I "%ststmOpt%"=="%%?" GOTO getStoreNum
		for %%? in (2) do IF /I "%ststmOpt%"=="%%?" GOTO getStoreNum
		for %%? in (3) do IF /I "%ststmOpt%"=="%%?" GOTO getStoreNum
		for %%? in (4) do IF /I "%ststmOpt%"=="%%?" GOTO getStoreNum
		IF %ststmOpt% GTR 4 GOTO start
		
		:: IF input is not one of the number options, they get an error message before the script starts over
		ECHO.
		ECHO Error in selection. Please input the number associated with what you want to do.
		PAUSE
		GOTO start
		
	:getStoreNum
		ECHO.
		SET /P storenum=Enter the 4-digit store number: 
		IF "%storenum%"=="" GOTO start
		GOTO confirmInfo
	
	:confirmInfo
		CLS
		ECHO.
		ECHO CONFIRMATION REQUIRED:
		ECHO.
		IF %deviceOpt% EQU 1 GOTO option1choices
		IF %deviceOpt% EQU 1 GOTO option1choices
		IF %deviceOpt% EQU 1 GOTO option1choices 
		IF %deviceOpt% EQU 1 GOTO option1choices
		GOTO otherchoices

		:option1choices
			IF %ststmOpt% EQU 1 ECHO You chose "%option1%" for %deviceName%.
			IF %ststmOpt% EQU 2 ECHO You chose "%option1%" for %deviceName% on the Store Account.
			IF %ststmOpt% EQU 3 ECHO You chose "%option1%" for %deviceName% on the Store Manager Account.
			IF %ststmOpt% EQU 4 ECHO You chose "%option1%" for %deviceName%.
			GOTO continueOn
		
		:otherchoices
			IF %deviceOpt% EQU 2 ECHO You chose "%option2%" for %deviceName%.
			IF %deviceOpt% EQU 3 ECHO You chose "%option3%" for %deviceName%.
			IF %deviceOpt% EQU 4 ECHO You chose "%option4%" for %deviceName%.
			GOTO continueOn
		
		:continueOn
		SET /P confirmOpt=Did you mean to select this option (y/n)? 
		
		IF "%confirmOpt%"=="" GOTO start
		IF "%confirmOpt%"=="0" GOTO start
		for %%? in (n) do IF /I "%confirmOpt%"=="%%?" goto start
		for %%? in (N) do IF /I "%confirmOpt%"=="%%?" goto start
		
		IF "%confirmOpt%"=="1" GOTO sortingB
		IF "%confirmOpt%"=="y" GOTO sortingB
		IF "%confirmOpt%"=="Y" GOTO sortingB
		ECHO Error in confirmation. Please confirm with "y" or "n" to verify your selection.
		PAUSE
		GOTO start		
	
	:sortingB
		IF %deviceOpt% EQU 1 GOTO option1sorting
		IF %deviceOpt% EQU 1 GOTO option1sorting
		IF %deviceOpt% EQU 1 GOTO option1sorting
		IF %deviceOpt% EQU 1 GOTO option1sorting
		GOTO othersorting
		
		:option1sorting
			IF %ststmOpt% EQU 1 GOTO cacheTmpCWPC
			IF %ststmOpt% EQU 2 GOTO cacheTmpBOPCST
			IF %ststmOpt% EQU 3 GOTO cacheTmpBOPCSTM
			IF %ststmOpt% EQU 4 GOTO cacheTmpSRPC
		
		:othersorting
			IF %deviceOpt% EQU 2 GOTO deviceReboot
			IF %deviceOpt% EQU 3 GOTO devicePtrSpooler
			IF %deviceOpt% EQU 4 GOTO deviceShutdown
		
	::######################################################################################################################################################
	::########## START OF THE REMOTE COMMANDS ##############################################################################################################
	::######################################################################################################################################################
	
	:cacheTmpCWPC
		TITLE %defaultTitle% - Clearing Cache
		CLS
		ECHO Clearing IE11 cache.....
		del /q /f /s "\\%deviceName%\c$\Users\STA%storenum%\AppData\Local\Microsoft\Windows\Caches\*"
		GOTO cwpcFileCount
	
		:cwpcFileCount
			ECHO.
			SET rootpathSTA_A="\\%deviceName%\c$\Users\STA%storenum%\AppData\local\temp\"
			SET cnt_filesSTA_A=0

			:: count all files in dir and subdirs
			for /f %%a in ('dir /s /B /a-d "%rootpathSTA_A%"') do set /A cnt_filesSTA_A+=1

			TITLE %defaultTitle% - Clearing %cnt_filesSTA_A% temporary files - PASS 1-of-2
			ECHO.
			ECHO Clearing temporary files (1/2).....
			del /q /f /s "\\%deviceName%\c$\Users\STA%storenum%\AppData\local\temp\*"	
			
			GOTO cwpcCLEARend
						
			:cwpcCLEARend
				ECHO.
				ECHO All cache and temporary files have been deleted from %deviceName%.
				IF "%cwpc20resultA%"=="1" ECHO All files in the 2.0 folder have been cleared as well.
				IF "%cwpc20resultA%"=="y" ECHO All files in the 2.0 folder have been cleared as well.
				IF "%cwpc20resultA%"=="Y" ECHO All files in the 2.0 folder have been cleared as well.
				ECHO.
			
				::since sometimes a reboot of the cwpc is needed, giving option to send reboot signal
				SET /P rebootCWPC=Would you like to reboot %deviceName% (y/n)? 
			
				IF "%rebootCWPC%"=="y" GOTO cwpcREBOOT
				IF "%rebootCWPC%"=="Y" GOTO cwpcREBOOT
				
				IF "%rebootCWPC%"=="n" GOTO start
				IF "%rebootCWPC%"=="N" GOTO start
				
				IF "%rebootCWPC%"=="1" GOTO cwpcREBOOT
				IF "%rebootCWPC%"=="0" GOTO start
				::something other than y/Y or n/N entered gives the following and goes back to start
				ECHO.
				ECHO Error in choice. Please confirm with "y" or "n" in your selection next time.
				ECHO Clearing values and restarting script instead.
				PAUSE
				GOTO start

			:cwpcREBOOT
				ECHO.
				shutdown /r /m "\\%deviceName%" /t 0
				ECHO Remote reboot signal sent to %deviceName%
				PAUSE
				GOTO start
		
	:cacheTmpBOPCST
		TITLE %defaultTitle% - Clearing Cache
		CLS
		ECHO Clearing IE11 cache.....
		del /q /f /s "\\%deviceName%\c$\Users\ST%storenum%\AppData\Local\Microsoft\Windows\Caches\*"
		GOTO bopcFileCountST

		:bopcFileCountST
			ECHO.
			SET rootpathST_A="\\%deviceName%\c$\Users\ST%storenum%\AppData\local\temp\"
			SET cnt_filesST_A=0

			:: count all files in dir and subdirs
			for /f %%a in ('dir /s /B /a-d "%rootpathST_A%"') do set /A cnt_filesST_A+=1

			::checks the file count of the primary and secondary temp file locations and only tries to delete files from them if their file count is greater than 0
			IF cnt_filesST_A GTR 0 (
				TITLE %defaultTitle% - Clearing %cnt_filesST_A% temporary files
				ECHO.
				ECHO Clearing temporary files.....
				del /q /f /s "\\%deviceName%\c$\Users\ST%storenum%\AppData\local\temp\*"	
			)

			ECHO.
			ECHO All cache and temporary files have been deleted from %deviceName% under the Store Account.
			PAUSE
			GOTO start
		
	:cacheTmpBOPCSTM
		TITLE %defaultTitle% - Clearing Cache
		CLS
		ECHO Clearing IE11 cache.....
		del /q /f /s "\\%deviceName%\c$\Users\STM%storenum%\AppData\Local\Microsoft\Windows\Caches\*"
		GOTO bopcFileCountSTM
			
		:bopcFileCountSTM
			ECHO.
			SET rootpathSTM_A="\\%deviceName%\c$\Users\STM%storenum%\AppData\local\temp\"
			SET cnt_filesSTM_A=0

			:: count all files in dir and subdirs
			for /f %%a in ('dir /s /B /a-d "%rootpathSTM_A%"') do set /A cnt_filesSTM_A+=1

			::checks the file count of the primary and secondary temp file locations and only tries to delete files from them if their file count is greater than 0
			IF cnt_filesSTM_A GTR 0 (
				TITLE %defaultTitle% - Clearing %cnt_filesSTM_A% temporary files
				ECHO.
				ECHO Clearing temporary files.....
				del /q /f /s "\\%deviceName%\c$\Users\STM%storenum%\AppData\local\temp\*"	
			)

			ECHO.
			ECHO All cache and temporary files have been deleted from %deviceName% under the Store Manager Account.
			PAUSE
			GOTO start
			
	:cacheTmpSRPC	
		TITLE %defaultTitle% - Clearing Cache
			CLS
			ECHO Clearing IE11 cache.....
			::STA
			del /q /f /s "\\%deviceName%\c$\Users\STA%storenum%\AppData\Local\Microsoft\Windows\Caches\*"
			::ST
			del /q /f /s "\\%deviceName%\c$\Users\ST%storenum%\AppData\Local\Microsoft\Windows\Caches\*"
			::STM
			del /q /f /s "\\%deviceName%\c$\Users\STM%storenum%\AppData\Local\Microsoft\Windows\Caches\*"
			GOTO srpcFileCount
		
		:srpcFileCount
			ECHO.
			::STA
			SET rootpathSTA_A="\\%deviceName%\c$\Users\STA%storenum%\AppData\local\temp\"
			SET cnt_filesSTA_A=0
			::ST
			SET rootpathST_A="\\%deviceName%\c$\Users\ST%storenum%\AppData\local\temp\"
			SET cnt_filesST_A=0
			::STM
			SET rootpathSTM_A="\\%deviceName%\c$\Users\STM%storenum%\AppData\local\temp\"
			SET cnt_filesSTM_A=0
			
			:: count all files in dir and subdirs
			::STA
			for /f %%a in ('dir /s /B /a-d "%rootpathSTA_A%"') do set /A cnt_filesSTA_A+=1
			::ST
			for /f %%a in ('dir /s /B /a-d "%rootpathST_A%"') do set /A cnt_filesST_A+=1
			::STM
			for /f %%a in ('dir /s /B /a-d "%rootpathSTM_A%"') do set /A cnt_filesSTM_A+=1

			::checks the file count of the primary and secondary temp file locations and only tries to delete files from them if their file count is greater than 0
			::STA	###########################################################################################
			IF cnt_filesSTA_A GTR 0 (
				TITLE %defaultTitle% - Clearing %cnt_filesSTA_A% temporary files - STA account
				ECHO.
				ECHO Clearing temporary files.....
				del /q /f /s "\\%deviceName%\c$\Users\STA%storenum%\AppData\local\temp\*"	
			)

			::ST	###########################################################################################
			IF cnt_filesST_A GTR 0 (
				TITLE %defaultTitle% - Clearing %cnt_filesST_A% temporary files - ST account
				ECHO.
				ECHO Clearing temporary files.....
				del /q /f /s "\\%deviceName%\c$\Users\ST%storenum%\AppData\local\temp\*"	
			)

			::STM	###########################################################################################
			IF cnt_filesSTM_A GTR 0 (
				TITLE %defaultTitle% - Clearing %cnt_filesSTM_A% temporary files - STM account
				ECHO.
				ECHO Clearing temporary files.....
				del /q /f /s "\\%deviceName%\c$\Users\STM%storenum%\AppData\local\temp\*"	
			)

			ECHO.
			ECHO All cache and temporary files have been deleted from %deviceName%.
			PAUSE
			GOTO srpcREBOOT
			
			
			::since sometimes a reboot is needed, giving option to send reboot signal
			SET /P rebootSFPC=Would you like to reboot %deviceName% (y/n)? 
		
			IF "%rebootSFPC%"=="y" GOTO srpcREBOOT
			IF "%rebootSFPC%"=="Y" GOTO srpcREBOOT
			
			IF "%rebootSFPC%"=="n" GOTO start
			IF "%rebootSFPC%"=="N" GOTO start
			
			IF "%rebootSFPC%"=="1" GOTO srpcREBOOT
			IF "%rebootSFPC%"=="0" GOTO start
			::something other than y/Y or n/N entered gives the following and goes back to start
			ECHO.
			ECHO Error in choice. Please confirm with "y" or "n" in your selection next time.
			ECHO Clearing values and restarting script instead.
			PAUSE
			GOTO start
			
			:srpcREBOOT
					ECHO.
					shutdown /r /m "\\%deviceName%" /t 0
					ECHO Remote reboot signal sent to %deviceName%
					PAUSE
					GOTO start
	
	:deviceReboot
		CLS
		TITLE %defaultTitle% - Remote Reboot
		ECHO.
		ECHO Attempting to send reboot signal to %deviceName%...
		shutdown /r /m \\%deviceName% /t 0
		ECHO.
		ECHO Remote reboot signal sent to %deviceName%
		PAUSE
		GOTO start

	:devicePtrSpooler
		CLS
		TITLE %defaultTitle% - Remote Printer Spooler
		ECHO.
		sc \\%deviceName% stop SPOOLER
		ping 127.0.0.1 -n 3 > nul
		TITLE %defaultTitle% - Remote Printer Spooler - Clearing Printer Queue
		ECHO.
		ECHO Clearing printer queue...
		ping 127.0.0.1 -n 3 > nul
		del /q /f /s "\\%deviceName%\c$\Windows\System32\spool\printers\*"
		TITLE %defaultTitle% - Remote Printer Spooler
		sc \\%deviceName% start SPOOLER
		ping 127.0.0.1 -n 6 > nul
		CLS
		sc \\%deviceName% query SPOOLER >> _temp.txt
		findstr "STATE" _temp.txt >> _temp2.txt
		SET /p string=<_temp2.txt
		SET string2=%string:~32%
		ECHO.
		ECHO Printer Spool Service is currently %string2%
		DEL _temp.txt
		DEL _temp2.txt
		ECHO.
		ECHO The printer spooler has been restarted on %deviceName%.
		PAUSE
		GOTO start
	
	:deviceShutdown
		CLS
		TITLE Master Key Script - Remote Shutdown
		ECHO.
		ECHO Attempting to send shutdown signal to %deviceName%...
		shutdown /s /m \\%deviceName% /t 0
		ECHO.
		ECHO Remote shutdown signal sent to %deviceName%.
		PAUSE
		GOTO start
		
	:empInfo
		TITLE Employee Account Info Check
		COLOR 0F
		MODE 80,16
		ECHO.
		ECHO Input the Employee ID or user name to search.
		ECHO Input a zero (0) and press Enter to go back to the main menu.
		ECHO.
		SET /p user=User name:                   
		:: input 0 and press enter to go back to start of main script otherwise you loop and stay within this section
		IF "%user%"=="0" GOTO start
		net user %user% /domain | findstr /b "Full. Comment. Account. Password"
		ECHO.
		PAUSE
		GOTO empInfo	
	
	:endChoice
		EXIT
