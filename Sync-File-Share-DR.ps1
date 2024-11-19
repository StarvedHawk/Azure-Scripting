# Define Variables
$SourceStorageAccountName = "bespinpscalculator"
$SourceFileShareName = "abc"
$DestinationStorageAccountName = "tasktesting123"
$DestinationFileShareName = "abc"
$SrcResourceGroupName = "PS-Calc"
$DestResourceGroupName = "PS-Calc"
$DRSubscriptionId = "0d0bb4f8-be90-489c-8295-b46996310c69"

# Define SAS Token validity duration (in seconds)
$SASValidityDuration = 300 # 5 minutes

# Generate SAS Token function
function Generate-SASToken {
    param (
        [string]$StorageAccountName,
        [string]$ResourceGroupName
    )

    # Get storage account keys
    $Keys = (Get-AzStorageAccountKey -ResourceGroupName $ResourceGroupName -Name $StorageAccountName)
    $StorageAccountKey = $Keys[0].Value

    # Generate SAS Token
    $Context = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
    $EndTime = (Get-Date).AddSeconds($SASValidityDuration)
    $SAS = New-AzStorageAccountSASToken -Service File -ResourceType Service,Container,Object -Permission rwdlc -ExpiryTime $EndTime -Context $Context

    return $SAS
}

# Generate SAS tokens for source and destination
$SourceSASToken = Generate-SASToken -StorageAccountName $SourceStorageAccountName -ResourceGroupName $SrcResourceGroupName
$DestinationSASToken = Generate-SASToken -StorageAccountName $DestinationStorageAccountName -ResourceGroupName $DestResourceGroupName

# AzCopy Path (adjust if AzCopy is not in PATH)
$AzCopyPath = "C:\Users\MohammedFaisal\Documents\AzureTools\azcopy_windows_amd64_10.14.1\azcopy.exe"

# Construct Source and Destination URLs
$SourceURL = "https://{0}.file.core.windows.net/{1}/?{2}"-f $SourceStorageAccountName,$SourceFileShareName,$SourceSASToken
$DestinationURL = "https://{0}.file.core.windows.net/{1}/?{2}"-f $DestinationStorageAccountName,$DestinationFileShareName,$DestinationSASToken

#$SourceURL = "https://bespinpscalculator.file.core.windows.net/abc/?sv=2022-11-02&ss=f&srt=sco&sp=rwdlc&se=2024-11-19T17:40:46Z&st=2024-11-19T09:40:46Z&spr=https&sig=NTfuS1gVr3oJvxPfU8BXk4G%2BivNmeDgSJ8na17pQJcQ%3D"
#$DestinationURL = "https://tasktesting123.file.core.windows.net/abc/?sv=2022-11-02&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2024-11-19T17:42:27Z&st=2024-11-19T09:42:27Z&spr=https&sig=VPA0GPeJdkHi%2BVJH683X0CWWPSPVLaEUxXJQuPrDSmk%3D"

$SourceURL
$DestinationURL

# Perform File Sync using AzCopy
Write-Host "Starting data replication..."
& $AzCopyPath sync $SourceURL $DestinationURL --recursive=true
Write-Host "Data replication completed."

# Cleanup SAS tokens (by removing their references in variables)
$SourceSASToken = $null
$DestinationSASToken = $null

Write-Host "Temporary SAS tokens cleaned up for security."

# .\azcopy.exe 