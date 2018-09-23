################
# set the colors
################
yellow=`tput setaf 3`
green=`tput setaf 2`
cyan=`tput setaf 6`
reset=`tput sgr 0`

################
# backup the old stuffs
################

# set the dotfiles root directory
export DOTFILES_ROOT=`dirname $0`
echo "${green}Dotfiles root directory identified: ${cyan}$DOTFILES_ROOT${reset}"

# bakcup the old dotfiles files
echo "${yellow}Starting bakcup...${reset}"
export DOTFILES_BACKUP_DIR=$DOTFILES_ROOT/backup
mkdir -p $DOTFILES_BACKUP_DIR
echo "${green}Old dotfiles will be backed up in ${cyan}$DOTFILES_BACKUP_DIR${reset}"
cp -Rp ~/.bashrc $DOTFILES_BACKUP_DIR/bashrc
echo "${green}.bashrc has been backed up${reset}"
cp -Rp ~/.profile $DOTFILES_BACKUP_DIR/profile
echo "${green}.profile has been backed up${reset}"

################
# install necessary softwares
################


################
# setup system softlinks
################
echo "${yellow}Starting soft linking...${reset}"
source `dirname $0`/symlink-setup.sh
echo "${green}soft linking finished.${reset}"

################
# clean up
################
unset yellow
unset green
unset cyan
unset reset
