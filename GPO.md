# Using a GPO to inventory computers

Here is a guide to help you run this script on Windows computers 
via a Group Policy Object. The way I've done it, is to have a 
normal script (sample-run-script.cmd) that gets executed as a 
scheduled task.

There are some requirements for this.

1. A fileshare for the scripts and inventory data
  - Preferably a hidden share, for example \\server\Inventory$ where the $ in the share name hides the share
  - Read-, execute- and create permissions for Computers, I use AD "Authenticated Users" group for this
  - You should create a filestructure for the inventory data inside the share (Merged, Inventory and Archive)
2. Active Directory (Preferably at least 2008 R2)
3. Windows Computers (Preferably Windows 7 or newer, scripts have not been tested on Windows XP)

## Initial Setup

Take the scripts, modify them to reflect to your location.

Copy the sample-run-script.cmd to your domain controller's NETLOGON folder (\\DC\NETLOGON), as 
this gets replicated to all domain controllers. You can place the inventory-script (Asset-Create.ps1)
in it's own Scripts folder inside the inventory fileshare. Just remember those permissions.

### Important

The Asset-Create.ps1 has variable for the target location, you do not need a filename for this - the name is generated at the end of the script

The mergeCSV.ps1 can be on your computer, but the variables need to be changed inside the file to reflect the location of the inventoried CSV-files
and the target path (and filename) for the merged CSV.

## Create the GPO

On your Domain Controller, open Group Policy Management Console (Win + R - gpmc.msc), expand the tree
so you can see "Group Policy Objects", right-click there and click on New. You can name the policy
however you like, and the Source Starter GPO should be empty.

## Edit the GPO

Now that you have an empty Group Policy Object, expand the Group Policy Objects folder and
right-click on your object. Select Edit. Since we are going to be creating a Scheduled Task,
specifically for the Computer Policy, go to Computer Configuration - Preferences - Control Panel Settings -
Scheduled Tasks. Right-click in the empty field and click New - Scheduled Task (Windows Vista and later).

### Parameters
- General tab
  - Action: Update
  - Name: Inventory Task
  - Security options
    - BUILTIN\SYSTEM
    - Run whether user is logged on or not
    - [x] Run with highest privileges
- Triggers tab
  - New
    - On a schedule
    - Settings
      - Daily
      - Start date (select your day)
      - Time (select your time for the task execution) 
- Actions tab
  - New
    - Start a program
    - Program/Script: \\domainController\NETLOGON\sample-run-script.cmd
