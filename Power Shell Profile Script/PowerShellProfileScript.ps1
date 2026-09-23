
############################################
# Ultimate Purrfessional MeowShell Profile #
############################################

# ============================================================
# 0. USER PATH CONFIGURATION
# ============================================================
#
# Change ONLY this path if the profile is moved to another
# Windows user account.
#
# Example:
#   $MeowHome = "C:\Users\UserName"
#   $MeowHome = "C:\Users\OtherUser"
#
# All other user-specific paths are derived from this variable.
# ============================================================

$MeowHome = "C:\Users\YOURNAME"

# Common user directories
$MeowConfig   = Join-Path $MeowHome ".config"
$MeowDesktop  = Join-Path $MeowHome "Desktop"
$MeowMusic    = Join-Path $MeowHome "Music"
$MeowAppData  = Join-Path $MeowHome "AppData"

# Application/configuration paths
$FastfetchConfig = Join-Path $MeowConfig "fastfetch\config.jsonc"
$MousikiConfig   = Join-Path $MeowConfig "mousiki\config.txt"

# MeowerShell music download folder
$MeowMusicFolder = Join-Path $MeowMusic "MeowerShell-yt-dlp"


############################################
# CUSTOM TAB TITLE
############################################

function Set-TerminalTitle {
    param([string]$Title)

    [Console]::Write("`e]0;$Title`a")
}

Set-TerminalTitle "MeowerShell 🐈‍⬛ stsch"


########################################################################
# 1. Force UTF-8 so icons and Nerd Fonts render properly in Admin mode #
########################################################################

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8


################################
# 2. Oh My Posh initialization #
################################

$sharedTheme = "$env:ProgramData\ohmyposh\retrowave.omp.json"

# Resolve theme path dynamically to work in System32 / Admin mode
if (-not (Test-Path $sharedTheme)) {
    $userTheme = "$env:LOCALAPPDATA\Programs\oh-my-posh\themes\retrowave.omp.json"
    $envTheme = "$env:POSH_THEMES_PATH\retrowave.omp.json"
    
    if (Test-Path $userTheme) {
        $sharedTheme = $userTheme
    }
    elseif (Test-Path $envTheme) {
        $sharedTheme = $envTheme
    }
}

$ompCache = "$env:TEMP\omp_init.ps1"

# Regenerate cache if missing or if profile/theme changed
if (-not (Test-Path $ompCache) -or 
    ((Get-Item $ompCache).LastWriteTime -lt (Get-Item $PROFILE).LastWriteTime)) {

    if (Test-Path $sharedTheme) {
        oh-my-posh init pwsh --config $sharedTheme | Out-File $ompCache -Encoding utf8
    }
    else {
        oh-my-posh init pwsh | Out-File $ompCache -Encoding utf8
    }
}

# Load the cached Oh My Posh prompt
. $ompCache


#######################################
# 3. Fastfetch execution at beginning #
#######################################

$env:POWERSHELL_VERSION = $PSVersionTable.PSVersion.ToString()

fastfetch -c $FastfetchConfig


####################################
# 4. SpeechSynth Meow and Welcome  #
####################################

# Checks if there was a boot already, so it does not speak every time it starts.
$currentBootTime = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime.ToString()

# File path in local application data
$flagFile = Join-Path $env:LOCALAPPDATA "powershell_speech_done.txt"

$shouldSpeak = $false

if (Test-Path $flagFile) {

    $lastRecordedBoot = Get-Content `
        -Path $flagFile `
        -ErrorAction SilentlyContinue
    
    # If stored boot time doesn't match current boot time,
    # it's a new boot session.
    if ($lastRecordedBoot -ne $currentBootTime) {
        $shouldSpeak = $true
    }
}
else {
    # File doesn't exist yet, run for the first time.
    $shouldSpeak = $true
}

if ($shouldSpeak) {

    # Save current boot time to the file
    Set-Content `
        -Path $flagFile `
        -Value $currentBootTime

    Start-Job -ScriptBlock {

        $phrases = @(
            "Meow, Meowmeow. Meow, MEOW!",
            "All paws operational. Hiss. Hiss.",
            "Purrr, purrr. I wish you an meowsome day!",
            "Purrfessional MeowerShell ready. Meow Meowmeow.",
            "Loading terminal, please calm your claws and wait a meowment. . . Purr.",
            "All systems operational. Meowsistance is futile. Purr!",
            "You look fur-miliar, purr. Is meow the time to party? Purr?",
            "Purrfessional Cyber-Explorer-Cat ready. Ready to climb a meowntain of code with you."
        )

        $randomPhrase = $phrases | Get-Random

        Add-Type -AssemblyName System.Speech

        $synth = New-Object System.Speech.Synthesis.SpeechSynthesizer

        $synth.SetOutputToDefaultAudioDevice()

        # Fallback safeguard in case Microsoft Zira is unavailable
        try {
            $synth.SelectVoice("Microsoft Zira Desktop")
        }
        catch {
            # Uses system default voice
        }

        $synth.Speak($randomPhrase)

    } | Out-Null
}


##############################
# 5. Manuel "say" text input #
##############################

function say {

    param(
        [string]$Text = "Meow, Meowmeow. Meow, MEOW!"
    )

    Start-Job -ScriptBlock {

        param($msg)

        Add-Type -AssemblyName System.Speech

        $synth = New-Object System.Speech.Synthesis.SpeechSynthesizer

        $synth.SetOutputToDefaultAudioDevice()

        try {
            $synth.SelectVoice("Microsoft Zira Desktop")
        }
        catch {
            # Use system default voice
        }

        $synth.Speak($msg)

    } -ArgumentList $Text | Out-Null
}


####################################
# 6. Add fuzzy search key bindings #
####################################

Import-Module PSFzf

Set-PsFzfOption `
    -PSReadlineChordProvider 'Ctrl+t' `
    -PSReadlineChordReverseHistory 'Ctrl+r'


##############################
# 7. Btop4win alias variable #
##############################

function btop {
    & "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\aristocratos.btop4win_Microsoft.Winget.Source_8wekyb3d8bbwe\btop4win\btop4win.exe"
}


###############################################################################
# 8. Remove dark background highlight for hidden/system files and directories #
###############################################################################

$PSStyle.FileInfo.Directory = "`e[34m"

# Safe fallback to prevent background color rendering on hidden files
if ($PSStyle.FileInfo.PSObject.Properties['ExtensionColors']) {
    $PSStyle.FileInfo.ExtensionColors = @{}
}


####################################################################
# 9. Custom Commands for certain programs and general informations #
####################################################################

# Open github via firefox:
function github {
    Start-Process "firefox.exe" "https://github.com/StSchwerdtfeger"
}

# A page with informations on usefuld key commands:
function key {

    $keyWidth = 20
    $descriptionWidth = 55

    $topLine =
        "┌" +
        ("─" * ($keyWidth + 2)) +
        "┬" +
        ("─" * ($descriptionWidth + 2)) +
        "┐"

    $middleLine =
        "├" +
        ("─" * ($keyWidth + 2)) +
        "┼" +
        ("─" * ($descriptionWidth + 2)) +
        "┤"

    $bottomLine =
        "└" +
        ("─" * ($keyWidth + 2)) +
        "┴" +
        ("─" * ($descriptionWidth + 2)) +
        "┘"

    $keys = @(
        @("ALT GR + ~",         "Open YAZI shortcuts overview"),
        @(".",                  "Toggle visibility of hidden files (YAZI)"),
        @("Ctrl + SHIFT + T",   "Open new terminal tab"),
        @("Ctrl + SHIFT + W",   "Close current terminal"),
        @("Ctrl + TAB",         "Switch to next tab"),
        @("Ctrl + SHIFT + TAB", "Switch to previous tab"),
        @("Ctrl + SHIFT + F",   "Search terminal output"),
        @("Ctrl + A",           "Select all"),
        @("SHIFT + ↑ / ↓",      "Select line wise"),
        @("SHIFT + ← / →",      "Select symbol wise"),
        @("Ctrl + Backspace",   "Delete last word"),
        @("Ctrl + Delete",      "Delete next word"),
        @("TAB",                "Autocomplete command"),
        @("Ctrl + C",           "Terminate process"),
        @("Ctrl + L",           "Clear visible terminal screen"),
        @("Ctrl + R",           "Search command history (fzf), ↑ / ↓ to navigate"),
        @("Ctrl + ← / →",       "Move cursor one word backward/forward"),
        @("FN + ←  or HOME",    "Move to beginning of command line"),
        @("FN + →  or END",     "Move to end of command line")
    )

    Clear-Host

    Write-Host $topLine -ForegroundColor DarkGray

    Write-Host "│ " -NoNewline -ForegroundColor DarkGray

    Write-Host `
        "KEY SHORTCUT".PadRight($keyWidth) `
        -NoNewline `
        -ForegroundColor Green

    Write-Host " │ " -NoNewline -ForegroundColor DarkGray

    Write-Host `
        "FUNCTION".PadRight($descriptionWidth) `
        -NoNewline `
        -ForegroundColor Green

    Write-Host " │" -ForegroundColor DarkGray

    Write-Host $middleLine -ForegroundColor DarkGray

    foreach ($item in $keys) {

        $key = $item[0]
        $description = $item[1]

        Write-Host "│ " -NoNewline -ForegroundColor DarkGray

        Write-Host `
            $key.PadRight($keyWidth) `
            -NoNewline `
            -ForegroundColor Yellow

        Write-Host " │ " -NoNewline -ForegroundColor DarkGray

        Write-Host `
            $description.PadRight($descriptionWidth) `
            -NoNewline `
            -ForegroundColor White

        Write-Host " │" -ForegroundColor DarkGray
    }

    Write-Host $bottomLine -ForegroundColor DarkGray

    Write-Host ""
}


###### Listen to current active ports:

function ports {

    $portWidth = 8
    $addressWidth = 24
    $pidWidth = 10
    $processWidth = 25

    $topLine =
        "┌" +
        ("─" * ($portWidth + 2)) +
        "┬" +
        ("─" * ($addressWidth + 2)) +
        "┬" +
        ("─" * ($pidWidth + 2)) +
        "┬" +
        ("─" * ($processWidth + 2)) +
        "┐"

    $middleLine =
        "├" +
        ("─" * ($portWidth + 2)) +
        "┼" +
        ("─" * ($addressWidth + 2)) +
        "┼" +
        ("─" * ($pidWidth + 2)) +
        "┼" +
        ("─" * ($processWidth + 2)) +
        "┤"

    $bottomLine =
        "└" +
        ("─" * ($portWidth + 2)) +
        "┴" +
        ("─" * ($addressWidth + 2)) +
        "┴" +
        ("─" * ($pidWidth + 2)) +
        "┴" +
        ("─" * ($processWidth + 2)) +
        "┘"

    $connections =
        Get-NetTCPConnection `
            -State Listen `
            -ErrorAction SilentlyContinue |
        Sort-Object LocalPort, LocalAddress

    $processCache = @{}

    Clear-Host

    Write-Host $topLine -ForegroundColor DarkGray

    Write-Host "│ " -NoNewline -ForegroundColor DarkGray

    Write-Host `
        "PORT".PadRight($portWidth) `
        -NoNewline `
        -ForegroundColor Green

    Write-Host " │ " -NoNewline -ForegroundColor DarkGray

    Write-Host `
        "ADDRESS".PadRight($addressWidth) `
        -NoNewline `
        -ForegroundColor Green

    Write-Host " │ " -NoNewline -ForegroundColor DarkGray

    Write-Host `
        "PID".PadRight($pidWidth) `
        -NoNewline `
        -ForegroundColor Green

    Write-Host " │ " -NoNewline -ForegroundColor DarkGray

    Write-Host `
        "PROCESS".PadRight($processWidth) `
        -NoNewline `
        -ForegroundColor Green

    Write-Host " │" -ForegroundColor DarkGray

    Write-Host $middleLine -ForegroundColor DarkGray

    foreach ($connection in $connections) {

        $port = $connection.LocalPort
        $address = $connection.LocalAddress
        $processId = $connection.OwningProcess

        if (-not $processCache.ContainsKey($processId)) {

            try {
                $processName = (
                    Get-Process `
                        -Id $processId `
                        -ErrorAction Stop
                ).ProcessName
            }
            catch {
                $processName = "Unknown"
            }

            $processCache[$processId] = $processName
        }

        $processName = $processCache[$processId]

        Write-Host "│ " -NoNewline -ForegroundColor DarkGray

        Write-Host `
            $port.ToString().PadRight($portWidth) `
            -NoNewline `
            -ForegroundColor Yellow

        Write-Host " │ " -NoNewline -ForegroundColor DarkGray

        Write-Host `
            $address.PadRight($addressWidth) `
            -NoNewline `
            -ForegroundColor White

        Write-Host " │ " -NoNewline -ForegroundColor DarkGray

        Write-Host `
            $processId.ToString().PadRight($pidWidth) `
            -NoNewline `
            -ForegroundColor Cyan

        Write-Host " │ " -NoNewline -ForegroundColor DarkGray

        Write-Host `
            $processName.PadRight($processWidth) `
            -NoNewline `
            -ForegroundColor White

        Write-Host " │" -ForegroundColor DarkGray
    }

    Write-Host $bottomLine -ForegroundColor DarkGray

    Write-Host ""

    Write-Host `
        "🐾 Listening TCP ports: $($connections.Count)" `
        -ForegroundColor Green

    Write-Host ""
}


########## Open PWSH $Profile in VSCode

function profile {
    code $PROFILE
}


######### Open PWSH Profile via notepad

function profile_note {
    notepad $PROFILE
}


# Get path of programs that are added to PATH

function which {

    param(
        [Parameter(Mandatory = $true)]
        [string]$Command
    )

    Get-Command $Command -All |
        Select-Object CommandType, Name, Source, Definition
}


# Create a directory and open it

function mkcd {

    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    New-Item `
        -ItemType Directory `
        -Path $Path `
        -Force |
        Out-Null

    Set-Location $Path
}


# Search function

function search {
    rg --hidden --glob '!.git' $args
}


# Remove built-in 'cat' alias

if (Test-Path Alias:cat) {
    Remove-Item Alias:cat -Force
}


# Create 'cat' function that wraps bat

function cat {
    bat $args
}


########## Start Yazi

function y {

    $tmp = New-TemporaryFile

    yazi $args --cwd-file="$tmp"

    if (Test-Path $tmp) {

        $cwd = Get-Content $tmp

        if ($cwd -and (Test-Path $cwd)) {
            Set-Location $cwd
        }

        Remove-Item $tmp
    }
}


########## Strudel

function strudel {

    $strudelShortcut = Join-Path `
        $MeowAppData `
        "Roaming\Microsoft\Windows\Start Menu\Programs\Chrome-Apps\Strudel REPL.lnk"

    Invoke-Item $strudelShortcut
}


########## Mousiki player

function lala {

    [Console]::Write("`e]0;💃 La-la-laaa 🕺 — stsch`a")

    $mousikiExe = Join-Path `
        $MeowHome `
        "mousiki\build\Release\mousiki.exe"

    & $mousikiExe @args
}


########## Prism - real-time audio analyzer

function prism {

    $prismPaths = @(
        "$env:LOCALAPPDATA\Programs\Prism\Prism.exe",
        "$env:LOCALAPPDATA\Prism\Prism.exe",
        "$env:ProgramFiles\Prism\Prism.exe",
        "$env:ProgramFiles\Prism Audio Analyzer\Prism.exe"
    )

    $prismExe =
        $prismPaths |
        Where-Object { Test-Path $_ } |
        Select-Object -First 1

    if ($prismExe) {
        Start-Process $prismExe
    }
    else {

        Write-Host ""
        Write-Host `
            "Prism desktop was not found." `
            -ForegroundColor Yellow

        Write-Host ""
    }
}


########### Start and stop C64 vice emulator

function c64 {

    $c64Exe = Join-Path `
        $MeowDesktop `
        "Desktop24\Workingdirec\Extra Programs\GTK3VICE-3.10-win64\GTK3VICE-3.10-win64\bin\x64sc.exe"

    Start-Process `
        $c64Exe `
        -ArgumentList "-VICIIfull"
}


function stopc64 {

    Stop-Process `
        -Name "x64sc" `
        -Force `
        -ErrorAction SilentlyContinue
}


########### Apple 1 Emulator

function apple1 {

    Push-Location

    $apple1Directory = Join-Path `
        $MeowDesktop `
        "Desktop24\Workingdirec\Extra Programs\Apple 1 Emulator\pom1"

    Set-Location $apple1Directory

    Write-Host `
        "Starting the WozMon... Exit via Ctrl + C." `
        -ForegroundColor Green

    try {

        Start-Process `
            ".\pom1.exe" `
            -NoNewWindow `
            -Wait
    }
    finally {

        Pop-Location

        Write-Host @'

################################?~-;,;~?*###############################
############################*%%+     ..:;~%#############################
##########################?-:..       ... .+############################
########################$'     ..       ....+$##########################
#######################*;                  . :~*########################
#######################=              .:;;:    =########################
#######################;     ,,.  ..  :'+=-:   :=#######################
######################%.    :=!~''--;;;~!!=~,   .?######################
######################+     ,!!=+++=+~~++~~+~:   +######################
######################!     '=~;,::,-~-,..:;~'  ,$######################
######################%    :++',.   :++: .:;~+: !#######################
######################$:   ;!=+~''''-?$+--~+!?'.%#######################
#######################+ ,:,=====+~~=?%%!~~=!!~:+#######################
#######################*:,,.'-''';;'''-~-;,;'-'.+#######################
########################~   :;;,..,,. ..::..,;:,$#######################
########################$-. ..::.::,;;'';,,....!########################
#########################$-'  ...,;;'-~~~~,. :=#########################
########################$!%=,.  ..,;;,,,;;..,!##########################
####################**$%?$*?-,.....:....:..:+!$#########################
#################*$%%%$$****!;::.  .......,'~%%$*#######################
################$$$$**$$**$**=,,:::...::,'-;~**$$$**####################
################**$$$$$$$**$**!;,,,,;,;'-~';+$****$$****################
################$$$$$$$$$****%!+';,,,,'--',-!***$$$$$$$$################
                                  WOZ
'@ -ForegroundColor Gray

        Write-Host `
            "The WozMon is signing off." `
            -ForegroundColor Green
    }
}


########### Fastfetch shortcut

function purr {

    $env:POWERSHELL_VERSION = `
        $PSVersionTable.PSVersion.ToString()

    fastfetch -c $FastfetchConfig
}


########### Purrfessional AI terminal commands

function meow-ai {

    param(
        [Parameter(
            Position = 0,
            ValueFromRemainingArguments = $true
        )]
        [string[]]$Prompt
    )

    if (-not (Get-Command ollama -ErrorAction SilentlyContinue)) {

        Write-Host ""
        Write-Host `
            "Ollama is not installed or not in PATH." `
            -ForegroundColor Yellow

        return
    }

    $model = "meow-ai"

    if ($Prompt) {

        $text = $Prompt -join " "

        ollama run $model $text
    }
    else {

        Write-Host ""
        Write-Host `
            "╔══════════════════════════════════════╗" `
            -ForegroundColor Blue

        Write-Host `
            "║     🤖 Local MeowerShell LLM 🤖      ║" `
            -ForegroundColor Green

        Write-Host `
            "╚══════════════════════════════════════╝" `
            -ForegroundColor Blue

        Write-Host ""

        ollama run $model
    }
}


########### AI Ask function

function ask {

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [string]$Question
    )

    ollama run meow-ai $Question
}


########### AI ask for code version

function coderkatze {

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [string]$Question
    )

    $psVersion = $PSVersionTable.PSVersion.ToString()

    $osVersion =
        (Get-CimInstance Win32_OperatingSystem).Caption

    $currentDirectory =
        (Get-Location).Path

    $currentUser =
        [Environment]::UserName

    $lastCommand =
        if (Get-History -Count 1) {
            (Get-History -Count 1).CommandLine
        }
        else {
            "No previous command"
        }

    $lastExitCode = $LASTEXITCODE

    if ($Error.Count -gt 0) {

        $recentErrors =
            ($Error |
                Select-Object -First 5 |
                ForEach-Object {
                    $_.ToString()
                }) -join "`n--- NEXT ERROR ---`n"
    }
    else {
        $recentErrors = "No recent PowerShell errors."
    }

    $os = Get-CimInstance Win32_OperatingSystem

    $totalMemoryGB = [math]::Round(
        $os.TotalVisibleMemorySize / 1MB,
        1
    )

    $freeMemoryGB = [math]::Round(
        $os.FreePhysicalMemory / 1MB,
        1
    )

    $usedMemoryGB = [math]::Round(
        $totalMemoryGB - $freeMemoryGB,
        1
    )

    $prompt = @"
You are Meow-AI, a local terminal assistant running inside PowerShell.

The user asked:

$Question

You have access to the following terminal context.

=== TERMINAL CONTEXT ===

PowerShell:
$psVersion

Operating System:
$osVersion

User:
$currentUser

Current Directory:
$currentDirectory

Last Command:
$lastCommand

Last Native Exit Code:
$lastExitCode

Recent PowerShell Errors:
$recentErrors

Memory:
$usedMemoryGB GB used / $totalMemoryGB GB total

=== END TERMINAL CONTEXT ===

Use the terminal context when it is relevant to the question.

IMPORTANT:
- Answer the user's actual question directly.
- Do not turn ordinary factual answers into PowerShell code.
- Use PowerShell commands only when they are actually useful.
- If the user is asking about an error, investigate the supplied errors carefully.
- If the question is unrelated to the terminal context, simply answer normally.
- Do not pretend that terminal context proves something it does not.
- If information is missing, say so.
- Keep the answer concise and technically accurate.
"@

    Write-Host ""
    Write-Host `
        "🐾 Meow-AI is checking the terminal..." `
        -ForegroundColor Cyan

    Write-Host ""

    ollama run `
        jikepjikep_16HEX/gemma-4-4b-nightshift-heretic-uncensored-q6:latest `
        $prompt
}


# Debugging and code explainer AI

function explain {

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [string]$Text
    )

    $prompt = @"
Explain the following clearly and concisely.
If it is a command, explain what each important part does.

$Text
"@

    ollama run meow-ai $prompt
}


# Investigate errors

function why {

    if (-not $Error) {

        Write-Host `
            "🐾 No recent errors to investigate. Purr." `
            -ForegroundColor DarkGray

        return
    }

    Write-Host ""

    Write-Host `
        "🐾 Investigating the crime scene..." `
        -ForegroundColor Yellow

    Write-Host ""

    $recentErrors =
        $Error |
        Select-Object -First 5

    $errorText =
        ($recentErrors |
            ForEach-Object {
                $_.ToString()
            }) -join "`n`n--- NEXT ERROR ---`n`n"

    $prompt = @"
You are analyzing recent PowerShell errors.

Below are the 5 most recent errors, newest first.

$errorText

For each error:
1. Identify what happened.
2. Explain the likely cause.
3. Give a practical fix if possible.

Then provide a short summary of whether the errors appear related.

Keep the explanation concise and technically accurate.
"@

    ollama run meow-ai $prompt
}


# Reload whole MeowerShell

function reload {

    Write-Host ""

    Write-Host `
        "🐾 Re-loading MeowerShell..." `
        -ForegroundColor Cyan

    try {

        . $PROFILE

        Write-Host ""

        Write-Host `
            "✓ Profile reloaded successfully." `
            -ForegroundColor Green

        Write-Host `
            "🐈 Purr. Everything is back online." `
            -ForegroundColor Yellow
    }
    catch {

        Write-Host ""

        Write-Host `
            "💥 Meow! Something went wrong while reloading." `
            -ForegroundColor Red

        Write-Host `
            $_.Exception.Message `
            -ForegroundColor Yellow
    }
}


#####################################################
# 10. Download Songs/Playlists from URL using yt-dlp
#####################################################

# MeowerShell music folder:
$MeowMusicFolder = Join-Path `
    $MeowMusic `
    "MeowerShell-yt-dlp"


######### Single song download

function down_song {

    param (
        [Parameter(Mandatory = $true)]
        [string]$Url
    )

    if (-not (Test-Path $MeowMusicFolder)) {

        New-Item `
            -ItemType Directory `
            -Path $MeowMusicFolder `
            -Force |
            Out-Null
    }

    $outputTemplate =
        Join-Path `
            $MeowMusicFolder `
            "%(title)s.%(ext)s"

    yt-dlp `
        --no-playlist `
        --extract-audio `
        --audio-format mp3 `
        --audio-quality 0 `
        --no-overwrites `
        -o $outputTemplate `
        $Url
}


######### Function for playlist downloads

function down_playlist {

    param (
        [Parameter(Mandatory = $true)]
        [string]$Url
    )

    if (-not (Test-Path $MeowMusicFolder)) {

        New-Item `
            -ItemType Directory `
            -Path $MeowMusicFolder `
            -Force |
            Out-Null
    }

    $outputTemplate =
        Join-Path `
            $MeowMusicFolder `
            "%(title)s.%(ext)s"

    $archive =
        Join-Path `
            $MeowMusicFolder `
            "downloaded_history.txt"

    yt-dlp `
        --cookies-from-browser firefox `
        --download-archive $archive `
        --format "bestaudio/best" `
        --extract-audio `
        --audio-format mp3 `
        --audio-quality 0 `
        --no-overwrites `
        -o $outputTemplate `
        $Url
}

# Function that opens Metatogger 
function tags {
    Start-Process "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Metatogger 7.7.lnk"
}


###############################################################################
# 11. Gum Interface for menu command
###############################################################################

function menu {

    if (-not (Get-Command gum -ErrorAction SilentlyContinue)) {

        Write-Host ""

        Write-Host `
            "Gum is not installed." `
            -ForegroundColor Yellow

        Write-Host `
            "Install it with:" `
            -ForegroundColor Gray

        Write-Host `
            "  winget install charmbracelet.gum" `
            -ForegroundColor Cyan

        return
    }

    while ($true) {

        Clear-Host

        gum style `
            --border double `
            --border-foreground 90 `
            --align center `
            --padding "1 2" `
            --margin "1 0" `
            ">> MEOOOW!!! <<" `
            "Purrfessional MeowerShell" `
            "Commands À-La-Carte:"

        $category = gum choose `
            --cursor "❯ " `
            --header "Choose your destiny:" `
            "💾 Files" `
            "🕵️ System Surveillance" `
            "🪕 Music" `
            "👾 Programming Languages (REPL)" `
            "🕹  Retro Computing" `
            "🐗 Terminal-Fun" `
            "😿 Quit"

        if (-not $category) {
            continue
        }

        switch -Wildcard ($category) {

            "*Files" {

                $choice = gum choose `
                    --cursor "❯ " `
                    --header "Messing around with files..." `
                    "Yazi" `
                    "VS Code" `
                    "Open Current Folder" `
                    "Back"

                switch ($choice) {

                    "Yazi" {
                        y
                    }

                    "VS Code" {
                        code .
                    }

                    "Open Current Folder" {
                        explorer.exe .
                    }
                }
            }


            "*System Surveillance" {

                $choice = gum choose `
                    --cursor "❯ " `
                    --header "System Purrveillance 👾" `
                    "All Commands (List-Menu)" `
                    "Fastfetch - Config" `
                    "Mousiki - Config" `
                    "MeowerShell Pawdiologist" `
                    "btop" `
                    "Back"

                switch ($choice) {

                    "All Commands (List-Menu)" {
                        commands
                    }

                    "Fastfetch - Config" {
                        code $FastfetchConfig
                    }

                    "Mousiki - Config" {
                        code $MousikiConfig
                    }

                    "MeowerShell Pawdiologist" {
                        doctor -FromMenu
                    }

                    "btop" {
                        btop
                    }
                }
            }


            "*Music" {

                $choice = gum choose `
                    --cursor "❯ " `
                    --header "Mewoooow 🎻🎵🥁 Meow, meoooowww 🎸🎵🎹" `
                    "Mousiki-Lala" `
                    "Prism Spectrogram" `
                    "Download Song" `
                    "Download Playlist" `
                    "Strudel-REPL" `
                    "Back"

                switch ($choice) {

                    "Mousiki-Lala" {
                        lala
                    }

                    "Prism Spectrogram" {
                        prism
                    }

                    "Download Song" {

                        $url = gum input `
                            --placeholder "Paste song URL"

                        if ($url) {
                            down_song $url
                        }
                    }

                    "Download Playlist" {

                        $url = gum input `
                            --placeholder "Paste playlist URL"

                        if ($url) {
                            down_playlist $url
                        }
                    }

                    "Strudel-REPL" {
                        strudel
                    }
                }
            }


            "*Programming Languages (REPL)" {

                $choice = gum choose `
                    --cursor "❯ " `
                    --header "Purrfessional REPL's..." `
                    "R" `
                    "Julia" `
                    "Python" `
                    "Back"

                switch ($choice) {

                    "R" {
                        R.exe
                    }

                    "Julia" {
                        julia
                    }

                    "Python" {
                        python
                    }
                }
            }


            "*Retro Computing" {

                $choice = gum choose `
                    --cursor "❯ " `
                    --header "Run Ancient Code..." `
                    "C64" `
                    "Apple 1 Emulator" `
                    "Back"

                switch ($choice) {

                    "C64" {
                        c64
                    }

                    "Apple 1 Emulator" {
                        apple1
                    }
                }
            }


            "*Terminal-Fun" {

                $choice = gum choose `
                    --cursor "❯ " `
                    --header "Whoopin' Terminal 🐗🤪🌈🙃" `
                    "Say something..." `
                    "Neo / Matrix" `
                    "Purrfessional LLM" `
                    "Back"

                switch ($choice) {

                    "Say something..." {

                        $message = gum input `
                            --placeholder "Type something for the cat..."

                        if ($message) {
                            say $message
                        }
                    }

                    "Neo / Matrix" {
                        neo
                    }

                    "Purrfessional LLM" {
                        meow-ai
                    }
                }
            }


            "*Quit" {

                Clear-Host

                purr

                return
            }
        }
    }
}


############################
# 12. Conda initialisation #
############################

function conda-init {

    if (-not (Get-Command conda -ErrorAction SilentlyContinue)) {

        $conda =
            Join-Path `
                $HOME `
                "miniconda3\Scripts\conda.exe"

        if (-not (Test-Path $conda)) {

            Write-Host `
                "Conda was not found at $conda" `
                -ForegroundColor Yellow

            return
        }

        Write-Host `
            "Initializing Conda..." `
            -ForegroundColor DarkGray

        (& $conda shell.powershell hook) |
            Out-String |
            Invoke-Expression
    }
}


###########################################################################################
# 13. Function with interactive list of all current commands
###########################################################################################

function commands {

    $commandWidth = 17
    $functionWidth = 73

    $pageSize = 21

    $commandSectionWidth = $commandWidth + 2
    $functionSectionWidth = $functionWidth + 3

    $topLine =
        "┌" +
        ("─" * $commandSectionWidth) +
        "┬" +
        ("─" * $functionSectionWidth) +
        "┐"

    $middleLine =
        "├" +
        ("─" * $commandSectionWidth) +
        "┼" +
        ("─" * $functionSectionWidth) +
        "┤"

    $bottomLine =
        "└" +
        ("─" * $commandSectionWidth) +
        "┴" +
        ("─" * $functionSectionWidth) +
        "┘"

    $commands = @(
        @("key",           'List of useful shortcut key commands'),
        @("github",        'Command to open github via firefox'),
        @("neo",           'Matrix rain shell screensaver'),
        @("say",           'Load speech synthesizer via ``say "YOUR TEXT HERE"``'),
        @("c64",           'Open Vice c64 Emulator'),
        @("apple1",        'Open pom1 Apple 1 Emulator'),
        @("strudel",       'Open Strudel REPL'),
        @("btop",          'Open Btop for System Surveillance'),
        @("ports",         'Displays listening TCP ports and their owning processes'),
        @("lala",          'Open Mousiki music player'),
        @("prism",         'Open Music visualizer (spectogram etc.)'),
        @("down_song",     'Download song via yt-dlp using ``down_song "url"``'),
        @("down_playlist", 'Download playlist via yt-dlp using ``down_playlist "url"``'),
        @("tags",          'Open Metatogger app for finding / editing artist + title of tracks'),
        @("y",             'Open Yazi terminal file manager'),
        @("menu",          'Open Gum custom menu'),
        @("chafa",         'Use chafa via ``chafa "path"``'),
        @("purr",          'Reload fastfetch screen'),
        @("reload",        'Reload MeowerShell'),
        @("ask",           'Ask meow-ai directly in the terminal via ``ask "Your question"``'),
        @("coderkatze",    'Ask informed meow-ai on code via ``coderkatze "Your question"``'),
        @("why",           'Ask meow-ai for AI explanation via ``why`` (checks all recent errors)'),
        @("explain",       'Ask meow-ai to explain code'),
        @("profile",       'Opens MeowerShell profile via VSCode'),
        @("profile_note",  'Opens MeowerShell profile via Notepad'),
        @("which",         'Returns path of programs'),
        @("mkcd",          'Create new directory / path'),
        @("search",        'Search current directory (similar grep)'),
        @("cat",           'Opens files in PWSH via bat'),
        @("commands",      'Open this list of MeowerShell commands'),
        @("doctor",        'Check if all applications are operational')
    )

    $currentPage = 0
    $selectedIndex = 0

    $pageCount = [Math]::Ceiling(
        $commands.Count / [double]$pageSize
    )

    $commandStartRow = 3

    function Get-PageStart {
        return ($currentPage * $pageSize)
    }

    function Get-PageEnd {

        $start = Get-PageStart

        return [Math]::Min(
            $start + $pageSize - 1,
            $commands.Count - 1
        )
    }

    function Show-CommandRow {

        param(
            [int]$Index,
            [int]$Row,
            [bool]$Selected
        )

        $command = $commands[$Index][0]
        $description = $commands[$Index][1]

        if ($Selected) {

            $commandText = ("❯ " + $command).PadRight($commandWidth)
            $commandColor = "Yellow"
        }
        else {

            $commandText = ("  " + $command).PadRight($commandWidth)
            $commandColor = "Magenta"
        }

        $descriptionText =
            $description.PadRight($functionWidth)

        [Console]::SetCursorPosition(
            0,
            $commandStartRow + $Row
        )

        Write-Host `
            "│ " `
            -NoNewline `
            -ForegroundColor DarkGray

        Write-Host `
            $commandText `
            -NoNewline `
            -ForegroundColor $commandColor

        Write-Host `
            " │  " `
            -NoNewline `
            -ForegroundColor DarkGray

        Write-Host `
            $descriptionText `
            -NoNewline `
            -ForegroundColor White

        Write-Host `
            " │" `
            -ForegroundColor DarkGray
    }

    function Show-CommandTable {

        Clear-Host

        $pageStart = Get-PageStart
        $pageEnd = Get-PageEnd

        Write-Host `
            $topLine `
            -ForegroundColor DarkGray

        Write-Host `
            "│ " `
            -NoNewline `
            -ForegroundColor DarkGray

        Write-Host `
            "COMMAND".PadRight($commandWidth) `
            -NoNewline `
            -ForegroundColor Green

        Write-Host `
            " │  " `
            -NoNewline `
            -ForegroundColor DarkGray

        Write-Host `
            "FUNCTION".PadRight($functionWidth) `
            -NoNewline `
            -ForegroundColor Green

        Write-Host `
            " │" `
            -ForegroundColor DarkGray

        Write-Host `
            $middleLine `
            -ForegroundColor DarkGray

        $row = 0

        for (
            $i = $pageStart;
            $i -le $pageEnd;
            $i++
        ) {

            Show-CommandRow `
                -Index $i `
                -Row $row `
                -Selected ($i -eq $selectedIndex)

            $row++
        }

        Write-Host `
            $bottomLine `
            -ForegroundColor DarkGray

        Write-Host `
            "↑↓ " `
            -NoNewline `
            -ForegroundColor Cyan

        Write-Host `
            "Navigate  " `
            -NoNewline `
            -ForegroundColor DarkGray

        Write-Host `
            "Tab " `
            -NoNewline `
            -ForegroundColor Cyan

        Write-Host `
            "Next Page  " `
            -NoNewline `
            -ForegroundColor DarkGray

        Write-Host `
            "Shift+Tab " `
            -NoNewline `
            -ForegroundColor Cyan

        Write-Host `
            "Previous Page  " `
            -NoNewline `
            -ForegroundColor DarkGray

        Write-Host `
            "Enter " `
            -NoNewline `
            -ForegroundColor Cyan

        Write-Host `
            "Execute  " `
            -NoNewline `
            -ForegroundColor DarkGray

        Write-Host `
            "Esc " `
            -NoNewline `
            -ForegroundColor Cyan

        Write-Host `
            "Exit" `
            -ForegroundColor DarkGray

        Write-Host ""

        Write-Host `
            ("Page {0}/{1}  |  Commands {2}-{3} of {4}" -f `
                ($currentPage + 1),
                $pageCount,
                ($pageStart + 1),
                ($pageEnd + 1),
                $commands.Count
            ) `
            -ForegroundColor DarkGray
    }

    function Invoke-SelectedCommand {

        $selected = $commands[$selectedIndex][0]

        $pageStart = Get-PageStart
        $pageEnd = Get-PageEnd
        $pageRows = $pageEnd - $pageStart + 1

        [Console]::SetCursorPosition(
            0,
            $commandStartRow + $pageRows + 3
        )

        switch ($selected) {

            "say" {

                Write-Host ""

                $text = Read-Host `
                    "🐾 Enter something for the cat"

                if ($text) {
                    say $text
                }
            }

            "down_song" {

                Write-Host ""

                $url = Read-Host `
                    "🎵 Enter song URL"

                if ($url) {
                    down_song $url
                }
            }

            "down_playlist" {

                Write-Host ""

                $url = Read-Host `
                    "🎵 Enter playlist URL"

                if ($url) {
                    down_playlist $url
                }
            }

            "chafa" {

                Write-Host ""

                $path = Read-Host `
                    "🖼️ Enter image path"

                if ($path) {
                    chafa $path
                }
            }

            "ask" {

                Write-Host ""

                $question = Read-Host `
                    "🤖 Ask Meow-AI"

                if ($question) {
                    ask $question
                }
            }

            "coderkatze" {

                Write-Host ""

                $question = Read-Host `
                    "🐈‍⬛ Ask Coderkatze"

                if ($question) {
                    coderkatze $question
                }
            }

            "explain" {

                Write-Host ""

                $question = Read-Host `
                    "🧠 Enter code or command to explain"

                if ($question) {
                    explain $question
                }
            }

            "commands" {

                Write-Host ""

                Write-Host `
                    "🐾 You are already looking at the MeowerShell command center. Purr." `
                    -ForegroundColor Yellow

                Start-Sleep -Milliseconds 1200
            }

            default {
                & $selected
            }
        }
    }

    Show-CommandTable

    while ($true) {

        $key = [Console]::ReadKey($true)

        switch ($key.Key) {

            "UpArrow" {

                $pageStart = Get-PageStart
                $pageEnd = Get-PageEnd

                $oldIndex = $selectedIndex

                if ($selectedIndex -gt $pageStart) {
                    $selectedIndex--
                }
                else {
                    $selectedIndex = $pageEnd
                }

                $oldRow = $oldIndex - $pageStart
                $newRow = $selectedIndex - $pageStart

                Show-CommandRow `
                    -Index $oldIndex `
                    -Row $oldRow `
                    -Selected $false

                Show-CommandRow `
                    -Index $selectedIndex `
                    -Row $newRow `
                    -Selected $true
            }


            "DownArrow" {

                $pageStart = Get-PageStart
                $pageEnd = Get-PageEnd

                $oldIndex = $selectedIndex

                if ($selectedIndex -lt $pageEnd) {
                    $selectedIndex++
                }
                else {
                    $selectedIndex = $pageStart
                }

                $oldRow = $oldIndex - $pageStart
                $newRow = $selectedIndex - $pageStart

                Show-CommandRow `
                    -Index $oldIndex `
                    -Row $oldRow `
                    -Selected $false

                Show-CommandRow `
                    -Index $selectedIndex `
                    -Row $newRow `
                    -Selected $true
            }


            "Tab" {

                if ($key.Modifiers -band [ConsoleModifiers]::Shift) {

                    if ($currentPage -gt 0) {
                        $currentPage--
                    }
                    else {
                        $currentPage = $pageCount - 1
                    }
                }
                else {

                    if ($currentPage -lt ($pageCount - 1)) {
                        $currentPage++
                    }
                    else {
                        $currentPage = 0
                    }
                }

                $selectedIndex = Get-PageStart

                Show-CommandTable
            }


            "Enter" {

                if ($commands[$selectedIndex][0] -eq "commands") {

                    Invoke-SelectedCommand

                    Show-CommandTable

                    continue
                }

                Invoke-SelectedCommand

                return
            }


            "Escape" {

                Clear-Host

                purr

                return
            }
        }
    }
}


################################################################
# 14. MeowerShell System Doctor Standalone diagnostic function #
################################################################

function doctor {

    param(
        [switch]$FromMenu
    )

    Clear-Host

    $results =
        [System.Collections.Generic.List[object]]::new()


    #####################################################
    # Helper: Test command
    #####################################################

    function Test-MeowCommand {

        param(
            [string]$Name,
            [string]$Command,
            [string]$Description
        )

        if (Get-Command $Command -ErrorAction SilentlyContinue) {

            $results.Add(
                [PSCustomObject]@{
                    Name   = $Name
                    Status = "OK"
                    Detail = $Description
                }
            )
        }
        else {

            $results.Add(
                [PSCustomObject]@{
                    Name   = $Name
                    Status = "FAIL"
                    Detail = "$Command not found"
                }
            )
        }
    }


    #####################################################
    # Helper: Test path
    #####################################################

    function Test-MeowPath {

        param(
            [string]$Name,
            [string]$Path,
            [string]$Description
        )

        if (Test-Path -LiteralPath $Path) {

            $results.Add(
                [PSCustomObject]@{
                    Name   = $Name
                    Status = "OK"
                    Detail = $Description
                }
            )
        }
        else {

            $results.Add(
                [PSCustomObject]@{
                    Name   = $Name
                    Status = "FAIL"
                    Detail = "Not found: $Path"
                }
            )
        }
    }


    #####################################################
    # CORE SHELL
    #####################################################

    Test-MeowCommand `
        -Name "PowerShell" `
        -Command "pwsh" `
        -Description "PowerShell $($PSVersionTable.PSVersion)"

    Test-MeowCommand `
        -Name "Oh My Posh" `
        -Command "oh-my-posh" `
        -Description "Prompt engine available"

    Test-MeowPath `
        -Name "Oh My Posh Theme" `
        -Path $sharedTheme `
        -Description "Retrowave theme found"

    Test-MeowCommand `
        -Name "Fastfetch" `
        -Command "fastfetch" `
        -Description "System information available"

    Test-MeowPath `
        -Name "Fastfetch Config" `
        -Path $FastfetchConfig `
        -Description "Fastfetch configuration found"


    #####################################################
    # TERMINAL TOOLS
    #####################################################

    Test-MeowCommand `
        -Name "fzf" `
        -Command "fzf" `
        -Description "Fuzzy finder available"

    Test-MeowCommand `
        -Name "Gum" `
        -Command "gum" `
        -Description "Charm Gum available"

    Test-MeowCommand `
        -Name "Yazi" `
        -Command "yazi" `
        -Description "Terminal file manager available"

    Test-MeowCommand `
        -Name "Chafa" `
        -Command "chafa" `
        -Description "Terminal image renderer available"


    #####################################################
    # BTOP
    #####################################################

    $btopPath =
        "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\aristocratos.btop4win_Microsoft.Winget.Source_8wekyb3d8bbwe\btop4win\btop4win.exe"

    Test-MeowPath `
        -Name "btop" `
        -Path $btopPath `
        -Description "btop4win executable found"


    #####################################################
    # AI / OLLAMA
    #####################################################

    Test-MeowCommand `
        -Name "Ollama" `
        -Command "ollama" `
        -Description "Local AI runtime available"

    $meowAIModel =
        "jikepjikep_16HEX/gemma-4-4b-nightshift-heretic-uncensored-q6:latest"

    if (Get-Command ollama -ErrorAction SilentlyContinue) {

        $modelList = ollama list 2>$null

        if ($modelList -match [regex]::Escape($meowAIModel)) {

            $results.Add(
                [PSCustomObject]@{
                    Name   = "Meow-AI Model"
                    Status = "OK"
                    Detail = "Gemma Nightshift model available"
                }
            )
        }
        else {

            $results.Add(
                [PSCustomObject]@{
                    Name   = "Meow-AI Model"
                    Status = "FAIL"
                    Detail = "Required model not found"
                }
            )
        }
    }
    else {

        $results.Add(
            [PSCustomObject]@{
                Name   = "Meow-AI Model"
                Status = "FAIL"
                Detail = "Ollama unavailable"
            }
        )
    }


    #####################################################
    # MUSIC
    #####################################################

    Test-MeowCommand `
        -Name "yt-dlp" `
        -Command "yt-dlp" `
        -Description "Media downloader available"

    Test-MeowPath `
        -Name "MeowerShell Music Folder" `
        -Path $MeowMusicFolder `
        -Description "Download directory available"

    $mousikiExe =
        Join-Path `
            $MeowHome `
            "mousiki\build\Release\mousiki.exe"

    Test-MeowPath `
        -Name "Mousiki" `
        -Path $mousikiExe `
        -Description "Mousiki executable found"


    #####################################################
    # PRISM AUDIO ANALYZER
    #####################################################

    $prismPaths = @(
        "$env:LOCALAPPDATA\Programs\Prism\Prism.exe",
        "$env:LOCALAPPDATA\Prism\Prism.exe",
        "$env:ProgramFiles\Prism\Prism.exe",
        "$env:ProgramFiles\Prism Audio Analyzer\Prism.exe"
    )

    $prismFound =
        $prismPaths |
        Where-Object {
            Test-Path -LiteralPath $_
        } |
        Select-Object -First 1

    if ($prismFound) {

        $results.Add(
            [PSCustomObject]@{
                Name   = "Prism"
                Status = "OK"
                Detail = "Audio analyzer found"
            }
        )
    }
    else {

        $results.Add(
            [PSCustomObject]@{
                Name   = "Prism"
                Status = "FAIL"
                Detail = "Prism.exe not found"
            }
        )
    }


    #####################################################
    # RETRO COMPUTING
    #####################################################

    $c64Exe =
        Join-Path `
            $MeowDesktop `
            "Desktop24\Workingdirec\Extra Programs\GTK3VICE-3.10-win64\GTK3VICE-3.10-win64\bin\x64sc.exe"

    Test-MeowPath `
        -Name "C64 / VICE" `
        -Path $c64Exe `
        -Description "VICE C64 emulator found"


    $apple1Exe =
        Join-Path `
            $MeowDesktop `
            "Desktop24\Workingdirec\Extra Programs\Apple 1 Emulator\pom1\pom1.exe"

    Test-MeowPath `
        -Name "Apple 1 / WozMon" `
        -Path $apple1Exe `
        -Description "Apple 1 emulator found"


    #####################################################
    # PROGRAMMING LANGUAGES
    #####################################################

    Test-MeowCommand `
        -Name "Python" `
        -Command "python" `
        -Description "Python interpreter available"

    Test-MeowCommand `
        -Name "R" `
        -Command "R.exe" `
        -Description "R interpreter available"

    Test-MeowCommand `
        -Name "Julia" `
        -Command "julia" `
        -Description "Julia interpreter available"


    #####################################################
    # EXTERNAL APPLICATIONS
    #####################################################

    Test-MeowCommand `
        -Name "VS Code" `
        -Command "code" `
        -Description "Visual Studio Code CLI available"


    $strudelShortcut =
        Join-Path `
            $MeowAppData `
            "Roaming\Microsoft\Windows\Start Menu\Programs\Chrome-Apps\Strudel REPL.lnk"

    Test-MeowPath `
        -Name "Strudel REPL" `
        -Path $strudelShortcut `
        -Description "Strudel shortcut found"


    #####################################################
    # POWERSHELL PROFILE
    #####################################################

    Test-MeowPath `
        -Name "PowerShell Profile" `
        -Path $PROFILE `
        -Description "Profile file found"


    #####################################################
    # DISPLAY HEADER
    #####################################################

    Write-Host ""

    Write-Host `
        "╔════════════════════════════════════════════════════════════╗" `
        -ForegroundColor DarkGray

    Write-Host `
        "║               🐾 MEOWERSHELL PAWDIOLOGIST 🐾               ║" `
        -ForegroundColor Cyan

    Write-Host `
        "╠════════════════════════════════════════════════════════════╣" `
        -ForegroundColor DarkGray

    Write-Host `
        "║  Running system diagnostics...                             ║" `
        -ForegroundColor White

    Write-Host `
        "╚════════════════════════════════════════════════════════════╝" `
        -ForegroundColor DarkGray

    Write-Host ""


    #####################################################
    # DISPLAY RESULTS
    #####################################################

    foreach ($result in $results) {

        if ($result.Status -eq "OK") {

            $symbol = "✓"
            $color = "Green"
        }
        else {

            $symbol = "✗"
            $color = "Red"
        }

        Write-Host `
            "  $symbol " `
            -NoNewline `
            -ForegroundColor $color

        Write-Host `
            ("{0,-24}" -f $result.Name) `
            -NoNewline `
            -ForegroundColor White

        Write-Host `
            $result.Detail `
            -ForegroundColor DarkGray
    }


    #####################################################
    # SUMMARY
    #####################################################

    $total = $results.Count

    $passed = @(
        $results |
        Where-Object {
            $_.Status -eq "OK"
        }
    ).Count

    $failed = $total - $passed

    Write-Host ""

    Write-Host `
        "────────────────────────────────────────────────────────────" `
        -ForegroundColor DarkGray

    if ($failed -eq 0) {

        Write-Host ""

        Write-Host `
            "  ✓ $passed / $total systems operational." `
            -ForegroundColor Green

        Write-Host ""

        Write-Host `
            "  🐈 Diagnosis: All paws operational. Purr." `
            -ForegroundColor Yellow
    }
    else {

        Write-Host ""

        Write-Host `
            "  ⚠ $passed / $total systems operational." `
            -ForegroundColor Yellow

        Write-Host `
            "  ✗ $failed system(s) need attention." `
            -ForegroundColor Red

        Write-Host ""

        Write-Host `
            "  🐾 Diagnosis: We have a few suspicious-looking litter boxes." `
            -ForegroundColor Yellow
    }


    #####################################################
    # RETURN TO MENU PAUSE
    #####################################################

    if ($FromMenu) {

        Write-Host ""

        Write-Host `
            "Press any key to return to the main menu..." `
            -ForegroundColor DarkGray

        [void][Console]::ReadKey($true)
    }

    Write-Host ""
}

