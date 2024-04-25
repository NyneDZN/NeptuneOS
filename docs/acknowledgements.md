# Acklowledgements 🤴

This documentation provides clarity on what open source repositories have been used in NeptuneOS.

## AtlasOS

My main inspiration for NeptuneOS began with AtlasOS. They have been a big standpoint for Neptune, and without them we wouldn't be here. <br>
The AtlasOS developers provide numerous convinient and ingenious ways to configure the operating system, such as he3als, with his online-sxs script. <br>
The main things we have sourced from Atlas, are their .cab packages and script wrappers. The packages allow for users to disable Windows Defender and Telemetry with ease, using the online-sxs script. This prevents a lot of issues when applying tweaks, as Defender likes to flag a lot of registry changes. The script wrappers allow for easier configuration of Windows in the desktop folder with their setSvc and settingsPage scripts. <br>
Since the Defender Removal is done through a .cab package, this allows the user to install Neptune without having to touch defender. <br>
We also use he3als edge removal script. He provides a very easy way to uninstall and re-install edge, along with WebView2, which is widely used in Windows <br>
