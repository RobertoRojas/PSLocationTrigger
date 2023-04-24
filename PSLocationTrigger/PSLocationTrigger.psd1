@{
    RootModule = "PSLocationTrigger.psm1";
    ModuleVersion = "1.0.0";
    GUID = "48f01b7f-28bc-4852-81ac-bdfe229eeb46";
    Author = "Rojas, Roberto";
    Description = "This module helps you run a script when you enter or exit a folder"
    PowerShellVersion = "7.3.3"
    FunctionsToExport = @(
        "Disable-PSLocationTrigger",
        "Enable-PSLocationTrigger",
        "Get-PSLocationTriggerFile",
        "New-PSLocationTriggerFile",
        "Set-LocationEvent"
    );
    PrivateData = @{
        PSData = @{
            Tags = @();
            LicenseUri = "https://raw.githubusercontent.com/RobertoRojas/PSLocationTrigger/main/LICENSE";
            ProjectUri = "https://github.com/RobertoRojas/PSLocationTrigger";
        }
    }
    HelpInfoURI = "https://github.com/RobertoRojas/PSLocationTrigger/blob/main/README.md"
}