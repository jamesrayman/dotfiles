Set-PSReadlineOption -Color @{
    "Command" = [ConsoleColor]::Yellow
    "Parameter" = [ConsoleColor]::Gray
    "Operator" = [ConsoleColor]::Magenta
    "Variable" = [ConsoleColor]::Green
    "String" = [ConsoleColor]::White
    "Number" = [ConsoleColor]::Blue
    "Type" = [ConsoleColor]::Cyan
    "Comment" = [ConsoleColor]::Blue
}

function prompt {
    $currentDirectory = $(Get-Location)

    write-host "$(Convert-Path $currentDirectory)" -NoNewline -ForegroundColor Cyan
    write-host ">" -NoNewline
    return " "
}

Set-PSReadlineOption -BellStyle None
Set-PSReadlineKeyHandler -Key Tab -Function Complete
