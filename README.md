<h1 align="center">Purrfessional Meower Shell 🐈‍⬛</h1>

<p align="center">
  <em>PowerShell • Cyberpunk • Retrowave • New Cat Just Dropped • Anything Is Pawssible</em>
</p>

<br>

<p align="center">
  Config files for my Shell/Terminal setup (in my case PowerShell 7.6.6), making use of packages such as gum, Oh My Posh, Fastfetch, a Nerd Font and many more, including loads of custom functions.
  <br><br>
  This is not a package with an installer or so, just an inspiration to use or copy code from my configuration files.
  For example, I created a lot of PowerShell functions to e.g. open retro emulators, such as pom1 for Apple 1 emulation.
  <br><br>
  I didn't generalize the <code>profile.ps1</code>, except for replacing all <code>C:\Users\YOURNAME\</code> paths at the beginning, which makes it easier to include functions into your own profile.
  The initialization of Oh My Posh and FastFetch is handled at the beginning of the PowerShell profile script and set to work also in admin mode.
</p>

<br>

<p align="center">
  <strong>👾 🐈 💾 Have a meowsome time setting up your own cyberpunk / retrowave themed MeowerShell terminal!!!! 🐈‍⬛ 🤖 👾</strong>
</p>

<br>

<hr>

<h2 align="center">Terminal Start Screen</h2>

<p align="center">
  <em>FastFetch + Oh My Posh</em>
</p>

<p align="center">
  <img width="1675" height="825" alt="MeowerShell terminal start screen" src="https://github.com/user-attachments/assets/d976fc04-4250-43a4-9dcf-6dac0b12a4cf" />
</p>

<p>
  For the above I used
  <a href="https://github.com/fastfetch-cli/fastfetch">FastFetch</a>
  (see <code>fastfetch/config.json</code> for details on this specific setup)
  in combination with
  <a href="https://ohmyposh.dev/">Oh My Posh</a>
  using a customized
  <a href="https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json">JanDeDobbeleer theme</a>
  (customized version in this repo) and
  <a href="https://www.nerdfonts.com/font-downloads">CaskaydiaCoveNerdFont</a>.
  The font is not included in this repo since the files are too big; it is needed to display icons, emojis, symbols etc. in the terminal.
</p>

<br>

<h2>PowerShell Profile Script</h2>

<p>
  The PowerShell script is highly customized. It includes the following functions and tweaks.
</p>

<h3>Setting up general home and common paths</h3>

<p>
  First of all, the home path can be defined at the beginning, as well as some commonly used paths.
  In my case these include the default Music folder, AppData, .config (for FastFetch and Mousiki music player)...
</p>

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

<h3>Basic applications that ease the use of the terminal</h3>

<p>
  The following applications are installed:
</p>

| Application | Function                                                                                                             |
| :---------- | :------------------------------------------------------------------------------------------------------------------- |
| **Yazi**    | Super fast file explorer including preview of images, .txt, PDF files...                                              |
| **fzf**     | Fuzzy search engine, bound to Ctrl + R                                                                               |
| **bat**     | An alternative to cat that fully shows text-based files in the terminal; function that overrides bat to cat included |
| **btop**    | A kind of retro-looking task manager inside your terminal                                                            |

<p>
  Install e.g. via WinGet in the PowerShell 7.6.6 terminal:
</p>

```PowerShell
winget install sxyazi.yazi
winget install junegunn.fzf
winget install sharkdp.bat
winget install btop
```

<p>Or all at once:</p>

```PowerShell
winget install sxyazi.yazi junegunn.fzf sharkdp.bat btop
```

<p align="center">
  <img width="578" alt="Customized btop screen" src="https://github.com/user-attachments/assets/91288491-24be-41ce-b524-3d6b10bda566" />
</p>

<p align="center">
  <em>Customized btop screen</em>
</p>

<br>

<h3>Text-to-Speech synthesizer &amp; greetings from MeowerShell cat</h3>

<p>
  The scripts also include a text-to-speech synthesizer command <code>say</code>, in my case using Microsoft Zira.
  You might have to download the model; in Windows 11 (probably similar in Windows 10) it can be done in
  <strong>Settings → Time &amp; Language → Speech language → Voices</strong>.
</p>

<p>
  The PWSH profile also includes the following tweak: the first time after booting your computer and opening your terminal,
  the speech synthesizer will greet you, choosing randomly from a list of possible expressions.
</p>

<p>Currently those are:</p>

```text
"Meow, Meowmeow. Meow, MEOW!"
"All paws operational. Hiss. Hiss."
"Purrr, purrr. I wish you an meowsome day!"
"Purrfessional MeowerShell ready. Meow Meowmeow."
"Loading terminal, please calm your claws and wait a meowment. . . Purr."
"All systems operational. Meowsistance is futile. Purr!"
"You look fur-miliar, purr. Is meow the time to party? Purr?"
"Purrfessional Cyber-Explorer-Cat ready. Ready to climb a meowntain of code with you."
```

<br>

<h3>Custom tab title for the Windows Terminal application</h3>

<p>
  The standard custom tab title is set in the Oh My Posh theme file <code>retrowave.omp.json</code>.
</p>

```JSON
"console_title_template": "MeowerShell 🐈‍⬛ — {{ .Folder }}",
```

<p>
  The PWSH script also includes a line such that PWSH has control over the title.
  This is done in order to change the title, e.g. for Mousiki TUI (terminal user interface) music player app...
</p>

```PowerShell
function Set-TerminalTitle {
    param([string]$Title)
    [Console]::Write("`e]0;$Title`a")
}

Set-TerminalTitle "MeowerShell 🐈‍⬛ stsch"
```

<br>

<h3>Custom commands, programs, menus &amp; information screens</h3>

<p>
  A lot of functions included in the script define shell commands to e.g. open a program or certain files.
  Below you can take a look at the <code>profile</code> function that opens the PowerShell profile script in VSCode.
  There is also a command called <code>profile_note</code> which opens the profile via Notepad/editor app.
</p>

```PowerShell
function profile {
    code $PROFILE
}
```

<p>
  Not all functions are that simple and are optimized to fix some quirks of the terminal UI.
  I used AI to get rid of some bugs, so you may want to check yourself what and why certain functions are written the way they are.
  Since the profile script has ~2400 lines of code and this repo is just an inspiration, I will not go through the whole code.
  Just dig in yourself and take what you need. Meow!
</p>

<h4>Some generally useful functions</h4>

| Command    | Function                                                                   |
| :--------- | :------------------------------------------------------------------------- |
| **purr**   | Reloads FastFetch screen                                                   |
| **reload** | Reloads whole terminal window (and indirectly FastFetch)                   |
| **mkcd**   | Linux-style command to create a new directory                              |
| **search** | Search current directory                                                   |
| **which**  | Returns path of programs that are included in the Windows PATH environment |

<br>

<p>
  Functions that open programs include the mentioned Apple 1 emulator
  <a href="https://pom1.sourceforge.net/">pom1</a>,
  Vice emulator for
  <a href="https://vice-emu.sourceforge.io/index.html#download">C64</a>,
  the application
  <a href="https://astramusic.dev/prism/">prism</a>
  for a real-time spectrogram of currently running audio,
  the terminal graphics editor
  <a href="https://hpjansson.org/chafa/">chafa</a>,
  Strudel REPL (a code-based music maker) and the beautiful music player Mousiki.
  <br><br>
  In my GitHub profile you will find a forked repository which
  <a href="https://github.com/StSchwerdtfeger/Mousiki-Windows-Port">ported Mousiki to also work on Windows</a>,
  since it was written for Linux/macOS by itzender5820
  (see <a href="https://github.com/itzender5820/mousiki">original Mousiki repo here</a>).
</p>

<p align="center">
  <img width="2337" height="1179" alt="Mousiki configuration" src="https://github.com/user-attachments/assets/56f6b213-60c9-40b9-970c-4dc22fccfca8" />
</p>

<p align="center">
  <em>Current Mousiki configuration (.config can be found in this repo)</em>
</p>

<br>

<h4>Ollama AI integration</h4>

<p>
  I also included several functions that include Ollama AI in the terminal.
  Most of the functions rely on the ModelFile of meow-ai (pre-prompt for a serious cat personality)
  and have some additional prompts. The ModelFile is included in this repository.
</p>

| Command        | Specific Function                                                                   |
| :------------- | :---------------------------------------------------------------------------------- |
| **meow-ai**    | Opens a separate TUI created via gum (see further below) to talk to an Ollama model |
| **ask**        | Function that allows to talk to meow-ai in the terminal prompt line                 |
| **coderkatze** | AI that is fetched with certain system information                                  |
| **explain**    | AI that is pre-prompted to answer questions on PWSH commands                        |
| **why**        | AI that needs no input and is informed on previous error output                     |

<br>

<h4>Gum menus</h4>

<p>
  There is a function called <code>menu</code> that uses
  <a href="https://github.com/charmbracelet/gum">gum</a>,
  a tool "for glamorous shell scripts" that makes it possible to create menu screens and much more that I didn't make use of.
</p>

<p>Install gum e.g. via:</p>

```PowerShell
winget install charmbracelet.gum
```

<p>
  There are a lot of other ways to create TUI menus.
  Here is an image of the <code>commands</code> function, which provides an interactive list of all commands included in the script
  (except <code>neo</code>, which is an extra software package that creates Matrix-style rain of letters).
</p>

<p align="center">
  <img width="1891" height="1052" alt="MeowerShell commands menu" src="https://github.com/user-attachments/assets/8181e600-9437-4b6e-9f79-43f1af6ecb8a" />
</p>

<p align="center">
  <img width="1887" height="564" alt="MeowerShell commands menu" src="https://github.com/user-attachments/assets/0c333bd6-0a71-4430-ae85-f343ae09a0c9" />
</p>

<p>
  I also created a <code>menu</code> command that shows a lot of commands while including categorized sub-pages.
  It also lists commands to open the REPL of Python, R and Julia...
</p>

<p align="center">
  <img width="362" height="363" alt="MeowerShell categorized menu" src="https://github.com/user-attachments/assets/a625d543-1c2c-4e61-b8b8-fd7a7fee9db0" />
</p>

<br>

<h4>Other information functions</h4>

<p>
  <strong>a) <code>key</code></strong> — listing some useful key shortcuts / commands
</p>

<p align="center">
  <img width="792" height="425" alt="Key shortcuts screen" src="https://github.com/user-attachments/assets/b95a92ec-403c-4703-8ae4-468f97ac93f0" />
</p>

<p>
  <strong>b) <code>doctor</code></strong> — where a Pawdiologist checks if certain important files are available
</p>

<p align="center">
  <img width="619" height="679" alt="MeowerShell doctor screen" src="https://github.com/user-attachments/assets/2af38a53-c74f-4707-b6d8-47be17c8b769" />
</p>

<p>
  <strong>c) <code>ports</code></strong> — which lists currently listening TCP ports
</p>

<p align="center">
  <img width="538" height="389" alt="Listening TCP ports" src="https://github.com/user-attachments/assets/9d84f86e-ca23-4c0e-8e22-f76b5af007d9" />
</p>

<br>

<hr>

<h2 align="center">
  👾 🐈 💾 <strong>Have fun further exploring the MeowerShell! Anything is pawssible!!</strong> 🐈‍⬛ 🤖 👾
</h2>
