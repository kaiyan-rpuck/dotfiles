# This MarkDown file takes the notes and learnings during the usage of ROS (Kinetic)

------

## Overlaying or Switching workspaces

- `catkin_make` will automatically detect the already sourced workspace and overlay the current workspace on top of it
  - the result of this is the *devel/setup.bash*
  - this overlay mechanism is static, which means if you later add or remove a sourced workspace before you source this workspace's *setup.bash*, the overlay structure will not change as it has been decided during `catkin_make` and the add or remove of workspace may even bring potential conflicts in environment variables.
  - as a consequence, you will always see `-- This workspace overlays: /opt/ros/kinetic` during a `catkin_make`, even for a brand new first workspace.
- If I want to switch between workspace A and B, I need to ensure that the other workspace is not sourced during the `catkin_make` process. Later, I just need to source the wanted workspace's *setup.bash* before using the workspace.
  - in order to not accidently overlaying the switching workspaces, it's better to only source ROS's *setup.bash* in *.bashrc*, make a virtualenv for each workspace and source the workspace's *setup.bash* during the initiation of the virtualenv.
  - the above can be done by source `setup.bash` in the `$VIRTUAL_ENV/bin/postactivate` (to create this file if it doesnot exist)

------

## Installing the Vilas legacy packages

- There is a super repository which is supposed to have all the Vilas legacy installed once, but this repository breaks due to unsolved coding errors and unsovled dependencies hell.
- Vilas left two repositories, the `core` and the `rpuck_server`, where `core` needs `Fast-RTPS` v1.7.0 from eProsima and `rpuck_server` needs `Fast-RTPS`, `AprilTag` and `core`.
- Remember to `sudo rm -r build` before **re-build**, after any change in the `CMakeLists.txt`

The following is the steps to compiling all the legacy repositories:

- CMake must be 3.6.0 or above
- to install the necessary dependencies for `core`:

    ```bash
    # dependencies for core
    sudo apt -y install doxygen graphviz clang-tidy clang-format clang
    # dependencies for rpuck_server
    sudo add-apt-repository 'deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial main'
    wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
    sudo apt update
    sudo apt -y install doxygen graphviz ant gradle default-jdk liblz4-dev clang-tidy-6.0 clang-format-6.0 clang-6.0
    # to install Qt 5.11 via an external PPA as rpuck_server requires Qt > 5.9
    sudo add-apt-repository ppa:beineri/opt-qt-5.11.1-xenial
    sudo apt update
    sudo apt install qt511-meta-full
    sudo ln -s /etc/xdg/qtchooser/opt-qt511.conf /etc/xdg/qtchooser/default.conf
    ```

- to modify the `/opt/qt511/lib/cmake/Qt5Gui/Qt5GuiConfigExtras.cmake` cmake in order to include the OpenGL libraries correctly
  - firstly comment the first lines about searching `GL/gl.h` and setting `_qt5gui_OPENGL_INCLUDE_DIR`
  - secondly set the `_qt5gui_OPENGL_INCLUDE_DIR` by adding `set(_qt5gui_OPENGL_INCLUDE_DIR "/usr/include")`
- to download, compile and install `Fast-RTPS` branch v1.7.0

    ```bash
    git clone -b v1.7.0 https://github.com/eProsima/Fast-RTPS.git
    cd Fast-RTPS
    mkdir build
    cd build
    cmake -DTHIRDPARTY=ON ..
    make -j6
    make install
    ```

- to download, compile and install `core` branch master

    ```bash
    git clone https://github.com/irrpuck/core.git
    cd core
    mkdir build
    cd build
    cmake ..
    make -j6
    make install
    ```

- to download, compile and install `apriltag` from `irrpuck`

    ```bash
    git clone https://github.com/irrpuck/apriltag.git
    cd apriltag
    mkdir build
    cd build
    cmake ..
    make -j6
    make install
    ```

- to download and install `WiringPi`

    ```bash
    git clone git://git.drogon.net/wiringPi
    cd ~/wiringPi
    ./build
    ```

- to download the `rpuck_server` branch `siltr`

    ```bash
    git clone -b siltr https://github.com/irrpuck/rpuck_server.git
    ```

- to comment the line 111 `LOG_NOTE(logger_) << config_.id << " up at " << node->getIPv4String();` of file `<path>/rpuck_server/siltr/devices/station/src/station_interface.cpp`, as this line raises Error but is purely logging to output.
- to compile the `rpuck_server`

    ```bash
    cd rpuck_server
    mkdir build
    cd build
    cmake -DCMAKE_PREFIX_PATH=/opt/qt511 ..  # to specify the prefix path of Qt 5.11
    make -j6
    ```

------

## Installing missing ROS packages for rpuck_ros

- to check if `CMake` is the latest version, not the default 3.5.1 provided by Ubuntu
- to check out the `SILTR` branch instead of `master` branch
- to install all the system dependencies for the packages in the workspace

    ```bash
    sudo rosdep install --from-path src --ignore-src -r -y --rosdistro kinetic
    ```

- to install the missing ROS package dependencies

    ```bash
    sudo apt -y install ros-kinetic-joy
    sudo apt -y install ros-kinetic-socketcan-bridge
    ```

------

## Differences between *catkin*, *rosdep* and *wstool*

- [*rosdep*](http://wiki.ros.org/rosdep) is a command-line tool for installing system dependencies
  - it is used to make sure that you have all the necessary system dependencies (typically the binary pkgs, i.e. the *debs* on Ubuntu/Debian) installed on your system
  - it is used at the packaging level to allow the user or build farm to make sure that all the dependencies are installed. The dependencies are declared at the level of installation units. However they are not used by cmake/catkin at configure/compile time
- [*wstool*](http://wiki.ros.org/wstool) is command-line tools for maintaining a workspace of projects from multiple version-control systems
  - it manages source checkouts/git clones in a workspace
  - it is used to get the sources of the packages that you wish to work on (or need to compile, if there are no binaries for your platform)
  - it provides commands to manage several local SCM repositories (git, mercurial, subversion, bazaar) based on a single workspace definition file (.rosinstall)
  - as catkin workspaces create their own setup file and environment, wstool is reduced to version control functinos only
- [*catkin*](http://wiki.ros.org/catkin) is the build system for ROS, especially used for build/compile the development workspace
- Use *rosdep* to install the system dependencies, then use *wstool/rosinstall* to manage the source code type package dependecies (even checkout the packages in development from remote repositoreis), lastly use *catkin* to build the system at local.

------

## Notes about using Conda (to move later)

- `conda init` only modify `.bashrc` and can be reversed by `conda init --reverse`
- `conda update` will breaks if not in a conda venv
  - as a result, the conda alias will be hashed by *~/anaconda2/condabin/conda*
- adding `--no-channel-priority` flag will make the `conda install` to ignore the channel priority and to choose the most updated version of packages
  - this may be very helpful when installing external channel package and facing package conflicts
