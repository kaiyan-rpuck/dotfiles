# Dotfiles and new system installations

**Warning:** currently the scripts are only tested on Ubuntu 16.04 on a Dell XPS 15 with nVidia 1050M as the graphic card

## Repository Structure

- **backup** folder for backup of original dotfiles, *git-ignored*
- **installers** folder for downloaded installer files, *git-ignored*
- **readme** folder for storing the learned notes
  - the **manual_install_steps.md** describes the necessary steps to manually install necessary softwares that can hardly be automatically installed, at the moment
- **sytem** folder for the dotfiles to be soft linked to system
- `install.sh` the main executable
  - `symlink-setup.sh`, called by **install.sh** to setup soft links for dotfiles
  - `install_softwares.sh`, called by **install.sh** to automatically install a list of useful softwares
- `exp_install.sh`, playground for experimenting snippets for installing softwares

## Automatic Installation

Running `./install.sh` will execute the following actions by calling `./symlink-setup.sh` and `./install_softwares.sh`

- backup the original dotfiles, mainly the `.bashrc` and `.profile`
- soft link the dotfiles to `$HOME` directory
- update the `.bashrc` to activate the linked dotfiles
- automatically install the following list of useful softwares:
    1. vim
    2. cmake-qt-gui
    3. google-chrome
    4. snap applications
        - pycharm-community
        - slack
        - sublime-text
        - gitkraken
        - code
        - postman
        - onlyoffice-desktopeditors
        - ffmpeg
        - skype
        - stickynotes
        - spotify
        - simple-scan
        - winds
    5. wine
    6. pip, virtualenv and virtualenvwrapper
        - also disable the `pip` command when not in a virtual environment
        - create alias `gpip` in case a global pip execution is necessary
    7. git
    8. CUDA, currently version 10.0 in order to work with TensorFlow 2.0-alpha
    9. CuDNN, currently the version accompanying CUDA 10.0
    10. TensorRT, currently the version accompanying CUDA 10.0
    11. PyCUDA, via pip
    12. TensorFlow-GPU 2.0.0-alpha0
    13. ROS Kinetic
    14. OpenCV 3.4.6 for both Python2 and Python3
        - also make obsolete the OpenCV 3.3.1's `cv2.so` installed by ROS Kinetic
    15. Anaconda2
        - also create soft links for `conda`, `activate` and `deactivate` commands
    16. Update CMake to the latest version

## Manual Installations

The `manual_install_steps.md` in the **readme** folder specifies the steps to install various softwares and the points to notice, which covers:

- a To-Do List for planned/desired installations in head
- install `Sougou Pinyin`
- how to solve **shutdown/reboot hanging**
- how to prohibit `pip` running globally
- learned conclusions about **Unity Launcher**
- learned conclusions about **Chrome Shortcut**
- learned conclusions about **setting default application**
- how to install/update/activate the latest **nNivida driver**
- how to **snap install** applications and a list of candidates
- how to disable **Recent Usage Recording**
- learned conclusions about **different PATH environment variables**
- learned conclusions about **OpenCV3 Compatibility Issues**
- how to **coexist Python2 and Python3**
- learned conclusions about **useful Bash commands**
- how to **configure PyCharm for ROS**
- learned knowledge about **PyCUDA**
- learned knowledge about **TensorFlow-GPU**
- how to update `CMake`
