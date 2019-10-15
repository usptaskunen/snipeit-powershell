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
2. Active Directory
3. Windows Computers 

## Initial Setup

Take the sample script, modify it to reflect to your location