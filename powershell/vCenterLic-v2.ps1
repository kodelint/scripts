###########################################################################
#
# NAME: vCenterLic-v2.ps1
#
# AUTHOR: Satyajit Roy
#
# COMMENT: Get the lic deatils from all ESX Servers
#
# VERSION HISTORY:
# 1.0 12/6/2013 - Initial release
#
###########################################################################
# Variables
#$DCs = ('vc001.example.com', 'vc002.example.com', 'vc003.example.com')
#Foreach ($DC in $DCs){
$filename="C:\tmp\vCenterLic-v1.csv"
#Connect-VIServer $DC -User username -Password Password
Connect-VIServer VC1 -User powercli -Password Password
$ServiceInstance=Get-View ServiceInstance
$LicenseMan=Get-View $ServiceInstance.Content.LicenseManager
$vSphereLicInfo= @()
Foreach ($License in $LicenseMan.Licenses){
   $Details="" |Select Name, Key, Total, Used,Information
   $Details.Name=$License.Name
   $Details.Key=$License.LicenseKey
   $Details.Total=$License.Total
   $Details.Used=$License.Used
   $Details.Information=$License.Labels |Select -Expand value
   $vSphereLicInfo+=$Details
}
$vSphereLicInfo |Select Name, Key, Total, Used,Information | Export-Csv -NoTypeInformation $filename

IF ($Report -ne ""){
    $SmtpClient = New-Object system.net.mail.smtpClient
    $SmtpClient.host = "smtp001.example.com"   #Change to a SMTP server in your environment
    $MailMessage = New-Object system.net.mail.mailmessage
	$MailAttachment = New-Object system.Net.Mail.Attachment($filename)
    $MailMessage.from = "System.Automation@example.com"   #Change to email address you want emails to be coming from
    $MailMessage.To.add("admin@example.com")    #Change to email address you would like to receive emails.
    $MailMessage.IsBodyHtml = 1
    $MailMessage.Subject = "VMware Datastore Licenses Report"
	$MailMessage.Attachments.Add($MailAttachment)
    $MailMessage.Body = "This is vCenter Licenses Report from $DC"
    $SmtpClient.Send($MailMessage)}
	# Terminating any connections with DCs
	Disconnect-VIServer -Server $DC -Confirm:$false
#}