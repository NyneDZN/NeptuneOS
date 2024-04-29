# Acknowledgements 🤴

> I have no intention of stealing anyone elses work, if you have any questions, please contact me through discord.

This documentation provides clarity on what open source repositories have been used in NeptuneOS.

## AtlasOS

**Innovative Configuration Methods:**
The AtlasOS developers provide numerous convenient and ingenious ways to configure the operating system, such as he3als, with his online-sxs script.

**Key Contributions:**
The main things we have sourced from Atlas are their .cab packages and script wrappers. The packages allow for users to disable Windows Defender and Telemetry with ease, using the online-sxs script. This prevents a lot of issues when applying tweaks, as Defender likes to flag a lot of registry changes. The script wrappers allow for easier configuration of Windows in the desktop folder with their setSvc and settingsPage scripts.

**Seamless Integration:**
Since the Defender Removal is done through a .cab package, this allows the user to install Neptune without having to touch Defender. We also use he3als' Edge removal script. He provides a very easy way to uninstall and reinstall Edge, along with WebView2, which is widely used in Windows.

## Amit

**Timer Resolution:** Amit provides a application to configure the system timers resolution, which configures refresh intervals between the processor and the operating system.
