# snipeit-powershell
Snipe IT Asset automation with PowerShell Scripts

Original version at:
https://github.com/ReignSol/snipeit-powershell


These scripts are to help automating adding assets to Snipe IT with PowerShell. Preference is to
run this as a script on target computers using Group Policy settings.

## Asset Creation
Use the Asset-Create.PS1 as a Computer Configuration script when building a new GPO to
add asset CSV-files. The powershell script can be run with a command:

`powershell.exe -executionpolicy bypass -file AssetCreate.PS1`

### Variables that need configuring
* $targetpath = The folder you want to save the output CSV to

## CSV Merger

MergeCSV.ps1 script will look for CSV-files that are older than 1 day and archive them into a folder named you can
define using the $archivefolder parameter

### Variables that need configuring
* $CSVFolder = This is the folder where the asset CSV-files (to be merged) are located.
* $ArchiveFolder = The folder you want the asset CSV-files to be archived to
* $OutputFile = Where you want to save the merged CSV file
