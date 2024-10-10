#### Create file in PowerShell

```
New-Item test.txt
```

#### Fins specific port

```netstat -ano | findstr :5173```

#### Kill a specific port

```taskkill /PID 552 /F```

#### Windows Logs

- Press Windows + X and select Event Viewer.
- In Event Viewer, go to Windows Logs > System.
- Look for entries with a red exclamation mark labeled as Critical or Error, which often relate to BSODs.