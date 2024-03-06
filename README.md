<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/NyneDZN/NeptuneOS">
    <img src="https://user-images.githubusercontent.com/120980797/209248113-fb446909-8aad-4c90-bedf-d4d536ef5dee.png"
" alt="Logo" width="500" height="500">
  </a>

<h3 align="center">NepuneOS</h3>

  <p align="center">
    A custom windows OS designed for productivity and gaming.
    <br />
    <a href="https://github.com/NyneDZN/NeptuneOS"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/NyneDZN/NeptuneOS">View Demo</a>
    ·
    <a href="https://github.com/NyneDZN/NeptuneOS/issues">Report Bug</a>
    ·
    <a href="https://github.com/NyneDZN/NeptuneOS/issues">Request Feature</a>
  </p>
</div>



<!-- Installation -->
## Getting Started with NeptuneOS Installation 🌊

Welcome to the NeptuneOS installation guide! Below are step-by-step instructions to help you set up NeptuneOS on your system. Remember, you are solely responsible for any actions taken on your system during the installation process.

### Prerequisites 🛠️

Before you begin, make sure you have the following:

- A clean, stock installation of [Windows 10](https://software.download.prss.microsoft.com/dbazure/Win10_22H2_English_x64v1.iso?t=4d3f143d-ad29-4ef9-9c11-01e5a05e4490&P1=1708674319&P2=601&P3=2&P4=XEiEzOFWipK4ADtywT65EOd8TFNm9SL3ZfS6NH3psbPlqdHpvR%2fzbyeCTEk0Of93BMgcLXlKGR%2bUFrRy7tYAFsOphGMe4kI4KIjWmRPW%2fF%2fZV%2bQV99%2fxoRgYwMe95Cm9fVd6uSJOQHdjjdZf1ZjKZzqBjr3l75PPCiEDnDOfqJg1bAD43gRY5YtQzKX%2bk9w9u7OboeYdZFYyODYj%2bX2mgorwGKL09g9rmVsbLPTtq1WbgIuBc%2f2wUha40ZrDdGZl%2bTFIGGWjDkS3sFK1q8WuHCZsZAiNrM9t99bzJkBojhKZfXnHTuDBl%2fsloMFq6wNWr2hrOBqqzDgP8%2fkBEwDCdQ%3d%3d) or [Windows 11](https://software.download.prss.microsoft.com/dbazure/Win11_23H2_English_x64v2.iso?t=fe1f1d84-93e9-4075-b990-fae3286c5d0a&P1=1708674270&P2=601&P3=2&P4=gLCT1py3ZHRfVXlYg08SMuwTAQjdoDxXO7u%2bVy1ZMzYifznomP4v1%2b3DXi0JV5nVFvjzLeIA37bZqep6%2bQ%2fJzGut6msOWqnk8i8poe%2ffUVnEgR1sttPWuMxXXIg19cFin%2b8AozjuZw7xJxR33cZ3EmnyU5S0T8abvxN5h8jJ6MdGPByeWOpDzVgBRhV%2fNFhES5pAlx9pPqd2XTPFVwf1F%2bGysOd3al1Isjyb41NejFK3Ldfy0S7ES%2bzAJ77R%2bF6g7MM9lxAqBhU38imtnvsZAiChJOTN32U%2bBDMrVI9ikaREhP4jNGOXEgnY86WLdu9LuOBtpS9dDYoKNoEGu4frig%3d%3d) Pro.
- A USB drive (optional but recommended).

- It is also very important to backup any files you want to keep because they will be formatted.

### Installation Steps 🚀

1. **Preparation**: Download the [batch file](https://cdn.discordapp.com/attachments/1096471308239376517/1210133893995303013/neptune_currentbranch.bat?ex=65e97403&is=65d6ff03&hm=9e0356dc3d1558f7492625d81251a3346197dcba747a89f6eaa99b46783fe6c4&) containing the PowerShell installation command. There is an alternative, but this is recommended.

2. **Initial Windows Setup**:
   - If you're unfamiliar with installing Windows, watch [this guide](https://www.youtube.com/watch?v=0s23L1m7u5I).
   - If you don't have a USB drive, follow [this guide](https://github.com/iidanL/InstallWindowsWithoutUSB).
   - If you used the USB method, please move the batch file containing the powershell command to the drive.
   - IF you used the non-USB method, please come back to this page after you installed Windows, and follow Step 4.3.

3. **Windows OOBE**:
   - For Windows 10: Disconnect your Ethernet cable during installation to skip using a Microsoft Account.
   - During setup, choose "no" or "don't allow" for any Cortana prompts.
   - For Windows 10: When prompted for network connection, select "I don't have internet" for a local account setup.
   - For Windows 11: Enter "gg@gmail.com" and "gg" for email and password to trigger an error, allowing local account setup.

4. **NeptuneOS Installation**:
   - After reaching the desktop, type open up the Windows Security app, click 'Virus & Threat Protection' and disable 'Real Time Protection'
   - After you have disabled Real Time Protection, you may move the batch file you placed onto your USB drive to your desktop, and proceed with running it.
   - Alternatively, if you used the non-USB method, and didn't download the batch file, you can open the run prompt with Win+R and open 'cmd', and run this command.
     ```powershell
     powershell Invoke-WebRequest -Uri 'https://github.com/NyneDZN/NeptuneOS/archive/refs/heads/installer.zip' -OutFile "$env:TEMP\installer.zip"; Expand-Archive -Path "$env:TEMP\installer.zip" -DestinationPath 'C:\'; Start-Process 'C:\NeptuneOS-installer\Neptune\neptune.bat'
     ```
   - Follow the on-screen instructions to complete the NeptuneOS installation process.




<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ABOUT NEPTUNEOS -->
## About NeptuneOS

NeptuneOS is a tailored version of Windows that prioritizes optimal performance and minimal latency, all while preserving seamless compatibility with standard Windows applications and functions. 
By fine-tuning system settings and configurations, it aims to deliver a superior user experience for those seeking peak performance without sacrificing compatibility.
                                       
This project is a fork of AtlasOS.

<p align="right">(<a href="#readme-top">back to top</a>)</p>




<!-- CONTACT -->
## Contact

Your Name - [@NyneDZN](https://twitter.com/NyneDZN) 

Project Link: [https://github.com/NyneDZN/NeptuneOS](https://github.com/NyneDZN/NeptuneOS)

Discord: nyne.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* [Melody's Tweaks](https://sites.google.com/view/melodystweaks/basictweaks?pli=1)
* [Optimization Guide by supermanZ (Very Outdated)](https://steamcommunity.com/sharedfiles/filedetails/?id=476760198)
* [Atlas](https://github.com/Atlas-OS/)
* [N1ko](https://n1kobg.blogspot.com/)

<p align="right">(<a href="#readme-top">back to top</a>)</p>
