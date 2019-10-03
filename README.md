# snipeit-powershell
Snipe IT Asset automation with PowerShell Scripts

Original version at:
https://github.com/ReignSol/snipeit-powershell


These scripts are to help automating adding assets to Snipe IT with PowerShell. Preference is to
run this as a script on target computers using Group Policy settings.


## Asset Creation
Use the Asset-Create.PS1 as a Computer Configuration script when building a new GPO to
add asset CSV-files. The powershell script can be run with a command:

Remember to edit the path variable inside the script for this to work properly

`powershell.exe -executionpolicy bypass -file AssetCreate.PS1`

## CSV Merger

MergeCSV.ps1 script will look for CSV-files that are older than 1 day and archive them into a folder named you can
define using the $archivefolder parameter

$CSVFolder = THE FOLDER WHERE THE INDIVIDUAL ASSET CSV'S ARE. 
$ArchiveFolder = The folder you want the asset CSV-files to be archived to

$OutputFile = LOCATION OF MERGED CSV FILE