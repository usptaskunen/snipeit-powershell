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


## Link the GPO

Assuming you have never done anything with GPOs, you need to link the policy.
I prefer creating a Organizational Unit for testing purposes, where you put
your computer accounts you are going to test with. I recommend this, as it 
won't affect other computers if there happens to be a malfunction in the script.

Now I'm going to assume you have an OU ready for this, you traverse the Domain tree
inside the GPMC and find your target OU. Right-click on the OU, select "Link an
Existing GPO..." and find your new Policy from the selection box. After this, the
script should start applying.

Things to keep in mind
- GPO Refresh is 15 minutes on default
- Domain Controller synchronization interval is 15 minutes at minimum

If you want the GPO to apply faster, you can run "repadmin /syncall" on domain controllers
after you've added the policy, then run gpupdate /force on your target computer. You can
check if the policy is getting applied with gpresult /r, but in order to see the applied
computer policies, you need to use an elevated command prompt.