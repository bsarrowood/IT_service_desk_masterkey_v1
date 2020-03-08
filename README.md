# IT_service_desk_masterkey_v1

:: Created by:		Brad Arrowood
:: Created on:		2019.03.15
:: Last updated:  2019.04.29
:: Script name:		IT_service_desk_masterkey_v1.bat
:: Description:		A command line batch script tool for helping an IT Service Desk technician to locally and remotely
::					      work on computers on the company network and to be able to search Active Directory account info. This
::					      script is a combination of what was once several individual scripts I'd made and wanted to make their
::					      use more readily accessable to the rest of my team by creating 1 script that had all their features together.
::      					The setup is based off helping stores with a 4-digit store number so parts of the code are set up for 
::			      		that format in various parts, but this can be edited as needed for others needing parts of it. I will
::					      add, at the time of making this script I don't know if we'd been given admin rights on the network at this
::					      point, but after making an updated version with more features using Powershell (another script I'll be
::					      uploading) I know we did have admin rights. So depending on your network access rights parts of this may
::					      or may not work.
