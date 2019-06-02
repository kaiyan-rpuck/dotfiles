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
_tmp_download_folder="$HOME/Downloads" # Note: use $HOME instead of ~/ in script

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
	if [[ `grep "export WORKON_HOME" ${_dotfiles_dir}exports | wc -l` -eq 0 ]]; then
		echo "" >> ${_dotfiles_dir}exports
		echo "###### export virtualenvwrapper's WORKON_HOME" >> ${_dotfiles_dir}exports
		echo "export WORKON_HOME=~/Workspace/PyEnvs" >> ${_dotfiles_dir}exports
		echo "" >> ${_dotfiles_dir}exports
	fi
	if [[ `grep "source .*virtualenvwrapper.sh" ${_dotfiles_dir}sources | wc -l` -eq 0 ]]; then
		echo "" >> ${_dotfiles_dir}sources
		echo "###### export virtualenvwrapper's WORKON_HOME" >> ${_dotfiles_dir}sources
		echo "source ~/.local/bin/virtualenvwrapper.sh" >> ${_dotfiles_dir}sources
		echo "" >> ${_dotfiles_dir}sources
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