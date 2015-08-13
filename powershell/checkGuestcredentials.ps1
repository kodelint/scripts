$ExportFilePath = "C:\tmp\Password.csv"
$PWD = "l0veME!"
$vms=get-view -viewtype virtualmachine
$Report = @()
foreach($vm in $vms){
$data = Invoke-VMScript -GuestUser root -GuestPassword $PWD -ScriptText "hostname" -VM $_.Name
$vminfo = {} | Select Hostname, Result
if ($data -eq $null) {
$vminfo.Hostname = $vm
$vminfo.Result = "No Working"
}
else {
$vminfo.Hostname = $data
$vminfo.Result = "Password Working"
$Report += $vminfo
}
}
$Report = $Report | Sort-Object HostName
IF ($Report -ne “”) {
    $Report | Export-Csv $ExportFilePath -NoTypeInformation
    }
 Invoke-Item $ExportFilePath