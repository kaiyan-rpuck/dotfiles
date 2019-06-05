# This doc includes the necessary manual installations on a new Ubuntu 16.04 system

## TODO-List

- backup the desktop shorcuts
- install Caffe
- install Eigen3, Ceres, g2o and other scientific calculation packages

------

### Sogou Pinyin

The Sogou Pinyin is currently the only good Chinese input on a Ubuntu system, since the Google Pinyin discontinued by March 2019.

1. Download the install package via the following [link](https://pinyin.sogou.com/linux/?r=pinyin)

2. Install the debian package via Software Center by double clicking

3. Resolve the broken dependencies (mainly the fcitx dependencies) via a terminal (`-f` means to fix the broken dependencies): `sudo apt-get install -f`

4. You may need to restart the system, change the input method to fcitx and add the Sogou Input into the list of available inputs

------

### Issue: shutdown/reboot hangs

- Tried to add `acpi=force` into `GRUB_CMDLINE_LINUX_DEFAULT` in the file */etc/default/grub*

------

### Set up Python virtual environment and ban the normal python package installation

- This has been done by `export PIP_REQUIRE_VIRTUALENV=true` and `alias gpip="PIP_REQUIRE_VIRTUALENV=\"\" pip"`

------

### Unity Launcher knowledge

- Two places for the .desktop files:
  - */usr/share/applications/* for system-wide installed applications
  - *~/.local/share/applications/* for user-specific installed applications
- Putting .desktop file into one of the above two directories only means this application is searcheable via Dash
- The actual Launcher icon list is stored in the **dconf** key-value database and there are two ways to actually add an icon into the list
  - Manually search the application in Dash and drag it to the Launcher
  - Edit the list via gsettings, the configuration tool for dconf
    - `gsettings get SCHEMA KEY` to retrieve the value of a key
    - `gsettings set SCHEMA KEY VALUE` to assign a value to a key
    - `gsettings list-schemas` to list all available schemas
    - the schema for the Launcher is: `com.canonical.Unity.Launcher`
    - the key for the Launcher icon list is **favorites**
    - currently under Ubuntu 16.04.6, the value of above key is a list of the following format: `['application://ubiquity.desktop', ...]`
- More details can be found at [the Ubuntu help page](https://help.ubuntu.com/community/UnityLaunchersAndDesktopFiles)
- It is possible to add shortcut to the right-click menu of the icon
- It's better to manually add the icons to the launcher or copy a target list to the **favorites** value via gsettings
- The .desktop files for the applications installed by Snap can be located in */var/lib/snapd/desktop/applications*

------

### Example of Chrome Shortcut to understand Unity Launcher and .desktop files

- Once having created the shortcut via *Chrome->More tools->Create shortcut...*, Chrome will create 2 shortcuts, one in `~/.local/share/applications/` and another on the desktop
  - The desttop one could be safely deleted if willing to keep the desktop clean
  - The .local folder one could be changed to a more meaningful name as the original name includes the long hex code id in the middle. It is searchable in Dash as well since it is in the Launcher path.
- Chrome will also create a `mimeapps.list` file under both the `~/.local/share/applications/` and `~/.config/` to specify which kind of MIME/Media will be opened by Chrome
  - This file under `~/.local/share/applications/` is depreciated, I think Chrome creating this file for legacy reason
  - The Chrome settings in this `mimeapps.list` are under the [Default Applications] section
- Whether an app is open as a window or in a tab can be set by right clicking the app icon in the Apps page

------

### Setting default application

- You can set the default application for the most common types / primitive types of usages via *System Settings->Details->Default Applications*
- For other types, especially the MIME types, i.e. the non primitive types, there are two useful commands: `mimeopen` and `mimetype`
  - `mimetype [FILENAME]` returns the actual MIME type of the file
  - `mimeopen [FILENAME]` actually open the MIME file with the MIME type's default application
  - the default application can be changed by `mimeopen -d [FILENAME]` or `mimeopen -d [.EXTENSION]`
  - the default application may be under the [Added Associations] section

------

### NVidia Driver

- If having selected *third party drivers*, a NVidia driver will be already installed
  - This driver may not be the latest long-live stable version, e.g. in this installation it is the version 384.130
- You still need to manually switch to it via *System settings...->Software & Updates->Additional Drivers*

------

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

------

### Disable Recent Usage Recording

1. Open **System Settings** via clicking right top *setting* button
2. Choose **Security & Privacy** then **Files & Applications** tab
3. Clear All Usage Data
4. Turn off recording file and application usage

------

### The different PATH environment variables

- `$PATH` is used for bin/executables search.
- `$LIBRARY_PATH` is used by gcc before compilation to search directories containing static and shared libraries that need to be linked to your program.
- `$LD_LIBRARY_PATH` is used by your program to search directories containing shared libraries after it has been successfully compiled and linked.
- `$PYTHONPATH` sets the search path for **importing** python modules
  - like importing *cv2.so* by `import cv2`.
  - python and python3 both use this env
  - it's better to define aliases for python and python3 to include their specific library path, like */usr/local/lib/python\<version\>/dist-packages*

------

### OpenCV3 Compatibility Issues

- ROS Kinetic natively built its own OpenCV3 via package *ros-kinetic-opencv3*
  - currently this opencv3 is version 3.3.1-dev
  - this opencv3 includes the *opencv_contrib* repository as well
  - this opencv3 has NO CUDA support but having a OpenCL support with no extra feature
  - the ROS wiki page of opencv3 package states some CMake considerations if both OpenCV2 and OpenCV3 are installed
  - this opencv3 is built for ROS and python2, so in python3 `import cv2` will fail
- The actual build information of the OpenCV can be found by `print cv2.getBuildInformation()` in Python
- OpenCL is not installed on Ubuntu 16.04 by default
- [OpenCV Wiki](https://github.com/opencv/opencv/wiki) is a good place to learn OpenCV compilation
- `cmake-gui` is a good way to see the available flags in advance
- This is a good article about [compiling OpenCV with CUDA support](https://www.pyimagesearch.com/2016/07/11/compiling-opencv-with-cuda-support/)
- This is a good article about [compiling and testing OpenCV3](https://alliance.seas.upenn.edu/~cis700ii/dynamic/techinfo/2015/09/04/compiling-and-benchmarking-opencv-3-0/)
- According to [this post](https://answers.opencv.org/question/95392/opencv-31-build-from-source-core-test-fails-for-3-tests/), the tests about HAL fail is a normal result.
- This is a good article about [building OpenCV with CUDA on Tegra environment](https://docs.opencv.org/3.4/d6/d15/tutorial_building_tegra_cuda.html)

------

### Python2 and Python3 coexistence

- Python2 and Python3 may need different $PYTHONPATH
  - a good example is OpenCV
- We can define two env $PYTHON2PATH and $PYTHON3PATH specifically for the the version sensitive libraries
- We then define aliases for `python` and `python3` to include these specific library paths
- This is a good article about [solving conflicting Pythons](https://dev.to/bgalvao/conda--dealing-with-conflicting-pythons-in-your-system-62n), especially if Anaconda/Miniconda need to be installed in the future
  - however, Anaconda's PATH is conflicting with ROS PATH, so this is not recommended

------

### Useful Bash commands

- `type` can be used to check the type and content of aliases, functions, builtins, keywords, external commands etc.
  - e.g. `type python3`
- `whereis` to locate the binary, source and manual page for a command
  - e.g. `whereis nvcc`
- `which` to locate a program file in the user's path
  - e.g. `which nvcc`

------

### Configuring PyCharm for ROS project

- The following [link](http://wiki.ros.org/IDEs) gives guidance on how to set PyCharm compatible with ROS development
- Adding `bash -i -c` to the start of the Snap PyCharm .desktop file
- Setting up a virtualenv inside PyCharm specifically for ROS project

------

### PyCUDA

- PyCUDA is the Python wrapper for CUDA, which can be installed by `(g)pip install 'pycuda>=2017.1.1'`
- It may be better to install it in a virtualenv when needed
- Updating CUDA will break PyCUDA and will enforce to uninstall the old PyCUDA and then to install the new PyCUDA
- This Python wrapper only work for Python2 (importing it fails in Python3)

------

### TensorFlow

- Currently, TensorFlow debian installation only works with CUDA 10.0 suite (CUDA 10.0, CuDNN 7.4.1 and TensorRT 5.0.2)
- The TensorFlow can be installed via `(g)pip install tensorflow-gpu==2.0.0-alpha0`
- It may be better to install it in a virtualenv when needed
- `export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/extras/CUPTI/lib64` may be needed

------

### Updating CMake

- Ubuntu default CMake version is 3.5.1, but some packages require 3.6
- People suggest to build the CMake from source downloaded from the official site, otherwise *cmake-gui* may not work
- **DO NOT REMOVE THE OLD CMAKE**, otherwise some ROS packages will be removed as well and ROS system breaks!
- `cmake --version` can be used to check CMake version
