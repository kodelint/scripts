                           ###########################################################################
#
# NAME: QuickDSview.ps1
#
# AUTHOR:  Satyajit Roy
#
# COMMENT: Get all the DataSotre DS Wise and there usages via email
#
# VERSION HISTORY:
# 1.0 12/12/2013 - Initial release
#
###########################################################################
$dt=Get-Date -uformat %b-%d-%Y
$xlsfile = "C:\Temp\Datastore-$dt.xls"
Import-Module .\Export-xls.ps1

## Water Town ##

Connect-VIServer vc001.example.com -User ops\sroy -Password 'Password'
Get-Datastore | Where-Object { $_.Name -notlike "datastore1*"} | Select Name,@{N="TotalSpaceGB";E={[Math]::Round(($_.ExtensionData.Summary.Capacity)/1GB,0)}},@{N="UsedSpaceGB";E={[Math]::Round(($_.ExtensionData.Summary.Capacity - $_.ExtensionData.Summary.FreeSpace)/1GB,0)}}, @{N="ProvisionedSpaceGB";E={[Math]::Round(($_.ExtensionData.Summary.Capacity - $_.ExtensionData.Summary.FreeSpace + $_.ExtensionData.Summary.Uncommitted)/1GB,0)}},@{N="NumVM";E={@($_ | Get-VM | where {$_.PowerState -eq "PoweredOn"}).Count}} | Sort Name | Export-Xls -Path $xlsfile -WorksheetName "Watertown" -AppendWorksheet:$false
Disconnect-VIServer -Server m1vc001.example.com -Confirm:$false
sleep -Seconds 10
## Sacramento ##

Connect-VIServer vc001.example.com -User ops\sroy -Password 'Password'
Get-Datastore | Where-Object { $_.Name -notlike "datastore1*"} | Select Name,@{N="TotalSpaceGB";E={[Math]::Round(($_.ExtensionData.Summary.Capacity)/1GB,0)}},@{N="UsedSpaceGB";E={[Math]::Round(($_.ExtensionData.Summary.Capacity - $_.ExtensionData.Summary.FreeSpace)/1GB,0)}}, @{N="ProvisionedSpaceGB";E={[Math]::Round(($_.ExtensionData.Summary.Capacity - $_.ExtensionData.Summary.FreeSpace + $_.ExtensionData.Summary.Uncommitted)/1GB,0)}},@{N="NumVM";E={@($_ | Get-VM | where {$_.PowerState -eq "PoweredOn"}).Count}} | Sort Name | Export-Xls -Path $xlsfile -WorksheetName "SAC"
Disconnect-VIServer -Server m3vc001.example.com -Confirm:$false
sleep -Seconds 10
## Sydney ##

Connect-VIServer vc001.example.com -User ops\sroy -Password 'Password'																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																				
Get-Datastore | Where-Object { $_.Name -notlike "datastore1*"} | Select Name,@{N="TotalSpaceGB";E={[Math]::Round(($_.ExtensionData.Summary.Capacity)/1GB,0)}},@{N="UsedSpaceGB";E={[Math]::Round(($_.ExtensionData.Summary.Capacity - $_.ExtensionData.Summary.FreeSpace)/1GB,0)}}, @{N="ProvisionedSpaceGB";E={[Math]::Round(($_.ExtensionData.Summary.Capacity - $_.ExtensionData.Summary.FreeSpace + $_.ExtensionData.Summary.Uncommitted)/1GB,0)}},@{N="NumVM";E={@($_ | Get-VM | where {$_.PowerState -eq "PoweredOn"}).Count}} | Sort Name | Export-Xls -Path $xlsfile -WorksheetName "Sydney"
Disconnect-VIServer -Server m5vc001.example.com -Confirm:$false
sleep -Seconds 10
## Carpathia - Dullas ##

Connect-VIServer vc001.example.com -User sroy -Password 'Password'
Get-Datastore | Where-Object { $_.Name -notlike "datastore1*"} | Select Name,@{N="TotalSpaceGB";E={[Math]::Round(($_.ExtensionData.Summary.Capacity)/1GB,0)}},@{N="UsedSpaceGB";E={[Math]::Round(($_.ExtensionData.Summary.Capacity - $_.ExtensionData.Summary.FreeSpace)/1GB,0)}}, @{N="ProvisionedSpaceGB";E={[Math]::Round(($_.ExtensionData.Summary.Capacity - $_.ExtensionData.Summary.FreeSpace + $_.ExtensionData.Summary.Uncommitted)/1GB,0)}},@{N="NumVM";E={@($_ | Get-VM | where {$_.PowerState -eq "PoweredOn"}).Count}} | Sort Name | Export-Xls -Path $xlsfile -WorksheetName "Carpathia-Dullas"
Disconnect-VIServer -Server 10.28.96.228 -Confirm:$false
sleep -Seconds 10
## Carpathia - AMS ##

Connect-VIServer vc001.example.com -User sroy	-Password 'Password'
Get-Datastore | Where-Object { $_.Name -ne "Datastore*"} | Select Name,@{N="TotalSpaceGB";E={[Math]::Round(($_.ExtensionData.Summary.Capacity)/1GB,0)}},@{N="UsedSpaceGB";E={[Math]::Round(($_.ExtensionData.Summary.Capacity - $_.ExtensionData.Summary.FreeSpace)/1GB,0)}}, @{N="ProvisionedSpaceGB";E={[Math]::Round(($_.ExtensionData.Summary.Capacity - $_.ExtensionData.Summary.FreeSpace + $_.ExtensionData.Summary.Uncommitted)/1GB,0)}},@{N="NumVM";E={@($_ | Get-VM | where {$_.PowerState -eq "PoweredOn"}).Count}} | Sort Name | Export-Xls -Path $xlsfile -WorksheetName "Carpathia-AMS"
Disconnect-VIServer -Server 10.33.4.206 -Confirm:$false
sleep -Seconds 10

## RWS ##

Connect-VIServer vc001.example.com -User sroy -Password 'Password'
Get-Datastore | Where-Object { $_.Name -notlike "datastore1*"} | Select Name,@{N="TotalSpaceGB";E={[Math]::Round(($_.ExtensionData.Summary.Capacity)/1GB,0)}},@{N="UsedSpaceGB";E={[Math]::Round(($_.ExtensionData.Summary.Capacity - $_.ExtensionData.Summary.FreeSpace)/1GB,0)}}, @{N="ProvisionedSpaceGB";E={[Math]::Round(($_.ExtensionData.Summary.Capacity - $_.ExtensionData.Summary.FreeSpace + $_.ExtensionData.Summary.Uncommitted)/1GB,0)}},@{N="NumVM";E={@($_ | Get-VM | where {$_.PowerState -eq "PoweredOn"}).Count}} | Sort Name | Export-Xls -Path $xlsfile -WorksheetName "RWS"
Disconnect-VIServer -Server 192.168.2.15 -Confirm:$false
sleep -Seconds 10

if ($xlsfile -ne ""){
    $SmtpClient = New-Object system.net.mail.smtpClient
    $SmtpClient.host = "smtp001.example.com"   #Change to a SMTP server in your environment
    $MailMessage = New-Object Net.mail.mailmessage
	$MailAttachment = New-Object Net.Mail.Attachment($xlsfile)
    $MailMessage.from = "System.Automation@example.com"   #Change to email address you want emails to be coming from
    $MailMessage.To.add("admin@example.com")    #Change to email address you would like to receive emails.
    $MailMessage.IsBodyHtml = 1
    $MailMessage.Subject = "VMware Capacity Report"
	$MailMessage.Attachments.Add($MailAttachment)
    $MailMessage.Body = "Rakesh, Please find the vCenter Capacity Report from ALL DCs"
    $SmtpClient.Send($MailMessage)}
else {
	$SmtpClient = New-Object system.net.mail.smtpClient
    $SmtpClient.host = "smtp001.example.com"   #Change to a SMTP server in your environment
    $MailMessage = New-Object system.net.mail.mailmessage
	$MailMessage.from = "System.Automation@example.com"
	$MailMessage.To.add("admin@example.com")    #Change to email address you would like to receive emails.
    $MailMessage.IsBodyHtml = 1
    $MailMessage.Subject = "VMware Capacity Report"
	$MailMessage.Body = "Report is not generated, Please verify"
    $SmtpClient.Send($MailMessage)}