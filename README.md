# PSLocationTrigger

This module provide the function to execute scripts automatically when you enter or exit a folder.

You can download this source code and install the module into your _PSModulePath_, but is more simple use the **PowerShell Gallery** module:

```Powershell
Install-Module -Name PSLocationTrigger
```

You can manually enable and disable the module with these commands:

```Powershell
# To enable
Enable-PSLocationTrigger;
# To disable
Disable-PSLocationTrigger;
```

You can also set enable as default with the follow command:

```Powershell
@"
try {
    import-Module -Name PSLocationTrigger;
    if(!(New-Object Security.Principal.WindowsPrincipal `$([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) -and `$(`$null -ne `$(Get-Module -Name PSLocationTrigger))) {
        Enable-PSLocationTrigger;
    } 
}
catch {
    Write-Verbose -Message "Cannot load the PSLocationTrigger";
}
"@ | Out-File -Append -FilePath $PROFILE;
```
**Note:** Remember, could be dangerous execute scripts automatically with administrator privileges. By default this command check it and if the shell have administrator privilages, it will not active it. But you can remove the if and activate the module don't matter the privilages.

You can check if the module is active with this:

```Powershell
# Command
cd -Verbose .
<#
VERBOSE: Current: []
VERBOSE: Trigger: []
#>
```

## Example

You can activate and deactivate the python virtual environment.

```Powershell
[CmdletBinding()]
param (
    [switch]
    $Entering
);
if ($Entering) {
    & "$PSScriptRoot\venv\Scripts\activate.ps1";
} else {
    deactivate;
}
```
**File:** .pstrigger.ps1

```Powershell
PS C:\> $(Get-Command python).Source
C:\Program Files\Python38\python.exe
PS C:\> cd .\test\
(venv) PS C:\test> $(Get-Command python).Source
C:\test\venv/Scripts\python.exe
(venv) PS C:\test> cd ..
PS C:\> $(Get-Command python).Source
C:\Program Files\Python38\python.exe
```

## Trigger template creation

In order to create an trigger template, you can use the follow command:

```Powershell
New-PSLocationTriggerFile -Type Default -Force;
```