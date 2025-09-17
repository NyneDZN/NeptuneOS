param([string]$JsonFile, [string]$OutFile)

$json = Get-Content $JsonFile -Raw | ConvertFrom-Json

foreach ($section in $json.PSObject.Properties) {
    if ($section.Value -is [System.Management.Automation.PSObject]) {
        foreach ($item in $section.Value.PSObject.Properties) {
            "set {0}_{1}={2}" -f $section.Name, $item.Name, $item.Value | Out-File -FilePath $OutFile -Append -Encoding ascii
        }
    }
    else {
        "set {0}={1}" -f $section.Name, $section.Value | Out-File -FilePath $OutFile -Append -Encoding ascii
    }
}