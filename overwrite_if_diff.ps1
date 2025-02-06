# This is a PS script that will copy items from a source directory to a
# destination directory, only if the item is not already present in the 
# destination, or if the item is present but is an older version of the file;

# Create your first dictionary, for the source drive, that will store your 
# checksum values for the first drive;
$dictionary1 = [Ordered]@{}

# Create your second dictionary, for the destination drive, that will store
# your checksum values for your second drive;
#$dictionary2 = [Ordered]@{}

function Get-Checksums($path, $dictionary) {
  Get-ChildItem $path -Recurse | ForEach-Object {
    if ($_.PSIsContainer) {  # If it's a directory
      if ($($_.FullName[0]) -ne ".") { # If the name of the directory does not begin with a "."
        Get-Checksums $_.FullName  # Recursively call the function on the subdirectory
      } else { # Else, if it's not a directory....
      
      # The key will be the full filepath of the file;
      #$dictionary1.Add(key = $($_.FullName))

        # Calculate the MD5 hash of the file
        $hash = (Get-FileHash -Path $($_.FullName) -Algorithm MD5).Hash

        # Print to terminal for debugging purposes
        Write-Output "Processing file: $($_.FullName)"
        Write-Output "Calculated hash: $hash"

        # Print to terminal for debugging purposes
        #Write-Output $_.FullName, $hash

        # The key will be the filename, the value will be the MD5 checksum for the file;
        #$dictionary.Add($_.FullName, $hash)
        
        # This might be simpler, but it will replace the key if it already exists;
        $dictionary[$_.FullName] = $hash

      }
    } 
  }
  # Returning the variable will allow us to use it outside of this function
  return $dictionary
}

# Create your first dictionary, for the source drive, that will store your 
# checksum values for the first drive;
#$dictionary1 = [Ordered]@{}

# Call the function that calculates the checksums, enter the letter of your first drive; 
Get-Checksums "E:\" ([ref]$dictionary1)

# Using GetEnumerator();
$dictionary1.GetEnumerator() | ForEach-Object {
  Write-Output ("$($_.Key): $($_.Value)")
}

# Using Format-Table;
#$dictionary1 | Format-Table

# This command does not print the actual contents of the dictionary;
#Write-Host "$dictionary1"

<#
# Call the function that calculates the checksums, enter the letter of your second drive;
calc-chcksums "E:\"

for file in dictionary1 {
  if file not in dictionary2:
    Copy-Item file -Force
  else if file in dictionary2:
    if file[value1] != file[value2]
      Copy-Item file -Force
    else do-nothing

}
#>