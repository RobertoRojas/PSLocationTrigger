$PSLocationTriggerFile = ".pstrigger.ps1";
$DefultTriggerFileContent = @"
[CmdletBinding()]
param (
    [switch]
    `$Entering
);
if (`$Entering) {
    Write-Host -Object `"Going into `$PSScriptRoot`";
} else {
    Write-Host -Object `"Leaving `$PSScriptRoot`";
}
"@;
<#
.SYNOPSIS
    This function return the path of the trigger file. if exist into the current path or any parent of it if not return null.

.DESCRIPTION
    This function return the path of the trigger file. if exist into the current path or any parent of it if not return null. This function is looking for a file called '.pstrigger.ps1'.

.PARAMETER Path
    Folder path to check.

.LINK
    https://github.com/RobertoRojas/PSLocationTrigger#readme
#>
function Get-PSLocationTriggerFile {
    [CmdletBinding()]
    param (
        [Alias("LiteralPath")]
        [string]
        $Path = $(throw "You must send the path")
    );
    if (-not $Path -or -not $(Test-Path -LiteralPath $Path)) {
        return $null;
    }
    $TriggerPath = $(Join-Path -Path $Path -ChildPath $PSLocationTriggerFile);
    return (Test-Path -LiteralPath $TriggerPath) ? $(Resolve-Path -LiteralPath $TriggerPath).Path : `
        $(Get-PSLocationTriggerFile -LiteralPath $(Get-Item -LiteralPath $Path).Parent.FullName);
}
<#
.SYNOPSIS
    This function trigger the event and change the location.

.DESCRIPTION
    This function check the path to move and if have any trigger before. It execute the leaving of the old trigger and execute the new one later.

.PARAMETER Path
    Specify the path of a new working location.

.PARAMETER LiteralPath
    Specifies a path of the location. 

.PARAMETER PassThru
    Returns a PathInfo object that represents the location. By default, this cmdlet does not generate any output.

.PARAMETER StackName
    Specifies an existing location stack name that this cmdlet makes the current location stack.

.NOTES
    This function send all the parameters to the Set-Location function, please check the documentation there to get more information.

.LINK
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/set-location?view=powershell-7.3
#>
function Set-LocationEvent {
    [CmdletBinding(DefaultParameterSetName = "default")]
    param (
        [Parameter(
            ParameterSetName = "default",
            Position = 0
        )]
        [string]
        $Path = $env:USERPROFILE,
        [Parameter(
            ParameterSetName = "literal",
            Mandatory = $true
        )]
        [string]
        $LiteralPath,
        [switch]
        $PassThru,
        [Parameter(ParameterSetName = "stack")]
        [string]
        $StackName
    );
    $CurrentTrigger = $env:PSTRIGGERPATH;
    $TriggerPath = Get-PSLocationTriggerFile -Path $Path;
    Write-Verbose -Message "Current: [$CurrentTrigger]";
    Write-Verbose -Message "Trigger: [$TriggerPath]";
    if ((Test-Path -Path $Path) -or (Test-Path -LiteralPath $LiteralPath)) {
        if ($TriggerPath -ne $CurrentTrigger) {
            if ($CurrentTrigger) {
                & $CurrentTrigger -Entering:$false;
                [System.Environment]::SetEnvironmentVariable(
                    "PSTRIGGERPATH",
                    $null,
                    [System.EnvironmentVariableTarget]::Process
                );
            }
            if ($TriggerPath) {
                $TriggerPath = $TriggerPath;
                [System.Environment]::SetEnvironmentVariable(
                    "PSTRIGGERPATH",
                    "$TriggerPath",
                    [System.EnvironmentVariableTarget]::Process
                );
                & $TriggerPath -Entering:$true;
            }
        }
    }
    $Params = $PSCmdlet.MyInvocation.BoundParameters
    Set-Location @Params;
}
<#
.SYNOPSIS
    Create a trigger file.

.DESCRIPTION
    Create a trigger file into the selected path, the name of the file will be '.pstrigger.ps1'.

.PARAMETER Path
    Folder path to create the file.

.PARAMETER Force
    Overwrite the content of the file if it exists.

.LINK
    https://github.com/RobertoRojas/PSLocationTrigger#readme
#>
function New-PSLocationTriggerFile {
    [CmdletBinding()]
    param (
        [Alias("LiteralPath")]
        [string]
        $Path = ".\",
        [switch]
        $Force
    );
    $File = $(Join-Path -Path $Path -ChildPath $PSLocationTriggerFile);
    if ((Test-Path -LiteralPath $File) -and -not $Force) {
        Write-Error -Message "The file[$File] already exists, use -Force to overwrite";
        return;
    }
    Out-File -Encoding utf8 -FilePath $File -InputObject $DefultTriggerFileContent;
}
<#
.SYNOPSIS
    Enable it to trigger the events with the 'cd' command

.DESCRIPTION
    Add the 'cd' command as an alias of 'Set-LocationEvent' globally.

.LINK
    https://github.com/RobertoRojas/PSLocationTrigger#readme
#>
function Enable-PSLocationTrigger {
    [CmdletBinding()]
    param ();
    Set-Alias -Name cd -Value Set-LocationEvent -Option AllScope -Scope "Global";
}
<#
.SYNOPSIS
    Disable it to trigger the events with the 'cd' command

.DESCRIPTION
    Add the 'cd' command as an alias of 'Set-Location' globally.

.LINK
    https://github.com/RobertoRojas/PSLocationTrigger#readme
#>
function Disable-PSLocationTrigger {
    [CmdletBinding()]
    param ();
    Set-Alias -Name cd -Value Set-Location -Option AllScope -Scope "Global";
}