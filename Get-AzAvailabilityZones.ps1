$ErrorActionPreference = "stop"
function global:Get-AzAvailabilityZones {
    $skus = Get-AzComputeResourceSku
    $az = $skus | Where-Object { $_.ResourceType -eq "virtualMachines"} | Select-Object @{Label="Location"; Expression={$_.LocationInfo.Location}}, @{Label="Zones"; Expression={$_.LocationInfo.Zones -join ","}} | Sort-Object Location, Zones -Unique
    $locations = $az | Select-Object Location -Unique
    
    $azCheckList = New-Object System.Collections.ArrayList
    $locations | ForEach-Object {
        $location = $_.Location
    
        $flag = $false
        $az | Where-Object { $_.Location -eq $location} | ForEach-Object {
            if ([string]::IsNullOrEmpty($_.Zones) -eq $false){
                $flag = $true
            }
        }
    
        $tmp = @{
            "Location" = $location
            "AvailabilityZone" = $flag
        }
    
        $azCheckList.Add($tmp) | Out-Null
    }
    
    return ($azCheckList | ConvertTo-Json | ConvertFrom-Json | Select-Object Location, AvailabilityZone)
}
