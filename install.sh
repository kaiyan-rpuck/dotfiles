#!/usr/bin/sudo bash

################
# set the colors
################
black=${black:-`tput setaf 0`}
red=${red:-`tput setaf 1`}
green=${green:-`tput setaf 2`}
yellow=${yellow:-`tput setaf 3`}
blue=${blue:-`tput setaf 4`}
magenta=${magenta:-`tput setaf 5`}
cyan=${cyan:-`tput setaf 6`}
white=${white:-`tput setaf 7`}
reset=${reset:-`tput sgr 0`}

################
# Utils
################
function execute_action {
    if [[ $# < 2 ]]; then
        >&2 echo "USAGE: execute_action action_name action_function"
        false
        return
    fi
    echo "${yellow}Starting $1...${reset}"
    $2
    if [ $? -eq 0 ]; then
        echo "${green}$1 has successfully finished!${reset}"
    else
        >&2 echo "${red}Action $1 has failed!!!${reset}"
    fi
}

################
# backup the old stuffs
################

# set the dotfiles root directory
export DOTFILES_ROOT=$(realpath `dirname $0`)
echo "${green}Dotfiles root directory identified: ${cyan}$DOTFILES_ROOT${reset}"

# bakcup the old dotfiles files
function backup_original_dotfiles {
    export DOTFILES_BACKUP_DIR=$DOTFILES_ROOT/backup
    mkdir -p $DOTFILES_BACKUP_DIR
    echo "  ${green}Old dotfiles will be backed up in ${cyan}$DOTFILES_BACKUP_DIR${reset}"
    cp -Rp ~/.bashrc $DOTFILES_BACKUP_DIR/bashrc
    echo "  ${green}.bashrc has been backed up${reset}"
    cp -Rp ~/.profile $DOTFILES_BACKUP_DIR/profile
    echo "  ${green}.profile has been backed up${reset}"
}
execute_action "Backup original dotfiles" backup_original_dotfiles

################
# install necessary softwares
################
execute_action "Software installations" "source $DOTFILES_ROOT/install_softwares.sh"
# echo "${yellow}Starting to install softwares...${reset}"
# ./$DOTFILES_ROOT/install_softwares.sh
# echo "${green}Software installations finished.${reset}"

################
# setup system softlinks
################
execute_action "Softlinking dotfiles" "source $DOTFILES_ROOT/symlink-setup.sh"
# echo "${yellow}Starting soft linking...${reset}"
# source `dirname $0`/symlink-setup.sh
# echo "${green}soft linking finished.${reset}"

################
# Update .bashrc to activate dotfiles
################
function update_bashrc {
    if [[ `grep "# To include dotfiles" ~/.bashrc | wc -l` -eq 0 ]]; then
        echo "" >> ~/.bashrc
        echo "################" >> ~/.bashrc
        echo "# To include dotfiles" >> ~/.bashrc
        echo "################" >> ~/.bashrc
        echo "" >> ~/.bashrc
        for file in ~/.{exports,sources,functions,aliases,bash_prompt}; do
            [ -r "$file" ] && (echo "source \"$file\"" >> ~/.bashrc)
        done
        unset file
        echo "" >> ~/.bashrc
        echo "################" >> ~/.bashrc
    fi
}
execute_action "Adding dotfiles to .bashrc" update_bashrc

################
# clean up
################
unset black
unset red
unset green
unset yellow
unset blue
unset magenta
unset cyan
unset white
unset reset