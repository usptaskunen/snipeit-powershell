# Define the parameters here

# The folder where the CSV files are located
# Example uses a hidden share (trailing '$' in the share name)
$CSVFolder = '\\NETWORKSHARE\INV$';
$ArchivePath = '\\NETWORKSHARE\InventoryArchive\'

# Define the target CSV-file
$OutputFile = '\\NETWORKSHARE\Merged CSV\IMPORT.csv';

# Create an empty array
$CSV= @();

# Import all CSV-files inside the folder into an array
Get-ChildItem -Path $CSVFolder -Filter *.csv | ForEach-Object { 
    $CSV += @(Import-Csv -Path $_)
}

# Merge the data to the target CSV-file
$CSV | Export-Csv -Path $OutputFile -NoTypeInformation -Force;

# Archive the CSV files
get-childitem -Path $CSVFolder | where-object {$_.LastWriteTime -lt (get-date).AddDays(-1)} | move-item -destination $ArchivePath -force