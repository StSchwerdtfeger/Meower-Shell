<h1 align="center">Purrfessional Meower Shell 🐈‍⬛</h1>

<br>

<p align="center">
Config files for my Shell/Terminal setup (in my case PowerShell 7.6.6), making use of packages such as gum, oh my posh, fastfetch, a nerd font and many more, including loads of custom functions. This is not a package with an installer or so, just an inspiration to use or copy code from my configuration files... For example, I created a lot of PowerShell functions to e.g. open retro emulators, such as pom1 for Apple 1 emulation... I didn't generalize the profile.ps1, except of replacing all ``C:\Users\YOURNAME\`` paths at the beginning, which makes it easier to include functions into your own profile. Keep that in mind... The initialization of Oh My Posh and FastFetch is handled at the beginning of the PowerShell profile script and set to work also in admin mode...
</p>

<br>


<p align="center">
<strong> 👾 🐈 💾 However, have a meowsome time setting up your own cyberpunk / retrowave themed MeowerShell terminal! Anything is pawssible!!! 🐈‍⬛ 🤖 👾<strong>
</p>
<br>

<h1 align="center">Terminal Start Screen (FastFetch and Oh-My-Posh)</h1>

<img width="1675" height="825" alt="grafik" src="https://github.com/user-attachments/assets/d976fc04-4250-43a4-9dcf-6dac0b12a4cf" />

<br>

For the above I used [FastFetch](https://github.com/fastfetch-cli/fastfetch) (see `fastfetch/config.json` for details on this specific setup) in combination with [Oh My Posh](https://ohmyposh.dev/) using a customized [JanDeDobbeleer theme](https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json) (customized version in this repo) and [CaskaydiaCoveNerdFont](https://www.nerdfonts.com/font-downloads) (not included in this repo, since files are too big; needed to display icons, emojis, symbols etc. in the terminal).

<br>


# PowerShell Profile Script

The PowerShell Script is highly customized. It includes the following functions and tweaks. 

## Setting up general home and common paths

First of all, the home path can be defined at the beginning, as well as some commonly used paths. In my case these include default Music folder,AppData, .config (for FastFetch and Mousiki music player)...

```PowerShell
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
```
<br>


## Basic applications that ease the use of the terminal

The following applications are installed: 
| Application | Function |
| :--- | :--- |
| **Yazi** | Super fat file explorer including preview of images, .txt, pdf files... |
| **fzf** | Fuzzy search engine, binded to Ctrl + R |
| **bat** | An alternative to cat that fully shows text base files in the terminal; function that overrides bat to cat included |
| **b4top** | A kind of retro looking task manager inside your terminal |

<br>

Install e.g. via WinGet in the PowerShell 7.6.6 terminal:
```PowerShell
winget install sxyazi.yazi
winget install junegunn.fzf
winget install sharkdp.bat
winget install btop
```
Or all three at once:
```PowerShell
winget install sxyazi.yazi junegunn.fzf sharkdp.bat btop
```
<br>

Here is an image of my customized btop screen:

<img width="578" alt="grafik" src="https://github.com/user-attachments/assets/91288491-24be-41ce-b524-3d6b10bda566" />

<br>

## Text-to-Speech synthesizer command and greetings from MeowerShell cat

The scripts also includes a text-to-speech synthesizer command ``say``, in my case using Microsoft Zira. You might have to download the model; in Win11 (probably similar in Win10) it can be done in Settings -> Time & Language -> Speech language -> Voices. 
The PWSH profile also includes the following tweak: The first time after booting your computer and opening your terminal, the speech synthesizer will greet you, choosing randomly from a list of possible expression. 
Currently those are:
```
                            "Meow, Meowmeow. Meow, MEOW!"
                            "All paws operational. Hiss. Hiss."
                            "Purrr, purrr. I wish you an meowsome day!"
                            "Purrfessional MeowerShell ready. Meow Meowmeow."
                            "Loading terminal, please calm your claws and wait a meowment. . . Purr.",
                            "All systems operational. Meowsistance is futile. Purr!"
                            "You look fur-miliar, purr. Is meow the time to party? Purr?"
                            "Purrfessional Cyber-Explorer-Cat ready. Ready to climb a meowntain of code with you."
```
<br>

## Custom tab title for the Windows terminal application 

The standard custom tab title is set in Oh-my-posh theme file retrowave.omp.json. 
```JSON
"console_title_template": "MeowerShell 🐈‍⬛ — {{ .Folder }}",
```
The PWSH script also includes a line such that PWSH has control over the title. This is done in order to change the title, e.g. for Mousiki TUI (terminal user interfacer) music player app...
```PowerShell
function Set-TerminalTitle {
    param([string]$Title)
    [Console]::Write("`e]0;$Title`a")
}
Set-TerminalTitle "MeowerShell 🐈‍⬛ stsch"
```

<br>

## Custom commands for certain programs and menus and information screens using gum

A lot of functions included in the script define shell commands to e.g. open a program or certain files. Below you can take a look at the ``profile`` function that opens the PowerShell profile script in VSCode. There also a command called ``profile_note`` which opens the profile via notepad/editor app.
```PowerShell
function profile {
    code $PROFILE
}
```
Not all functions are that simple and are optimized to fix some quirks of the terminal UI. I used AI to get rid of some bugs, so you may want to check yourself what and why certain functions are written the way they are. Since the profile script has ~2400 lines of code and this repo is just an inspiration, I will not go through the whole code. Just dig in yourself and take what you need. Meow! 

<br>

Some generally useful functions I added are the following:
| Command | Function |
| :--- | :--- |
| **purr** | reloads FastFetch screen |
| **reload** | Reloads whole terminal window (and indirectly FastFetch |
| **mkcd** | Linux style command to create a new directory |
| **search** | Search current directory |
| **which** | Returns path of programs that are included in the Windows PATH environment |

<br>

Functions that open programs include the mentioned Apple 1 emulator [pom1](https://pom1.sourceforge.net/), Vice emulator for [C64](https://vice-emu.sourceforge.io/index.html#download), the application [prism](https://astramusic.dev/prism/) for a real time spectrogram of currently running audio, the terninal graphics editor [chafa](https://hpjansson.org/chafa/), Strudel REPl (a code based music maker) and the beautiful music player Mousiki. In my github profile you will find a forked repository which [ported Mousiki to also work on windows](https://github.com/StSchwerdtfeger/Mousiki-Windows-Port), since it was written for Linux/macOS by itzender5820 (see [original Mousiki repo here](https://github.com/itzender5820/mousiki)). 
Below is an image of my current Mousiki configuration (.config can be found in this repo).

<img width="2337" height="1179" alt="grafik" src="https://github.com/user-attachments/assets/56f6b213-60c9-40b9-970c-4dc22fccfca8" />

<br>
<br>

I also included several functions that include Ollama AI to the terminal. Most of the functions rely on the ModelFile of meow-ai (pre-promt for a serious cat personality) and have some additional prompts. The ModelFile is included in this repository. 

| Command | Specific Function |
| :--- | :--- |
| **meow-ai** | Opens a separate TUI created via gum (see further below) to talk to an Ollama model |
| **ask** | Function that allows to talk to meow-ai in the terminal prompt line |
| **coderkatze** | AI that is fetched with certain system information |
| **explain** | AI that is pre-prompted to answer questions on PWSH commands |
| **why** | AI that needs not input and is informed on previous error output |

<br>

There is a function called ``menu`` that use gum, a tool ["for glamorous shell scripts"](https://github.com/charmbracelet/gum) that makes it possible to create menu screens and much more I didn't make use of.
Install gum e.g. via:
```PowerShell
winget install charmbracelet.gum
```
<br>
<br>

There are alot other ways to create TUI menus. Here is an image of menu of the ``commands`` function which was written via gum. I lists all commands that are included in the script (except of neo, which is an extra software that creates matrix style rain of letters).

<img width="1891" height="1052" alt="grafik" src="https://github.com/user-attachments/assets/8181e600-9437-4b6e-9f79-43f1af6ecb8a" />

<img width="1887" height="564" alt="grafik" src="https://github.com/user-attachments/assets/0c333bd6-0a71-4430-ae85-f343ae09a0c9" />

<br>

I also created a ``menu`` command that also shows a lot of commands, but includes categorized sub-pages. It also lists commands to open the REPL of Python, R and Julia...

<img width="362" height="363" alt="grafik" src="https://github.com/user-attachments/assets/a625d543-1c2c-4e61-b8b8-fd7a7fee9db0" />

<br>
<br>

Other functions that inform on certain questions
a) ``key`` listing some useful key shortcuts / commands 

<img width="792" height="425" alt="grafik" src="https://github.com/user-attachments/assets/b95a92ec-403c-4703-8ae4-468f97ac93f0" />

<br>

b) ``doctor``, where a Pawdiologist checks if certain important file are available

<img width="619" height="679" alt="grafik" src="https://github.com/user-attachments/assets/2af38a53-c74f-4707-b6d8-47be17c8b769" />

<br>

c) ``ports``  which listens to currently running TCP ports...

<img width="538" height="389" alt="grafik" src="https://github.com/user-attachments/assets/9d84f86e-ca23-4c0e-8e22-f76b5af007d9" />

<br>

<h2 align="center">
  👾 🐈 💾 <strong>Have fun further exploring the MeowerShell! Anything is pawssible!!</strong> 🐈‍⬛ 🤖 👾
</h2>



 



