# This is a copy of my actual script, I am just using this for debugging,
# I am going to make a few changes to the script to see if it will run;

# Create your first dictionary, for the source drive, that will store your 
# checksum values for the first drive;
#$dictionary1 = [Ordered]@{}
<#$dictionary1["key0"] = "test"
foreach ($entry in $dictionary1.GetEnumerator()) {
  Write-Output ("{0}: {1}" -f $entry.Key, $entry.Value)
}#>

# Create your second dictionary, for the destination drive, that will store
# your checksum values for your second drive;
#$dictionary2 = [Ordered]@{}

# VIEW LAST WRITE TIME OF FILE;
#Get-Item <filepath> | Select-Object LastWriteTime

# This function will be called on every file in the source and destination drives,
# it takes a filepath as its argument; 
function Get-LastWriteTime($file) {
  # Then it picks out the LastWriteTime of the file;
  $lastWriteTime = Get-Item $file | Select-Object LastWriteTime
  Return $lastWriteTime
}

<#
# ChatGPT suggestion;
function Get-Timestamps {
  param (
      [string]$directory,
      [ref]$dictionary
  )

  # Some code here...

  # Initialize the dictionary if needed
  if ($null -eq $dictionary.Value) {
      $dictionary.Value = [Ordered]@{}
  }

  # Rest of the code to populate the dictionary with timestamps
  # ...
}
#>

# This function will fill out our dictionary with full filepaths as keys
# and LastWriteTime's as values;
function Get-Timestamps([string]$path, [ref]$dictionary) {
  <# Check if $dictionary is null and initialize it if needed;
  if ($null -eq $dictionary.Value) {
    $dictionary.Value = [Ordered]@{}
  }#>
  Write-Output "$dictionary1"
  # We need this line because we will be sorting through many directories;
  Get-ChildItem $path -Recurse | ForEach-Object {
    # If it's a directory...
    if ($_.PSIsContainer) {  
      # DEBUG
      #Write-Output $_.FullName

      # ...and if the name of the directory does not contain "\." ...
      # (for some reason, -like returns the directories in E:\ that DO NOT contain a "\.");
      #if ($_.FullName -notlike '*\\\.*') {

      if (!($_.FullName -contains '\\.')) {

        # DEBUG
        #Write-Output $_.FullName
        
        # ...recursively call the function on the subdirectory;
        Get-Timestamps $_.FullName
      }  
    # Else (if it's NOT a directory)...
    } else {
      # DEBUG
      write-output $_.FullName
      #if (!($_.PSIsContainer)) {
      # DEBUG
      Write-Output "test2"
          #if ($($_.FullName[]))
          # The key will be the full filepath of the file;
          #$dictionary1.Add(key = $($_.FullName))

      # DEBUG
      Write-Output "Processing file: $($_.FullName)"

      # Call the Get-LastWriteTime function and assign output to variable;
      $LastWriteTime = Get-LastWriteTime($_.FullName)

      if ($null -eq $dictionary.Value) {
        $dictionary.Value = [Ordered]@{}
      }
      Write-Output "$dictionary1"
        
      # Create dictionary entry with key of FullName and value of LastWriteTime;  
      # (This will replace the key if it already exists);
      $dictionary[$_.FullName] = $LastWriteTime
    }
  }
  # Returning the dictionary will allow us to use it outside of this function;
  return $dictionary
}

# Initialize our first dictionary, corresponding to the source;
#$dictionary1 = [Ordered]@{}
# Call our function that retrieves the last write time, enter the letter of your first drive; 
Get-Timestamps "C:\Users\rodri cruz\D" ([ref]$dictionary1) > "./test.txt"

# 
$dictionary1.GetEnumerator() | ForEach-Object {
  Write-Output ("$($_.Key): $($_.Value)")
}

# CREATE A LOOP TO CALL THE FUNCTION ON ALL SUBDIRECTORIES AND FILES?
# Not sure if that's necessary or if the Get-Timestamps function is already doing that;


<# COMMENTED OUT BECAUSE I WILL BE USING LASTWRITETIME INSTEAD OF FILEHASHES;
function Get-Checksums($path, $dictionary) {
  Get-ChildItem $path -Recurse | ForEach-Object {
    if ($_.PSIsContainer) {  # If it's a directory
      #Write-Output $_.FullName
      if ($($_.FullName[3]) -ne ".") { # If the name of the directory does not begin with a "."
        Write-Output $_.FullName
        #Get-Checksums $_.FullName  # Recursively call the function on the subdirectory
      } else { # Else, if it's not a directory....
        if ($($_.FullName[]))
      # The key will be the full filepath of the file;
      #$dictionary1.Add(key = $($_.FullName))

        # Calculate the MD5 hash of the file
        #$hash = (Get-FileHash -Path $($_.FullName) -Algorithm MD5).Hash

        # Print to terminal for debugging purposes
        Write-Output "Processing file: $($_.FullName)"
        #Write-Output "Calculated hash: $hash"

        # Print to terminal for debugging purposes
        #Write-Output $_.FullName, $hash

        # The key will be the filename, the value will be the MD5 checksum for the file;
        #$dictionary.Add($_.FullName, $hash)
        
        # This might be simpler, but it will replace the key if it already exists;
        $dictionary[$_.FullName] = "x"

      }
    } 
  }
  # Returning the variable will allow us to use it outside of this function
  return $dictionary
}
#>

#Get-Timestamps E:\julia.txt ([ref]$dictionary1)

# Create your first dictionary, for the source drive, that will store your 
# checksum values for the first drive;
#$dictionary1 = [Ordered]@{}


#if ($($_.FullName[3]) -ne ".") { # ...and if the name of the directory does not begin with a "." ...
      
      # ...and if the name of the directory does not contain "\." ...
      #if (!($_.FullName -contains "\.")) {
      
      # ...and if the name of the directory does not contain "\." ...
      #if (!($_.FullName -contains "\\") -and !($_.FullName -contains "\.")) {

      # ...and if the name of the directory does not contain "\." ...
      # (-match uses regex, first '\' is escape character)
      #if (!($_.FullName -match '\\.')) {

      #if (!($_.FullName -match '*\\.*')) {