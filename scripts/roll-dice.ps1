param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Expression,

    [Parameter(Position = 1)]
    [string]$Label
)

$ErrorActionPreference = "Stop"

$normalized = $Expression.ToLowerInvariant() -replace '\s+', ''
$match = [regex]::Match($normalized, '^(\d+)d(\d+)([+-]\d+)?$')

if (-not $match.Success) {
    Write-Error "Invalid dice expression. Use NdM, NdM+K, or NdM-K, such as 2d6 or 2d6+2."
}

$count = [int]$match.Groups[1].Value
$sides = [int]$match.Groups[2].Value
$modifier = 0

if ($match.Groups[3].Success) {
    $modifier = [int]$match.Groups[3].Value
}

if ($count -lt 1 -or $sides -lt 1) {
    Write-Error "Dice count and side count must be positive integers."
}

$rolls = for ($i = 0; $i -lt $count; $i++) {
    Get-Random -Minimum 1 -Maximum ($sides + 1)
}

$subtotal = ($rolls | Measure-Object -Sum).Sum
$total = $subtotal + $modifier

if ($Label) {
    Write-Output "Label: $Label"
}

Write-Output "Expression: $Expression"
Write-Output ("Rolls: " + ($rolls -join ", "))
Write-Output "Modifier: $modifier"
Write-Output "Total: $total"
