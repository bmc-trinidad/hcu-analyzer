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
	$orderId = Read-Host "Enter order ID"
	$runCount = Read-Host "Enter run count [use empty value for all]"
	$hcuPath = Read-Host "Enter HCU path"

	$runCount = ($runCount) ? $runCount -replace '^0+', '' : $runCount # remove leading zeros. using ternary instead of if statement
	$numOfInt = ($runCount | Measure-Object -Character).Characters # counting the number of integers 

	
	if (!$runCount) {
		Select-String -Pattern $orderId -Path $hcuPath\AG_LOG\dailylog\* | Select-Object Line
	} elseif ($numOfInt -eq 1) {
		Select-String -Pattern "$orderId, RUNNO 0000$runCount" -Path $hcuPath\AG_LOG\dailylog\* | Select-Object Line
	} elseif ($numOfInt -eq 2) {
		Select-String -Pattern "$orderId, RUNNO 000$runCount" -Path $hcuPath\AG_LOG\dailylog\* | Select-Object Line
	} elseif ($numOfInt -eq 3) {
		Select-String -Pattern "$orderId, RUNNO 00$runCount" -Path $hcuPath\AG_LOG\dailylog\* | Select-Object Line
	} elseif ($numOfInt -eq 4) {
		Select-String -Pattern "$orderId, RUNNO 0$runCount" -Path $hcuPath\AG_LOG\dailylog\* | Select-Object Line
	} elseif ($numOfInt -eq 5) {
		Select-String -Pattern "$orderId, RUNNO $runCount" -Path $hcuPath\AG_LOG\dailylog\* | Select-Object Line
	} else {
		Write-Host "This script does not support 6 digit run numbers"
	}
}

Interactive
