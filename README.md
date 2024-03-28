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
    <a href="https://github.com/NyneDZN/NeptuneOS/wiki"><strong>Explore the wiki »</strong></a>
    <br />
    <br />
    <a href="https://github.com/NyneDZN/NeptuneOS/issues">Report Bug</a>
    ·
    <a href="https://github.com/NyneDZN/NeptuneOS/discussions">Request Feature</a>
    ·
    <a href="https://discord.gg/4YTSkcK8b8">Discord Server</a>
  </p>
</div>




<!-- COMPATIBILITY -->
## Windows Version Compatibility
Installing <b>NeptuneOS</b> on any other winver may result in issues.

- [x] Windows 10
  - [ ] 1803
  - [ ] 1809
  - [x] 21H2
  - [x] 22H2
- [x] Windows 11
  - [x] 22H2
  - [x] 23H2
  - [ ] 24H2 Canary
- [ ] Windows Server
  - [ ] 2022


<!-- GETTING STARTED -->
## Getting Started
<style>
    ol {
        padding-left: 20px;
    }

    ol ol {
        padding-left: 40px;
    }
</style>

<ol>
    <li><i>Before installing NeptuneOS, please backup any important files you need. It is <b>not recommended</b> to install this on an already existing Windows install.</i></li>
</ol>

### Installation Steps 🚀

<ol>
    <li>
        <i>Please download the Pro edition of Windows 10 or Windows 11 from <a href="https://massgrave.dev/genuine-installation-media.html">here</a>, or alternatively from <a href="https://uupdump.net/known.php">here if you do not have a USB drive.</a></i>
    </li>
    <li>
        <i>Use <a href="https://rufus.ie/en/">Rufus</a>, <a href="https://www.ventoy.net/en/index.html">Ventoy</a>, or if you do not have a USB drive, <a href="https://github.com/iidanL/InstallWindowsWithoutUSB">InstallWithoutUSB</a> to install the image.</i>
        <ol>
            <li>
                <i>When installing via USB, please follow <a href="https://www.makeuseof.com/windows-11-select-edition-during-install/">this guide</a> before rebooting to the setup.</i>
            </li>
        </ol>
    </li>
    <li>
        <i>When you boot to the image for the first time, please disconnect your ethernet.</i>
        <ol>
            <li>
                <i>If you are on Windows 11, please press Shift+F10 and type OOBE\BYPASSNRO, this will reboot you back to the Windows OOBE.</i>
            </li>
        </ol>
    </li>
    <li>
        <i>When presented with the network connection screen, please click <b>I don't have internet</b></i>
        <ol>
            <li>
                <i>Windows 11 will prompt you with a different message, please click <b>Continue with limited setup</b></i>
            </li>
        </ol>
    </li>
    <li>
        <i>Once you reach the desktop, please open the search bar and type <b>Windows Security</b></i>
        <ol>
            <li>
                <i>In the Windows Security app, please disable Real-Time Protection and Tamper Protection.</i>
            </li>
        </ol>
    </li>
    <li>
        <i>Press Win+R and type cmd. Please paste the following command to install NeptuneOS.</i>
    </li>
</ol>


```NeptuneOS Installation
powershell Invoke-WebRequest -Uri 'https://github.com/NyneDZN/NeptuneOS/archive/refs/heads/installer.zip' -OutFile "$env:TEMP\installer.zip"; Expand-Archive -Path "$env:TEMP\installer.zip" -DestinationPath 'C:\'; Start-Process 'C:\NeptuneOS-installer\Neptune\neptune.bat'
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ABOUT NEPTUNEOS -->
## About NeptuneOS

NeptuneOS is a tailored version of Windows that prioritizes optimal performance and minimal latency, all while preserving seamless compatibility with standard Windows applications and functions. 
By fine-tuning system settings and configurations, it aims to deliver a superior user experience for those seeking peak performance without sacrificing compatibility.
                                       
This project is a fork of AtlasOS.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

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
* [AMIT](https://github.com/amitxv)
* [CoutX](https://github.com/UnLovedCookie/CoutX)
* [Yoshii](https://github.com/Yoshii64)

<p align="right">(<a href="#readme-top">back to top</a>)</p>
