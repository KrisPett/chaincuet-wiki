magick input.webp output.png

### Powershell

```
Get-ChildItem *.webp | ForEach-Object {
    $inputFile = $_.FullName
    $outputFile = [System.IO.Path]::ChangeExtension($inputFile, ".png")
    magick "$inputFile" "$outputFile"
}
```