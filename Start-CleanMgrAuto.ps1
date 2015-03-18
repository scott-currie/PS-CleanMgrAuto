#### Perform agressive automated disk cleanup using cleanmgr. This will overwrite
#### cleanmgr profile 1.

# Parent key under which we'll check for subkeys
$baseKey = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\'

# Array of subkeys to look for
$subKeys = @('Active Setup Temp Folders\', 'BranchCache\', 'Downloaded Program Files\', `
		'Internet Cache Files\', 'Memory Dump Files\','Microsoft Office Temp Files\', `
		'Microsoft Offline Pages Files\','Old ChkDsk Files\','Previous Installations\', `
		'Recycle Bin\','Service Pack Cleanup\','Setup Log Files\',
		'System error memory dump files\','System error minidump files\', `
		'Temporary Files\','Temporary Setup Files\','Thumbnail Cache\','Update Cleanup\', `
		'Upgrade Discarded Files\','User file versions\','Windows Defender\', `
		'Windows Error Reporting Archive Files\','Windows Error Reporting System Archive Files\', `
		'Windows Error Reporting System Queue Files\','Windows ESD installation files\', `
		'Windows Upgrade Log Files\')

# Check for each subkey using full path. If key exists, set StateFlags0001 property to 2
# to add that cache to cleanmgr profile #1
foreach ($subKey in $subKeys) {
	$keyPath = $baseKey + $subKey
	if (Test-Path $keyPath) {
		Write-Host("Found key: " + $keyPath)
		$value = Get-ItemProperty $keyPath -Name StateFlags0001 -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -Path $keyPath -Name StateFlags0001 -PropertyType DWord -Value 2 -ErrorAction SilentlyContinue
	}
	else {
		Write-Host("No key:" + $keyPath)
	}
}

$command = "cleanmgr"
$arguments = '/sagerun:1'
Start-Process $command $arguments -ErrorAction SilentlyContinue








