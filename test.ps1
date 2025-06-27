# first function that launches if user launches script with no parameters
function Interactive {
	'What action would you like to take?' | Write-Host
	
	$options = @('Search proclog directory for files matching a string', 'Search dailylog for orderID')
	For ($i=0; $i -lt $options.Length; $i++) {
		#wasn't able to get the output I wanted in a single line for Write-Output. 
		#had to create variables with the string I wanted and then use Write-Output
		#ISS-001
		$itemNumber = $i + 1
		$itemOption = $options[$i]
		Write-Host "$itemNumber. $itemOption"
	}
	Write-Host `n #adding blank line
	
	$selection = Read-Host "Option"
	
	if ($selection -eq 1) {
		Get-ProclogFiles
	} elseif ($selection -eq 2) {
		Search-Dailylog
	} else {
		Write-Host "Invalid selection"
	}
}

# used to list the proclog files that contain the string provided
function Get-ProclogFiles {
	$orderId = Read-Host "Enter search string"
	$hcuPath = Read-Host "Enter HCU path"
	
	Select-String -Pattern $orderId -Path $hcuPath\AG_LOG\proclog\* -List | Select-Object Filename
}

# used to search the dailylog directory for an order ID
function Search-Dailylog {
	$orderId = Read-Host "Enter search string"
	$hcuPath = Read-Host "Enter HCU path"

	Select-String -Pattern $orderId -Path $hcuPath\AG_LOG\dailylog\* | Select-Object Line
}

Interactive
