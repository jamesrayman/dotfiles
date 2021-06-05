function prompt {
    $currentDirectory = $(Get-Location)

    write-host "$(Convert-Path $currentDirectory)" -NoNewline -ForegroundColor Cyan
    write-host ">" -NoNewline
    return " "
}

Set-PSReadlineOption -BellStyle None
Set-PSReadlineKeyHandler -Key Tab -Function Complete

