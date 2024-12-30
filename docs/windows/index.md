#### Create file in PowerShell

```
New-Item test.txt
```

#### tree

```
tree /f
```

#### Fins specific port

```netstat -ano | findstr :5173```

#### Kill a specific port

```taskkill /PID 552 /F```

#### Check For Ram problems

- Press Windows + S or click on the Start Menu and type Windows Memory Diagnostic.

#### Windows Logs

- Press Windows + X and select Event Viewer.
- In Event Viewer, go to Windows Logs > System.
- Look for entries with a red exclamation mark labeled as Critical or Error, which often relate to BSODs.

#### Power Shell

##### Check Execution Policy

```
Get-ExecutionPolicy
```

##### Set Execution Policy (turn off security)

```
Set-ExecutionPolicy Unrestricted -Scope CurrentUser
```

##### Set Execution Policy (safer - use this as default)

```
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

##### Set Execution Policy (safest)

```
Set-ExecutionPolicy Restricted -Scope CurrentUser
```