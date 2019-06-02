#!/usr/bin/sudo bash

### set the output color commands if not set yet
black=${black:-`tput setaf 0`}
red=${red:-`tput setaf 1`}
green=${green:-`tput setaf 2`}
yellow=${yellow:-`tput setaf 3`}
blue=${blue:-`tput setaf 4`}
magenta=${magenta:-`tput setaf 5`}
cyan=${cyan:-`tput setaf 6`}
white=${white:-`tput setaf 7`}
reset=${reset:-`tput sgr 0`}

### utils
function dpkg_installed {
	if [[ `dpkg -l | grep ^ii | awk '{print $2}' | grep $1 | wc -l` -gt 0 ]]; then
        echo "  ${cyan}$1 has ALREADY been installed.${reset}"
        return
    else
        echo "  ${magenta}$1 has NOT been installed.${reset}"
    fi
    false
}

function dpkg_attempt_install {
	if ! dpkg_installed $1; then
		if [[ $# -gt 1 ]]; then
			$2  # custom installation function as parameter
		else
			apt -y install $1  # default installation method
		fi
		if [ $? -eq 0 ]; then
			echo "  ${green}$1 has been successfully installed via dpkg!${reset}"
		else
			>&2 echo "  ${red}$1 installation via dpkg has failed...${reset}"
			false
			return
		fi
	fi
}

function snap_installed {
    if [[ `snap list | grep $1 | wc -l` -gt 0 ]]; then
        echo "  ${cyan}$1 has ALREADY been installed.${reset}"
        return
    else
        echo "  ${magenta}$1 has NOT been installed.${reset}"
    fi
    false
}

function snap_attempt_install {
	if ! snap_installed $1; then
		if snap install $1; then
			echo "  ${green}$1 has been successfully installed via snap!${reset}"
		else
			>&2 echo "  ${red}$1 installation via snap has failed...${reset}"
			false
			return
		fi
	fi
}

function print_boolean_result {
    if $1; then
        echo true
    else
        echo false
    fi
}

### install vim
dpkg_attempt_install vim

### set up the download folder for the installation files
export _tmp_download_folder="$(dirname $0 | xargs realpath)/installers"
mkdir -p $_tmp_download_folder # create the installers folder if it does not exist

### install Google Chrome
function install_google_chrome {
	# download the package
	wget -P $_tmp_download_folder https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	# install the downloaded package
	dpkg -i $_tmp_download_folder/google-chrome-stable_current_amd64.deb
}
dpkg_attempt_install google-chrome install_google_chrome

### install snap applications
_snap_applications=(
	"pycharm-community --classic" 
	"slack --classic" 
	"sublime-text --classic" 
	"gitkraken" 
	"code --classic" 
	"postman" 
	"onlyoffice-desktopeditors" 
	"ffmpeg" 
	"skype --classic" 
	#"clementine" # **Segmentation Fault** when starts
	#"wonderwall" # cannot enable hardware-observe permission
	"stickynotes" 
	"spotify" 
	"simple-scan --classic" 
	"winds"
)

for _app in "${_snap_applications[@]}"
do
	snap_attempt_install $_app
done

### install wine
function install_wine {
	# to enable 32 bit architecture:
	dpkg --add-architecture i386
	# download and add the repository key
	wget -P $_tmp_download_folder -nc https://dl.winehq.org/wine-builds/winehq.key
	apt-key add $_tmp_download_folder/winehq.key
	# add the repository
	apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ xenial main'
	# update packages
	apt update
	# install the development branch
	apt install --install-recommends winehq-devel
	# remove the winekey file
	rm $_tmp_download_folder/winehq.key
}
dpkg_attempt_install winehq install_wine

### install pip, virtualenv, virtualenvwrapper
function install_pip_virtualenv_wrapper {
	# to install pip for python2
	apt -y install python-pip
	# to install virtualenv
	pip install virtualenv
	# to install virtualenvwrapper and setup
	pip install virtualenvwrapper
	# to finish export and source
	_dotfiles_dir=`dirname $0`/system/
	# to setup the workon home directory
	if [[ `grep "export WORKON_HOME" ${_dotfiles_dir}exports | wc -l` -eq 0 ]]; then
		echo "" >> ${_dotfiles_dir}exports
		echo "###### export virtualenvwrapper's WORKON_HOME" >> ${_dotfiles_dir}exports
		echo "export WORKON_HOME=~/Workspace/PyEnvs" >> ${_dotfiles_dir}exports
		echo "" >> ${_dotfiles_dir}exports
	fi
	# to disable the 'pip' command when not in a virtual environment
	if [[ `grep "export PIP_REQUIRE_VIRTUALENV" ${_dotfiles_dir}exports | wc -l` -eq 0 ]]; then
		echo "" >> ${_dotfiles_dir}exports
		echo "###### disable 'pip' command" >> ${_dotfiles_dir}exports
		echo "export PIP_REQUIRE_VIRTUALENV=true" >> ${_dotfiles_dir}exports
		echo "" >> ${_dotfiles_dir}exports
	fi
	# to source the virtualenvwarpper.sh
	if [[ `grep "source .*virtualenvwrapper.sh" ${_dotfiles_dir}sources | wc -l` -eq 0 ]]; then
		echo "" >> ${_dotfiles_dir}sources
		echo "###### export virtualenvwrapper's WORKON_HOME" >> ${_dotfiles_dir}sources
		echo "source ~/.local/bin/virtualenvwrapper.sh" >> ${_dotfiles_dir}sources
		echo "" >> ${_dotfiles_dir}sources
	fi
	# to setup gpip for global 'pip' command
	if [[ `grep "alias gpip" ${_dotfiles_dir}aliases | wc -l` -eq 0 ]]; then
		echo "" >> ${_dotfiles_dir}aliases
		echo "###### setup gpip for global 'pip' command" >> ${_dotfiles_dir}aliases
		echo 'alias gpip="PIP_REQUIRE_VIRTUALENV=\"\" pip"' >> ${_dotfiles_dir}aliases
		echo "" >> ${_dotfiles_dir}aliases
	fi
	unset _dotfiles_dir
	true
}
dpkg_attempt_install python-pip install_pip_virtualenv_wrapper

### install Git
function install_git {
	# to add Git PPA
	add-apt-repository ppa:git-core/ppa
	apt update
	# to install Git
	apt -y install git
}
dpkg_attempt_install git install_git

### install Cuda
function install_cuda {
	## pre-installation
	# to check if the nvidia driver has been installed
    if [[ `lspci | grep -i nvidia | wc -l` -eq 0 ]]; then
        >&2 echo "${red}Please enable the nvidia driver via \"System Settings->Software and Updates->Additional Drivers\"${reset}"
        false
        return
    fi
    # to manually verify if the Linux version is supported
    # uname -m && cat /etc/*release
    # to manually verify if the gcc version is supported
    # gcc --version
    # to manually verify if the kernel version is supported
    # uname -r
    # to install the kernel headers and development package
    echo "  ${cyan}Ready to install the kernel headers and development package${reset}"
    apt -y install linux-headers-$(uname -r) || return 1
    if [[ `ls $_tmp_download_folder/cuda-repo-ubuntu1604_*.deb | wc -l` -eq 0 ]]; then
        >&2 echo "${red}Please download the network version cuda repo debian package via official website${reset}"
        false
        return
    else
        _cuda_deb=$(ls $_tmp_download_folder/cuda-repo-ubuntu1604_*.deb | tail -1)
        # to manually check the MD5 sum
        echo "  ${cyan}The MD5 sum of the Cuda repo debian package is: $(md5sum $_cuda_deb)${reset}"
        echo "  ${cyan}Ready to install the Cuda repo deb package${reset}"
        dpkg -i $_cuda_deb || return 1
        apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
        apt update
        echo "  ${cyan}Ready to install the Cuda toolkit${reset}"
        apt -y install cuda || return 1
        echo "  ${cyan}Ready to export the Cuda and Nsight path to PATH env"
        _dotfiles_dir=`dirname $0`/system/
        if [[ `grep "export PATH.*/usr/local/cuda/bin" ${_dotfiles_dir}exports | wc -l` -eq 0 ]]; then
            echo "" >> ${_dotfiles_dir}exports
            echo "###### export the Cuda and Nsight path to PATH env" >> ${_dotfiles_dir}exports
			# Warning: The cuda/bin has used softlink for convinience, but the NsightCompute-2019.3 is still hardcoded
            echo 'export PATH=/usr/local/cuda/bin:/usr/local/cuda/NsightCompute-2019.3${PATH:+:${PATH}}' >> ${_dotfiles_dir}exports
            echo "" >> ${_dotfiles_dir}exports
        fi
    fi
	unset _dotfiles_dir
	true
}
dpkg_attempt_install cuda install_cuda

### install ROS Kinetic
function install_ROS_Kinetic {
    # manually check the permissions to "restricted", "universe" and "multiverse" repositories via "System Settings -> Software & Updates"
    # to add the source repository and the ropository key to the system config
    sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
    apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
    # to update and install ROS Kinetic
    apt update
    apt -y install ros-kinetic-desktop-full || return 1
    # to initialise the rosdep
    rosdep init
    rosdep update
    # to setup ROS environment variables
    _dotfiles_dir=`dirname $0`/system/
    if [[ `grep "source /opt/ros/kinetic/setup.bash" ${_dotfiles_dir}sources | wc -l` -eq 0 ]]; then
		echo "" >> ${_dotfiles_dir}sources
		echo "###### export ROS Kinetic environment variables" >> ${_dotfiles_dir}sources
		echo "source /opt/ros/kinetic/setup.bash" >> ${_dotfiles_dir}sources
		echo "" >> ${_dotfiles_dir}sources
	fi
    unset _dotfiles_dir
    # to install tools and dependencies for building ROS packages
    apt -y install python-rosinstall python-rosinstall-generator python-wstool build-essential
}
dpkg_attempt_install ros-kinetic install_ROS_Kinetic