##### Alias For PowerShell

- Need to enable script execution in PowerShell (less secure)
- C:\Users\Kris\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

```
Set-Alias mouse 'python "C:\Users\user\scripts\move_mouse_circle.py"'
```

##### Alias For CMD
- Create file aliases.cmd
- ```reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_EXPAND_SZ /d "%"USERPROFILE"%\aliases.cmd" /f```
- Computer\HKEY_CURRENT_USER\Software\Microsoft\Command Processor\AutoRun

```
@echo off
doskey mouse=python "C:\Users\user\scripts\move_mouse_circle.py"
```