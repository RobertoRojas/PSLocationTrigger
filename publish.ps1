[CmdletBinding()]
param (
    [string]
    $NuGetApiKey = $(throw "publish.ps1: You must send the NuGetApiKey string")
);
$ErrorActionPreference = 'Stop';
$ModulePath = $(Resolve-Path -LiteralPath "$PSScriptRoot\PSLocationTrigger");
Publish-Module -NuGetApiKey $NuGetApiKey -Path $ModulePath;