<!DOCTYPE html>
<body>

# 🚀 NeptuneOS Installation

> We are not responsible for any personal files you may lose, or any hardware issues you may experience while using NeptuneOS. <br>
> We are fully open source, and NOT for sale.

> If something has a ⭐, this means it is the recommended method.

## 🔍 Prerequisites

- A USB
- A backup of your personal files on another drive
- A general understanding of your system, and windows itself

## 💻 Reinstalling Windows

You must reinstall windows to install NeptuneOS. This is to prevent unforseen issues in the OS. <br>
If you install NeptuneOS over an existing Windows install, especially one that's already optimized. You will experience issues. <br>
Your Windows ISO edition **must** be Pro or Enterprise.

<details><summary>Why Pro? 💬</summary>
<br>
Home editions do not support a numerous amount of registry tweaks that are supported in Pro, such as those related to the Group Policy.
</details>

## 💽 Downloading your ISO

This doc will be completed to include other methods in the future. <br>

<strong><details><summary>UUP ⭐</strong></summary>
<br>

<h2>UUPDump Guide</h2>
<h2> Getting your ISO from UUPDump</h2>
<li>Head over to <a href="https://uupdump.net/known.php">UUPDump</a></li>
<li>At the top of the window, choose the latest build of your desired Windows version as shown in the screenshot. Make sure that your system and NeptuneOS support it.</li>
<br>
<img src="images/uup.png" alt="UUP Screenshot" style="width: 500px; height:auto;">
<br>
<li> Once you selected your ISO, you will be presented with a list of builds for that version.
<li> Make sure you select one titled "Windows 1x, version xxxx" as shown in the screenshot. (<i>X = Version Number</i>)</li>
<li> Also make sure you select <b>amd64</b>, do NOT select arm64
<br>
<img src="images/uup2.png" alt="UUP Screenshot2" style="width: 500px; height:auto;"
<br>
<li> The next screen will prompt you for your language. Please select yours, and click Next.
<br>
<blockquote> Please note that the NeptuneOS installer will be in English. Language translation <i>may</i> be added in the future.</blockquote>
<li> You will be prompted to Choose your Edition. Make sure <b>Windows Pro</b> is the only thing checked.</li>
<li> The final screen will ask you for Download Options. Please copy the following screenshot. </li>
<br>
<img src="images/uup3.png" alt="UUP Screenshot3" style="width: 400px; height:auto;">
<br>
<li> You will download a zip file with a name such as <i>22631.3520_amd64_en-us_professional_57d5718b_convert.zip</i>, please extract this to your desktop to a folder <b>with no spaces</b>
<li> After extracting, please open the folder and run <i>uup_download_windows.cmd</i> to start compiling the ISO automatically. This will take some time depending on network and processor speeds.
<li> The script will start runnning and will appear as such</li>
<br>
<img src="images/uup4.png" alt="UUP Screenshot4" style="width: 400px; height:auto;">
<br>
<li> When the script finishes, you will have your Windows ISO in the folder that you extracted the script into. </li>
<br>
<img src="images/uup5.png" alt="UUP Screensho5" style="width: 400px; height:auto;"> <img src="images/uup6.png" alt="UUP Sreenshot6" style="width: 400px; height:auto;">
<br>
<li> Please follow the next part of the guide to Install your ISO</li>
<hr>
</details>

<!--<strong><details><summary>MASS</strong></summary>
<br>
<br>

<h2>MASS Guide</h2>
<h2>Getting your ISO from MASS</h2>
<li> Download Windows 10 <a href="https://drive.massgrave.dev/en-us_windows_10_consumer_editions_version_22h2_updated_march_2024_x64_dvd_2ff6c8a4.iso">from here</a>
<li> Download Windows 11 <a href="https://drive.massgrave.dev/en-us_windows_11_consumer_editions_version_23h2_updated_march_2024_x64_dvd_bcbf6ac6.iso">from here</a>
<li> Download Windows Server 2022 (21H1) <a href="https://drive.massgrave.dev/en-us_windows_server_2022_updated_march_2024_x64_dvd_f6700d18.iso">from here</a>
<hr>
</details>-->

## 👨‍💻 Installing your ISO

When installing your ISO, please make sure you have at least 8gb free on your USB drive.<br>
You can backup your files onto your USB, but please do this <b>after</b> you set up your USB so your files do not get formatted.<br>

<!--### Without USB Method

To install Windows witohut a USB, please go to <a href="https://github.com/iidanL/InstallWindowsWithoutUSB">this repository</a> and download the ZIP.

<li>Press Win+R and type <i>diskmgmt.msc</i></li>
<li>Locate your current drive, and shrink it at least 60 GB</li>
<li>Right click the unallocated partition, and create a new simple volume. Name it whatever you desire</li>
<li>Assign the drive letter, and remember it</li>
<li>Extract <i>InstallWindowsWithoutUSB-main</i> to your desktop</li>
<li>Open the extracted folder, and open <i>Install Windows.bat</i></li>
<li>You will be prompted to locate your ISO and open it</li>
<li>Once the process completes, type the letter of the drive you created a partition for. (e.g. D, or F)</li>
<li>Reboot your PC to boot to the newly installed Windows</li>

<br>-->

### Setting up your USB

<details><summary><strong>Ventoy ⭐</strong></summary>
<h2>Ventoy USB Method</h2>
<br>
<li>Start by <a href="https://www.ventoy.net/en/download.html">Downloading Ventoy</a></a>
<li>Extract the downloaded folder, and open <i>Ventoy2Disk.exe</i></li>
<li>Select your USB in the dropdown, and click Install</li>
<li>When the process is finished, find your Ventoy drive, and simply drop the ISO in the root of the folder</li>
<li>Please download the NeptuneOS Ventoy Configuration from <a href="https://github.com/NyneDZN/NeptuneOS/releases/download/0.5/NeptuneOS.Ventoy.Config.zip">this link.</a> If you already downloaded it, then keep proceeding.</li>
<li>When it has finished downloading extract it to a folder, please drag <b>neptune</b> and <b>ventoy</b> to the root of the biggest Ventoy partition.</li>
<li>Rename your Windows ISO to neptune.iso, and drag and drop it into the <b>neptune</b> folder on the Ventoy partition.</li>
<li>You are now safe to place whatever backups you want onto your USB.</li>
</details>

---

### Installing Windows

---

<li>To access your bootable USB, please restart your PC and access your BIOS. Once you are here, disable Secure Boot. Otherwise Ventoy will be unbootable. . If you are unsure how to do this, please google your motherboard vendor for guides.</li>
<li>After configuring the BIOS, please access the boot manager to boot off of your USB and access Ventoy.</li>
<li>Once you are in Ventoy, please select neptune.iso and boot in normal mode.</li>

## 🚀 Deploying NeptuneOS

<li>After Windows has finished installing and you are prompted to create a local account, go ahead and give it whatever name and password you want.</li>
<li>Once you hit the desktop, go to your Ventoy USB drive, and go to the 'neptune' folder. Drag and drop 'neptune-installer.cmd' to your desktop and run it.
<li>Follow the prompts on screen, and wait for installation.
</body>
