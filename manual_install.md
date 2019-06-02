# This doc includes the necessary manual installations on a new Ubuntu 16.04 system

## TODO-List
1. ~install nvidia driver and Cuda~
2. ~install ROS, the desktop-full version automatically installs *ros-kinetic-opencv3* and the *OpenCV 3.3.1* is usable via `import cv2`~
  1. according to *ros-kinetic-opencv3* wiki, the *opencv_contrib* is also included in this package.
  2. there will be CMake considerations if both OpenCV2 and OpenCV3 are installed. But we keep only using OpenCV3 as OpenCV2 will be outdated.
  3. with this opencv3 installation, the CUDA support is off and the OpenCL support is on with no extra feature
  4. the actual build information of the Opencv can be found by `print cv2.getBuildInformation()` in Python
  4. OpenCL is not installed on Ubuntu 16.04 by default
  5. this is a good article about [building OpenCV with CUDA on Tegra environment](https://docs.opencv.org/3.4/d6/d15/tutorial_building_tegra_cuda.html)
  6. the *ros-kinetic-opencv3* is built for ROS and Python 2, so in Python 3 `import cv2` will fail
  7. this is a good article about [compiling OpenCV with CUDA support](https://www.pyimagesearch.com/2016/07/11/compiling-opencv-with-cuda-support/)
3. install Anaconda and set it compatible with ROS
  1. this is a good article about [solving conflicting Pythons](https://dev.to/bgalvao/conda--dealing-with-conflicting-pythons-in-your-system-62n)
4. install Caffe or TensorFlow
5. backup the desktop shorcuts
6. PyCharm configuration for ROS compatibility by following [link](http://wiki.ros.org/IDEs)

### Sogou Pinyin
The Sogou Pinyin is currently the only good Chinese input on a Ubuntu system, since the Google Pinyin discontinued by March 2019.

1. Download the install package via the following [link](https://pinyin.sogou.com/linux/?r=pinyin)

2. Install the debian package via Software Center by double clicking

3. Resolve the broken dependencies (mainly the fcitx dependencies) via a terminal (`-f` means to fix the broken dependencies): `sudo apt-get install -f`

4. You may need to restart the system, change the input method to fcitx and add the Sogou Input into the list of available inputs

### Issue: shutdown/reboot hangs
- Tried to add `acpi=force` into `GRUB_CMDLINE_LINUX_DEFAULT` in the file */etc/default/grub*

### Set up Python virtual environment and ban the normal python package installation
- This has been done by `export PIP_REQUIRE_VIRTUALENV=true` and `alias gpip="PIP_REQUIRE_VIRTUALENV=\"\" pip"`

### Unity Launcher knowledge
- Two places for the .desktop files:
  1. */usr/share/applications/* for system-wide installed applications
  2. *~/.local/share/applications/* for user-specific installed applications
- Putting .desktop file into one of the above two directories only means this application is searcheable via Dash
- The actual Launcher icon list is stored in the **dconf** key-value database and there are two ways to actually add an icon into the list
  1. Manually search the application in Dash and drag it to the Launcher
  2. Edit the list via gsettings, the configuration tool for dconf
    - `gsettings get SCHEMA KEY` to retrieve the value of a key
    - `gsettings set SCHEMA KEY VALUE` to assign a value to a key
    - `gsettings list-schemas` to list all available schemas
    - the schema for the Launcher is: `com.canonical.Unity.Launcher`
    - the key for the Launcher icon list is **favorites**
    - currently under Ubuntu 16.04.6, the value of above key is a list of the following format: `['application://ubiquity.desktop', ...]`
- More details can be found at [the Ubuntu help page](https://help.ubuntu.com/community/UnityLaunchersAndDesktopFiles)
- It is possible to add shortcut to the right-click menu of the icon
- It's better to manually add the icons to the launcher or copy a target list to the **favorites** value via gsettings

### Example of Chrome Shortcut to understand Unity Launcher and .desktop files
- Once having created the shortcut via *Chrome->More tools->Create shortcut...*, Chrome will create 2 shortcuts, one in `~/.local/share/applications/` and another on the desktop
  - The desttop one could be safely deleted if willing to keep the desktop clean
  - The .local folder one could be changed to a more meaningful name as the original name includes the long hex code id in the middle. It is searchable in Dash as well since it is in the Launcher path.
- Chrome will also create a `mimeapps.list` file under both the `~/.local/share/applications/` and `~/.config/` to specify which kind of MIME/Media will be opened by Chrome
  - This file under `~/.local/share/applications/` is depreciated, I think Chrome creating this file for legacy reason
  - The Chrome settings in this `mimeapps.list` are under the [Default Applications] section
- Whether an app is open as a window or in a tab can be set by right clicking the app icon in the Apps page

### Setting default application
- You can set the default application for the most common types / primitive types of usages via *System Settings->Details->Default Applications*
- For other types, especially the MIME types, i.e. the non primitive types, there are two useful commands: `mimeopen` and `mimetype`
  - `mimetype [FILENAME]` returns the actual MIME type of the file
  - `mimeopen [FILENAME]` actually open the MIME file with the MIME type's default application
  - the default application can be changed by `mimeopen -d [FILENAME]` or `mimeopen -d [.EXTENSION]`
  - the default application may be under the [Added Associations] section

### NVidia Driver
- If having selected *third party drivers*, a NVidia driver will be already installed
  - This driver may not be the latest long-live stable version, e.g. in this installation it is the version 384.130
- You still need to manually switch to it via *System settings...->Software & Updates->Additional Drivers*

### Using Snap to install applications
There is now a Snap Store called [snapcraft](https://snapcraft.io/store).

List of application candidates：
- [PyCharm Community](https://snapcraft.io/pycharm-community)
  - `sudo snap install pycharm-community --classic`
- [Slack](https://snapcraft.io/slack)
  - `sudo snap install slack --classic`
- [Sublime Text](https://snapcraft.io/sublime-text)
  - `sudo snap install sublime-text --classic`
- [GitKraken](https://snapcraft.io/gitkraken)
  - `sudo snap install gitkraken`
- [Visual Studio Code](https://snapcraft.io/code)
  - `sudo snap install code --classic`
- [Postman](https://snapcraft.io/postman)
  - `sudo snap install postman`
- [ONLYOFFICE DesktopEditors](https://snapcraft.io/onlyoffice-desktopeditors)
  - `sudo snap install onlyoffice-desktopeditors`
- [FFmpeg](https://snapcraft.io/ffmpeg)
  - `sudo snap install ffmpeg`
- [Skype](https://snapcraft.io/skype)
  - `sudo snap install skype --classic`
- [clementine](https://snapcraft.io/clementine)
  - `sudo snap install clementine`
  - **Segmentation Fault** when starts
- [Wonderwall](https://snapcraft.io/wonderwall)
  - `sudo snap install wonderwall`
  - `snap connect wonderwall:hardware-observe` to enable necessary permission
- [Sticky Notes](https://snapcraft.io/stickynotes)
  - `sudo snap install stickynotes`
- [Spotify](https://snapcraft.io/spotify)
  - `sudo snap install spotify`
- [Simple Scan](https://snapcraft.io/simple-scan)
  - `sudo snap install simple-scan --classic`
  - it seems being a built-in app for ubuntu, no need to install again
- [Winds - RSS & Podcasts](https://snapcraft.io/winds)
  - `sudo snap install winds`

### Disable Recent Usage Recording
1. Open **System Settings** via clicking right top *setting* button
2. Choose **Security & Privacy** then **Files & Applications** tab
3. Clear All Usage Data
4. Turn off recording file and application usage
