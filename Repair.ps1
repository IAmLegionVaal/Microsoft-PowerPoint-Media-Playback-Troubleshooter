#requires -Version 5.1
<# Created by Dewald Pretorius. #>
[CmdletBinding(SupportsShouldProcess=$true)]
param([ValidateSet('Diagnose','ResetOfficeCache','StartAudioService')][string]$Action='Diagnose',[string]$OutputPath=(Join-Path ([Environment]::GetFolderPath('Desktop')) 'PowerPoint_Media_Repair'))
$ErrorActionPreference='Stop';$cachePath="$env:LOCALAPPDATA\Microsoft\Office\16.0\OfficeFileCache"
New-Item -ItemType Directory -Path $OutputPath -Force|Out-Null;$stamp=Get-Date -Format yyyyMMdd_HHmmss;$log=Join-Path $OutputPath "Repair_$stamp.log";function Log($m){$l='{0:u} {1}'-f(Get-Date),$m;Write-Host $l;Add-Content $log $l}
[ordered]@{Action=$Action;PowerPointRunning=[bool](Get-Process POWERPNT -ErrorAction SilentlyContinue);AudioService=(Get-Service Audiosrv -ErrorAction SilentlyContinue|Select-Object Name,Status,StartType);CacheExists=(Test-Path $cachePath)}|ConvertTo-Json|Set-Content (Join-Path $OutputPath "PreRepair_$stamp.json")
if($Action -eq 'Diagnose'){Log '[COMPLETE] Snapshot saved.';exit 0}
try{if($Action -eq 'ResetOfficeCache' -and $PSCmdlet.ShouldProcess($cachePath,'Back up and reset Office cache')){if(Get-Process POWERPNT -ErrorAction SilentlyContinue){throw 'Close PowerPoint before resetting the cache.'};if(Test-Path $cachePath){$backup="$cachePath.backup-$stamp";Move-Item $cachePath $backup -Force;New-Item -ItemType Directory $cachePath -Force|Out-Null;Log "[BACKUP] $backup"}}
elseif($Action -eq 'StartAudioService' -and $PSCmdlet.ShouldProcess('Windows Audio','Start if stopped')){$svc=Get-Service Audiosrv;if($svc.Status -eq 'Stopped'){Start-Service Audiosrv};Start-Sleep 2;if((Get-Service Audiosrv).Status -ne 'Running'){throw 'Windows Audio is not running.'}}}catch{Log "[FAILED] $($_.Exception.Message)";exit 5};Log '[COMPLETE] Repair completed.';exit 0
