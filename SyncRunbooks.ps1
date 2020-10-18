#Import modules
Import-Module Az.Accounts

# Set up readme.md
Clear-Content -path ".\readme.md"
"# Runbooks structure" >> ".\README.md"

function sync-git {
	Param (
		[Parameter(Mandatory,Position=0)]
		[ValidateNotNullOrEmpty()]
		[string]
		$commit
	)
	
	git pull
	git add .
	git commit -m $commit
	git push
}

# Auth
if (-not (az account show)) {
	try {
	Connect-AzAccount
	} catch {
		# Set up readme.md
		"## Error with sync: ## Could not connect Az module." >> ".\README.md"
		sync-git -commit "Error - Could not connect Az module."
		exit
	}
}
$userName = ((Get-AzContext).Account).id
"> Running user: $userName" >> ".\README.md"

# Git sync
try {
	git pull
} catch {
	"## Error with sync: ## Could not connect to Github account." >> ".\README.md"
}


Foreach ($sub in (Get-AzSubscription | Where-object	state -ne 'Disabled')) {
	Set-AzContext -SubscriptionId $sub.id
	$subName = $sub.Name
	

	Foreach ($rg in Get-AzResourceGroup) {
		$rgName = $rg.ResourceGroupName
		$accountlist = Get-AzAutomationAccount -ResourceGroupName "$rgName"
		
		if ($accountlist) {
			if (-not (Get-Item -path ".\$subName")) {
				$output = New-Item -Path ".\$subName" -ItemType Directory -force
				Write-output ('Created Subscription dir:      {0}' -f $output.name)
				"## Subscription: $subName" >> ".\README.md"
			}
			
			$output = New-Item -Path ".\$subName\$rgName" -ItemType Directory -force
			Write-output ('Created Resource Group dir:    {0}' -f $output.name)
			"**Resource Group: $rgName**" >> ".\README.md"
			
			Foreach ($account in $accountlist) {
				$accountName = $account.AutomationAccountName
				
				$output = New-Item -Path ".\$subName\$rgname\$accountName" -ItemType Directory -force
				Write-output ('Created Automation Accunt dir: {0}' -f $output.name)
				" - $accountName" >> ".\README.md"
				
				Foreach ($runbook in Get-AzAutomationRunbook -AutomationAccountName "$accountName" -ResourceGroupName "$rgName") {
				$runbookName = $runbook.name
					$output = Export-AzAutomationRunbook -ResourceGroupName "$rgName" -AutomationAccountName "$accountName" -Name "$runbookName" -OutputFolder ".\$subName\$rgname\$accountName" -Force
					Write-output ('Exported Runbook: {0}' -f $output.name)
					"   - $runbookName" >> ".\README.md"
				}
				
				# Optional: Configure Source Control
				#New-AzAutomationSourceControl -Name SCGitHub -RepoUrl https://github.com/<accountname>/<reponame>.git -SourceType GitHub -FolderPath "/MyRunbooks" -Branch master -AccessToken <secureStringofPAT> -ResourceGroupName <ResourceGroupName> -AutomationAccountName <AutomationAccountName>
			}
		}
	}
}

# Sync git
sync-git -commit "Runbook updates"