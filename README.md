# Microsoft PowerPoint Media Playback Troubleshooter

Created by **Dewald Pretorius**.

The repository includes the original diagnostics and a guarded `Repair.ps1` helper.

Supported actions are `Diagnose`, `ResetOfficeCache`, and `StartAudioService`.

```powershell
.\Repair.ps1 -Action Diagnose
.\Repair.ps1 -Action ResetOfficeCache -WhatIf
.\Repair.ps1 -Action StartAudioService -Confirm
```

Close PowerPoint before resetting its cache. Existing cache data is preserved as a timestamped backup. Source-reviewed for PowerShell 5.1; not runtime-tested against every application build.
