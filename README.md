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



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-neptuneos">About NeptuneOS</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- GETTING STARTED -->
## Getting Started

This is a guide on how to install NeptuneOS.

YOU are fully responsible for whatever happens to your system during your time using NeptuneOS

### Prerequisites
Download your ethernet drivers prior to installing NeptuneOS.
Common vendors are provided, but you might want to download prior to installation, just incase.
* [Realtek](https://www.realtek.com/en/component/zoo/category/network-interface-controllers-10-100-1000m-gigabit-ethernet-pci-express-software)
* [Intel](https://www.intel.com/content/www/us/en/download/18293/intel-network-adapter-driver-for-windows-10.html)

You MUST begin with a clean, stock installation of [Windows 10](https://software.download.prss.microsoft.com/dbazure/Win10_22H2_English_x64v1.iso?t=4d3f143d-ad29-4ef9-9c11-01e5a05e4490&P1=1708674319&P2=601&P3=2&P4=XEiEzOFWipK4ADtywT65EOd8TFNm9SL3ZfS6NH3psbPlqdHpvR%2fzbyeCTEk0Of93BMgcLXlKGR%2bUFrRy7tYAFsOphGMe4kI4KIjWmRPW%2fF%2fZV%2bQV99%2fxoRgYwMe95Cm9fVd6uSJOQHdjjdZf1ZjKZzqBjr3l75PPCiEDnDOfqJg1bAD43gRY5YtQzKX%2bk9w9u7OboeYdZFYyODYj%2bX2mgorwGKL09g9rmVsbLPTtq1WbgIuBc%2f2wUha40ZrDdGZl%2bTFIGGWjDkS3sFK1q8WuHCZsZAiNrM9t99bzJkBojhKZfXnHTuDBl%2fsloMFq6wNWr2hrOBqqzDgP8%2fkBEwDCdQ%3d%3d) or [Windows 11](https://software.download.prss.microsoft.com/dbazure/Win11_23H2_English_x64v2.iso?t=fe1f1d84-93e9-4075-b990-fae3286c5d0a&P1=1708674270&P2=601&P3=2&P4=gLCT1py3ZHRfVXlYg08SMuwTAQjdoDxXO7u%2bVy1ZMzYifznomP4v1%2b3DXi0JV5nVFvjzLeIA37bZqep6%2bQ%2fJzGut6msOWqnk8i8poe%2ffUVnEgR1sttPWuMxXXIg19cFin%2b8AozjuZw7xJxR33cZ3EmnyU5S0T8abvxN5h8jJ6MdGPByeWOpDzVgBRhV%2fNFhES5pAlx9pPqd2XTPFVwf1F%2bGysOd3al1Isjyb41NejFK3Ldfy0S7ES%2bzAJ77R%2bF6g7MM9lxAqBhU38imtnvsZAiChJOTN32U%2bBDMrVI9ikaREhP4jNGOXEgnY86WLdu9LuOBtpS9dDYoKNoEGu4frig%3d%3d) Pro. 

If you don't know how to install Windows, please follow [This Guide](https://www.youtube.com/watch?v=0s23L1m7u5I)
If you do not have a USB drive, please follow [This Guide](https://github.com/iidanL/InstallWindowsWithoutUSB)

IF you are choosing Windows 10, at any point during the OS installation, please disconnect your ethernet cable if you have one. This is to avoid using a Microsoft Account when setting up Windows.

During the Windows Setup, please select "no" or "don't allow" for any cortana prompts it asks you.

IF you are on Windows 10, once you reach the network screen, please select "I don't have internet" in the bottom left to proceed with a local account setup.
On Windows 11, please enter "gg@gmail.com" and "gg" for the email and password to prompt you with an error that will allow you to proceed with a local account setup.

From there, please unselect all of the toggles on screen.

Once you reach the desktop, press Win+R on your keyboard to open the run prompt, type in CMD and hit enter.
Paste in this command `powershell Invoke-WebRequest -Uri 'https://github.com/NyneDZN/NeptuneOS/archive/refs/heads/installer.zip' -OutFile "$env:TEMP\installer.zip"; Expand-Archive -Path "$env:TEMP\installer.zip" -DestinationPath 'C:\'; Start-Process 'C:\NeptuneOS-installer\Neptune\neptune.bat'
` and follow the instructions to finish installing NeptuneOS.


<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ABOUT NEPTUNEOS -->
## About NeptuneOS

NeptuneOS is a tailored version of Windows that prioritizes optimal performance and minimal latency, all while preserving seamless compatibility with standard Windows applications and functions. 
By fine-tuning system settings and configurations, it aims to deliver a superior user experience for those seeking peak performance without sacrificing compatibility.
                                       
This project is a fork of AtlasOS.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap

- [x] NeptuneOS
   - [x] Windows 10 Branch   
      - [ ] 1803
      - [X] 22H2                             
   - [x] Windows 11 Branch
      - [X] 23H2
      - [X] Canary (24H2)
   - [x] PowerShell Command
                               
- [ ] Complete the Discord
   - [ ] Channels
      - [x] NeptuneOS Category
   - [ ] Roles
   - [X] WebHooks
                                       
- [ ] Complete the GitHub
   - [ ] README.md
   - [ ] Wiki
   - [ ] Benchmarks

See the [open issues](https://github.com/NyneDZN/NeptuneOS/issues) for a full list of proposed features (and known issues).

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
