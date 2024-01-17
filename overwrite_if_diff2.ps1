# This is a copy of my actual script, I am just using this for debugging,
# I am going to make a few changes to the script to see if it will run;

# Create your first dictionary, for the source drive, that will store your 
# checksum values for the first drive;
$dictionary1 = [Ordered]@{}

# Create your second dictionary, for the destination drive, that will store
# your checksum values for your second drive;
#$dictionary2 = [Ordered]@{}

# VIEW LAST WRITE TIME OF FILE;
#Get-Item <filepath> | Select-Object LastWriteTime

function Get-LastWriteTime($path, $dictionary) {
  Get-ChildItem $path -Recurse | ForEach-Object {
    if ($_.PSIsContainer) {  # If it's a directory...
      #Write-Output $_.FullName
      if ($($_.FullName[3]) -ne ".") { # ...and if the name of the directory does not begin with a "." ...
        # DEBUGGING
        Write-Output $_.FullName
        Get-LastWriteTime $_.FullName  # ...recursively call the function on the subdirectory;
      } else { # Else, if it's NOT a directory...
        if ($($_.FullName[]))
      # The key will be the full filepath of the file;
      #$dictionary1.Add(key = $($_.FullName))

        # Assign last write time of file to the variable;
        $LastWriteTime = (Get-Item $($_.FullName) | Select-Object LastWriteTime)

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

# Create your first dictionary, for the source drive, that will store your 
# checksum values for the first drive;
#$dictionary1 = [Ordered]@{}

# Call the function that calculates the checksums, enter the letter of your first drive; 
Get-LastWriteTime "E:\" ([ref]$dictionary1)

# Using GetEnumerator();
$dictionary1.GetEnumerator() | ForEach-Object {
  Write-Output ("$($_.Key): $($_.Value)")
}