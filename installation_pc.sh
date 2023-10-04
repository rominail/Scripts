#!/bin/bash
# Script (ansible-like) to install everything on my laptop as before reset (conf, soft, ...)

sudo -v -u $USER
backup_dir=/home/$USER/Documents/backup/data/

# Basics requirements
echo "Installing basics requirements"
sudo apt -y install curl wget

echo
echo "------------"
echo

echo "Adding keys"
# Keys
sudo mkdir -p --mode=0755 /usr/share/keyrings

# Signal
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee -a /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
rm signal-desktop-keyring.gpg

# Cloudflare
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null

# Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo
echo "------------"
echo

echo "Adding repositories"
sudo add-apt-repository ppa:ondrej/php -y
sudo add-apt-repository ppa:helkaluin/webp-pixbuf-loader -y # Support webp in eog (image viewer)
echo "deb https://apt.syncthing.net/ syncthing stable" | tee /etc/apt/sources.list.d/syncthing.list

# Signal
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
  sudo tee -a /etc/apt/sources.list.d/signal-xenial.list

# Cloudflare
echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared jammy main' | sudo tee /etc/apt/sources.list.d/cloudflared.list

# Docker
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#Protonvpn
wget -O protonvpn.deb https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.3-2_all.deb
sudo apt install ./protonvpn.deb
rm protonvpn.deb

echo
echo "------------"
echo

echo "Cleaning some packages"
# Prerequis pour certain paquets
# sudo apt purge laptop-mode-tools test en gardant ca et ne pas installer tlp tlp-rdw 

echo
echo "------------"

echo "apt update"
sudo apt update

echo
echo "------------"
echo "------------"
echo "------------"
echo
echo "Installing apt applications" # TODO vérifier si tous les paquets sont toujours d'actualité
sudo apt -y install git npm ubuntu-restricted-extras libgconf-2-4 net-tools fonts-symbola gnome-tweaks syncthing vlc gimp streamer scrot pngnq filezilla gnupg2 audacity htop traceroute k3b apache2 php libapache2-mod-php mysql-server php-mysql php-curl php-xml php-json php-mbstring php-zip php-gd php-intl php-xdebug dconf-editor acpi gparted pv testdisk ffmpeg libimage-exiftool-perl jhead default-jre xsel mmv screen apt-transport-https digikam zsh openvpn dialog python3-pip python3-setuptools python3-distutils python3-apt android-tools-adb stacer openssh-server gnome-shell-extension-gsconnect mlocate signal-desktop libheif-examples fdupes gnome-shell-extension-manager cloudflared dnscrypt-proxy heif-gdk-pixbuf heif-thumbnailer webp-pixbuf-loader chromium-browser libcurl4-openssl-dev libssl-dev clamav rkhunter cpulimit build-essential python3-dev timeshift vim exfat-fuse exfatprogs gedit diodon protonvpn python3-ipy \
docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin # Docker
# protonvpn python-pycurl??
# Apres rkhunter j'ai une demande de validation pour une police qui a buggué
# indicator-sound-switcher mongodb-org
# TMP 
# libqtwebkit4
# python-requests deja installé de base
# pour pombo comme python3-mss n'existe pas: sudo python3 -m pip install -U --user mss --break-system-packages

echo
echo "------------"
echo

echo "Installing snap applications"
sudo snap install rambox picard jdownloader2 plexmediaserver retroarch
sudo snap install phpstorm --classic
# pycharm-community --classic
# brave
# opera insomnia
sudo snap refresh

echo
echo "------------"
echo

echo "Installing flatpack applications"
# TODO Test if it works
#echo "flatpak / pika / contacts / Todo (endeavour)"
# sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo
echo "------------"
echo

echo "Installing others applications"
echo " - Mega.nz"
current_version=$(lsb_release -rs)
wget https://mega.nz/linux/repo/xUbuntu_${current_version}/amd64/megasync-xUbuntu_${current_version}_amd64.deb
sudo apt -y install ./megasync-xUbuntu_${current_version}_amd64.deb
rm -f megasync-xUbuntu_${current_version}_amd64.deb
echo " - Nautilus integration"
wget https://mega.nz/linux/repo/xUbuntu_${current_version}/amd64/nautilus-megasync-xUbuntu_${current_version}_amd64.deb
sudo apt -y install ./nautilus-megasync-xUbuntu_${current_version}_amd64.deb
rm nautilus-megasync-xUbuntu_${current_version}_amd64.deb

echo
echo "------------"
echo

echo " - Telegram"
wget -O telegram.tar.xz https://telegram.org/dl/desktop/linux
sudo tar Jxvf telegram.tar.xz -C /opt/
sudo mv /opt/Telegram /opt/telegram
sudo mv /opt/telegram/Telegram /opt/telegram/telegram
sudo mv /opt/telegram/Updater /opt/telegram/telegram-updater
sudo ln -s /opt/telegram/telegram-updater /usr/local/bin/telegram-updater
sudo ln -s /opt/telegram/telegram /usr/local/bin/telegram
rm -f telegram.tar.xz

echo
echo "------------"
echo

echo " - Joplin"
wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash

echo
echo "------------"
echo
echo

echo " - Calibre"
sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin

echo
echo "------------"
echo
echo

echo " - TeamViewer"
sudo -v && wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
sudo apt -y install ./teamviewer_amd64.deb
rm -f teamviewer_amd64.deb

echo
echo "------------"
echo

echo "Installing custom applications / frameworks / libraries"
echo "Installing pip"
sudo curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
rm -f get-pip.py

# sudo ?? Sinon installé dans ~/.local/bin
echo "Installing eyeD3"
sudo pip install eyeD3

echo "Installing pyLoad"
pip install pyload-ng

echo
echo "------------"
echo

echo "Disabling services on startup"

sudo systemctl disable apache2
sudo systemctl disable mysql
sudo systemctl disable teamviewerd
sudo systemctl disable snap.plexmediaserver.plexmediaserver.service

echo
echo "------------"
echo
echo

echo "Disabling services on startup"
echo "Add curent user to docker group"
sudo usermod -aG docker $USER

echo
echo "------------"
echo

echo "Setting ZSH as default and Installing oh-my-zsh"

sudo chsh -s /usr/bin/zsh

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"

echo 'for file in ~/.zsh_{aliases,functions}; do' >> ~/.zshrc
echo '	[ -r "$file" ] && [ -f "$file" ] && source "$file"' >> ~/.zshrc
echo 'done' >> ~/.zshrc
echo 'unset file' >> ~/.zshrc

echo "Importing zsh configuration files"
tar -xvzf $backup_dir/zsh_files.tar.gz -C /home/$USER/

# TODO for root ? to verify => seems not to work
#sudo -s -- 'chsh -s /usr/bin/zsh'
#sudo -s -- 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"'
#sudo -s -- 'cp /home/$USER/.zsh* /root/'
#test avec
sudo su -c 'chsh -s /usr/bin/zsh'
sudo su -c 'wget -O- https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh -s stdin --unattended'
#sudo -s su -c 'wget -O- https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh -s stdin --unattended'
#sudo su -c 'cp /home/robby/.zsh* /root/' # J'ai pas vraiment cherché ni réussi à remplacer robby par user
sudo su -c '`echo 'cp /home/${USER}/.zsh* /root/'`' # TODO does the one above work?

echo
echo "------------"
echo

echo "Installing cloudflare DNS (1.1.1.1) with DOH"
cloudflared --version
if [ $? -eq 0 ]; then
# TODO Didn't work and make the internet connection bugging || To verify
	sudo cloudflared proxy-dns &!
	echo "DNS test before instalation of DNS Over HTTPS :" # TODO
	# dig +short @127.0.0.1 cloudflare.com AAAA
	sudo tee /etc/systemd/system/cloudflared-proxy-dns.service >/dev/null <<EOF
[Unit]
Description=DNS over HTTPS (DoH) proxy client
Wants=network-online.target nss-lookup.target
Before=nss-lookup.target

[Service]
AmbientCapabilities=CAP_NET_BIND_SERVICE
CapabilityBoundingSet=CAP_NET_BIND_SERVICE
DynamicUser=yes
ExecStart=/usr/local/bin/cloudflared proxy-dns

[Install]
WantedBy=multi-user.target
EOF
	sudo systemctl enable --now cloudflared-proxy-dns
	sudo rm -f /etc/resolv.conf
	echo nameserver 127.0.0.1 | sudo tee /etc/resolv.conf >/dev/null
	echo "Test of DNS Over HTTPS :" # TODO
	# dig +short @127.0.0.1 cloudflare.com AAAA
	echo "Setting up DNScrypt"
	sudo sed -i "s/#*[[:space:]]*\(server_names\).*/\1 = \['cloudflare', 'cloudflare-ipv6'\]/g" /etc/dnscrypt-proxy/dnscrypt-proxy.toml
	echo "Test"
	cd /etc/dnscrypt-proxy/
	dnscrypt-proxy -resolve cloudflare-dns.com
	sudo systemctl enable dnscrypt-proxy
else
	echo "Error with cloudflared installation"
fi
# Pour vérifier si DoH fonctionne visiter https://1.1.1.1/help

echo
echo "------------"
echo

echo "Setting webserver (apache, mysql, php)"
sudo a2enmod rewrite
echo " Creating symbolic link"
sudo rm -rf /var/www/html/
sudo ln -s /home/$USER/Developpement/ /var/www/html
echo " Setting up rights"
chmod 711 /home/$USER
PHP_VERSION=$(php -v | head -n 1 | cut -b5-7)
echo " Adding php $PHP_VERSION extension in apache conf"
#sudo sed -i -e 's/;extension=ctype/extension=ctype/g' /etc/php/$PHP_VERSION/apache2/php.ini
echo " Installing composer"
EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"
if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi
sudo php composer-setup.php --quiet --install-dir=/usr/local/bin --filename=composer
#RESULT=$?
rm composer-setup.php

echo
echo "------------"
echo

echo "Gnome extensions"
mkdir -p /home/$USER/.local/share/gnome-shell/
tar -xvzf $backup_dir/gnome_extensions.tar.gz -C /home/$USER/.local/share/gnome-shell/

echo "Enabling them"
# TODO a vérifer
gsettings set org.gnome.shell enabled-extensions "`cat $backup_dir/gnome_extensions_enabled.txt`"

echo
echo "------------"
echo

echo "Importing profile/settings :" # Should all be similar to plex and gpg2 encrypted
echo " - Thunderbird"
mkdir -p /home/$USER/.thunderbird/
tar -xvzf $backup_dir/thunderbird.tar.gz -C /home/$USER/.thunderbird/

echo " - Firefox"
#mkdir -p /home/$USER/
tar -xvzf $backup_dir/firefox.tar.gz -C /home/$USER/snap/firefox/common/.mozilla/firefox/

echo " - Rambox"
ramboxVersion=$(snap list rambox | grep rambox  | awk '{print $3}')
#mkdir -p /home/$USER/snap/rambox/current/.config/
tar -xvzf $backup_dir/rambox.tar.gz -C /home/$USER/snap/rambox/${ramboxVersion}/.config/

echo " - Telegram"
rm -rf /home/$USER/.local/share/TelegramDesktop/
mkdir -p /home/$USER/.local/share/TelegramDesktop/
tar -xvzf $backup_dir/telegram.tar.gz -C /home/$USER/.local/share/TelegramDesktop/
# TODO if it doest work, start it, wait and kill it to create conf/pref files see a couple of line below the other part

echo '- PhpStorm'
phpStormVersion=$(snap list phpstorm | grep phpstorm | awk '{print $2}')
rm -rf /home/$USER/.config/JetBrains/PhpStorm${phpStormVersion}/*
mkdir -p /home/$USER/.config/JetBrains/PhpStorm${phpStormVersion}/
tar -xvzf $backup_dir/phpstorm.tar.gz -C /home/$USER/.config/JetBrains/PhpStorm${phpStormVersion}/

# TODO to verify
echo " - Calibre"
mkdir -p /home/$USER/.config/calibre/
tar -xvzf $backup_dir/calibre.tar.gz -C /home/$USER/.config/calibre/

echo " - Pombo"
sudo cp $backup_dir/pombo /usr/local/bin/
sudo cp $backup_dir/pombo.conf /etc/
sudo chmod 700 /usr/local/bin/pombo
sudo chmod 600 /etc/pombo.conf
sudo chown root:root /usr/local/bin/pombo
sudo chown root:root /etc/pombo.conf

echo " - Synchthing"
mkdir -p /home/$USER/.config/syncthing/
tar -xvzf $backup_dir/syncthing.tar.gz -C /home/$USER/.config/syncthing/

echo ' - Mega Sync' # TODO to verify
mkdir -p "/home/$USER/.local/share/data/Mega Limited/MEGAsync/"
cp $backup_dir/MEGAsync.cfg "/home/$USER/.local/share/data/Mega Limited/MEGAsync/MEGAsync.cfg"

echo " - Music playlists"
mkdir -p /home/$USER/.local/share/rhythmbox/
cp $backup_dir/playlists.xml /home/$USER/.local/share/rhythmbox/

echo '- Rhythmbox conf' # TODO to verify / is it enough?
cp $backup_dir/rhythmdb.xml /home/$USER/.local/share/rhythmbox/

echo " - Rhythmbox plugins"
git clone https://github.com/donaghhorgan/rhythmbox-plugins-open-containing-folder.git
cd rhythmbox-plugins-open-containing-folder
./install.sh
cd ..
rm -rf rhythmbox-plugins-open-containing-folder

echo " - Git config"
cp $backup_dir/.gitconfig /home/$USER/

echo '- Nautilus bookmarks'
cp $backup_dir/bookmarks /home/$USER/.config/gtk-3.0/bookmarks

echo '- Nautilus scripts'
cp "$backup_dir/Create hard link" /home/$USER/.local/share/nautilus/scripts/

echo '- Shell extensions'
cat $backup_dir/shell_extensions_settings.txt | dconf load /org/gnome/shell/extensions/

echo "- Online accounts"
cp $backup_dir/accounts.conf /home/$USER/.config/goa-1.0/accounts.conf

echo '- ClamAV + Rootkit Hunter'
sudo systemctl disable clamav-freshclam
sudo systemctl stop clamav-freshclam
sudo cp $backup_dir/clamav-scan.sh /etc/cron.weekly/ && sudo chmod 700 /etc/cron.weekly/clamav-scan.sh
sudo cp $backup_dir/rkhunter.default /etc/default/rkhunter && sudo chmod 644 /etc/default/rkhunter
sudo cp $backup_dir/rkhunter.local /etc/rkhunter.conf.local && sudo chmod 644 /etc/rkhunter.conf.local

echo "- Protonvpn" # TODO to verify
cp $backup_dir/protonvpn-user_configurations.json /home/$USER/.config/protonvpn/user_configurations.json
mkdir -p /home/$USER/.cert/nm-openvpn
tar -xvzf $backup_dir/protonvpn.tar.gz -C /home/$USER/.cert/nm-openvpn/


echo '- Digikam' # TODO to verify
cd /home/$USER/.config/
tar -xvzf $backup_dir/digikam.tar.gz /home/$USER/.config/

echo "Joplin" # TODO to verify / is it enough?
cp $backup_dir/joplin-settings.json /home/$USER/.config/joplin-desktop/settings.json

echo
echo "------------"
echo

echo "Adding programs on startup"
#ll /etc/xdg/autostart/
mkdir -p /home/$USER/.config/autostart

cp /usr/share/applications/syncthing-start.desktop /home/$USER/.config/autostart/

cp /usr/share/applications/thunderbird.desktop /home/$USER/.config/autostart/

ramboxPath=$(which rambox)
ramboxVersion=$(snap info rambox | grep installed | cut -d'(' -f2 | cut -d')' -f1)
cp "snap/rambox/${ramboxVersion}/.config/autostart/rambox.desktop" /home/$USER/.config/autostart/
sed -i "s|Exec=.*|Exec=${ramboxPath} --hidden|g" /home/$USER/.config/autostart/rambox.desktop

# TODO to verify, test opening it and closing it, seems *telegram*.desktop n'existe pas avant d'etre ouvert
telegram &!
telegramPid=$!
sleep 5
kill ${telegramPid}
cp /home/$USER/.local/share/applications/*telegram*.desktop /home/$USER/.config/autostart/

cp /usr/share/applications/megasync.desktop /home/$USER/.config/autostart/
# TODO to verify they are correct

echo
echo "------------"
echo

echo "Script for natural scrolling"
cp $backup_dir/natural_scroll.desktop /home/$USER/.local/share/applications/


echo
echo "------------"
echo

echo "Restoring crontab"
sudo tar -xvzf $backup_dir/crontabs.tar.gz -C /var/spool/cron/crontabs/

echo
echo "------------"
echo

echo "Gnome configuration"

echo "- Display battery percentage"
gsettings set org.gnome.desktop.interface show-battery-percentage true

echo "- Suspension time"
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 900
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'suspend'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 1200

echo "- Display weekday"
gsettings set org.gnome.desktop.interface clock-show-weekday true

echo "- French format"
sudo cp /etc/default/locale /etc/default/locale.bak
cat /etc/default/locale.bak | sed 's/en_US/fr_FR/g' > /home/$USER/locale.tmp
sudo cp /home/$USER/locale.tmp /etc/default/locale
rm /home/$USER/locale.tmp
cat /etc/default/locale

echo "- Disabling screen lock"
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.lockdown disable-lock-screen 'true'
# Current state :
# gsettings get org.gnome.desktop.lockdown disable-lock-screen

echo "- Dark mode"
gsettings set org.gnome.desktop.interface gtk-theme Yaru-dark # Legacy apps, can specify an accent such as Yaru-olive-dark
gsettings set org.gnome.desktop.interface color-scheme prefer-dark # new apps
gsettings reset org.gnome.shell.ubuntu color-scheme # if changed above

echo "- Custom Shortcuts"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Diodon"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "/usr/bin/diodon"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Primary><Alt>H"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"

echo '- Media keys shortcut'
cat $backup_dir/media_keys_shortcut.txt | dconf load /org/gnome/settings-daemon/plugins/media-keys/

echo '- Hide home folder on desktop'
gsettings set org.gnome.shell.extensions.ding show-home false

echo '- Natural scroll'
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false

echo '- Night mode'
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true

echo '- Favorites launcher (icons in bar)'
gsettings set org.gnome.shell favorite-apps "`cat $backup_dir/favorites-launcher.txt`"

echo '- Week number in calendar'
gsettings set org.gnome.desktop.calendar show-weekdate true

echo '- Gnome-shell ext : Quarter Windows shortcut'
dconf write /org/gnome/shell/extensions/com-troyready-quarterwindows/put-to-corner-ne "['<Super>KP_9']"
dconf write /org/gnome/shell/extensions/com-troyready-quarterwindows/put-to-corner-se "['<Super>KP_3']"
dconf write /org/gnome/shell/extensions/com-troyready-quarterwindows/put-to-corner-se "['<Super>KP_3']"
dconf write /org/gnome/shell/extensions/com-troyready-quarterwindows/put-to-corner-sw "['<Super>KP_1']"
dconf write /org/gnome/shell/extensions/com-troyready-quarterwindows/put-to-corner-nw "['<Super>KP_7']"

# TODO default app => cat ~/.config/mimeapps.list

echo
echo "------------"
echo

echo "Setting Wallpaper"
if [[ -f "/home/$USER/Images/Papiers peints/hawai.jpg" ]]
	cp "/home/$USER/Photos/2019 vacances usa hawaii indonesie/2019-08-22-15-15-35 Hawaï Maui.jpg" "/home/$USER/Images/Papiers peints/hawai.jpg"
fi
gsettings set org.gnome.desktop.background color-shading-type 'solid'
gsettings set org.gnome.desktop.background picture-options 'zoom'
gsettings set org.gnome.desktop.background primary-color '#000000'
gsettings set org.gnome.desktop.background secondary-color '#000000'
gsettings set org.gnome.desktop.background picture-uri "file:///home/$USER/Images/Papiers peints/hawai.jpg"    
gsettings set org.gnome.desktop.background picture-uri-dark "file:///home/$USER/Images/Papiers peints/hawai.jpg"

echo
echo "------------"
echo

echo
echo "------------"
echo

# echo "SSH keys generation : " Useless???
# echo "ssh-keygen -t rsa -b 4096" # TODO

echo
echo "------------"
echo

echo "Importing GPG keys"
cd /home/$USER/
gpg2 --import $backup_dir/gpg2-local-backup-secretkeys.asc
gpg2 --import $backup_dir/gpg2-pubkeys.asc
gpg2 -d $backup_dir/gpg2-secretkeys.asc.gpg > tmp-keys.asc
gpg2 --import tmp-keys.asc
rm tmp-keys.asc
echo "To verify GPG keys"
gpg2 -K # secret
gpg2 -k # public
# le reste semble inutile
# sudo -H gpg --import "Clé Pombo"
# gpg2 --import KEY LIST
# cd "/home/$USER/Documents/PC/Clés chiffrement/GPG2"
# gpg2 --import Robby\ ROUDON\ *
# TODO for pombo
cd "/home/$USER/Documents/PC/Clés chiffrement/GPG2"
sudo -H gpg --import Robby\ ROUDON\ \(Clé\ pour\ Pombo\)\ robby.roudon@protonmail.com\ \(0xF9FA848851770714\)\ pub.asc

# TODO trust keys
#gpg2 --list-keys
#gpg2 --edit-key KEY_ID trust quit (puis 5 et oui)

echo
echo "------------"
echo

echo "SSH configuration"
sudo systemctl enable ssh
file=/etc/ssh/sshd_config
sudo sed -i "s/#[[:space:]]*\(PermitRootLogin\).*/\1 no/g" $file
echo " - Importing keys"
mkdir -p /home/$USER/.ssh/
cd /home/$USER/.ssh/
gpg2 -d $backup_dir/ssh_keys.tar.gz.gpg | tar -xvzf -

echo
echo "------------"
echo

echo "Importing profile/settings necessiting GPG2 decryption :"

echo " - Plex"
# TODO Didn't work, probably because I switched to snap
gpg2 -d $backup_dir/Preferences_Plex.xml.gpg > "/var/snap/plexmediaserver/common/Library/Application Support/Plex Media Server/Preferences.xml"
#cp $backup_dir/Preferences_Plex.xml > "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Preferences.xml"

echo
echo "------------"
echo

echo "Symbolic links for home dir :"

echo " - .Downloads :"
ln -s /home/$USER/Téléchargements /home/$USER/.Downloads

echo " - Musique :"
rm -rf Musique
ln -s /mnt/hdd/Musique /home/$USER/Musique

echo
echo "------------"
echo

echo "Changing mount point for HDD"
# TODO to verify, reboot necessary?
sudo su -c 'echo "/dev/sda2 /mnt/hdd/ auto nosuid,nodev,nofail,x-gvfs-show,noauto,x-gvfs-name=HDD 0 0" >> /etc/fstab'


echo "Remaining packages to install manually"
echo "master pdf sudo apt install /mnt/hdd/Installateur/master-pdf-editor-4.3.89_qt5.amd64.deb"

echo "Special packages not installed :"
echo "Anbox pulseaudio-dlna"	
echo "sudo apt purge wslu if needed if can't open from activities/search via windows button" # open a file do not work .txt or .ods do not open gedit or excel from search/activities
# TODO default app => cat ~/.config/mimeapps.list
echo "Default app to open : cat ~/.config/mimeapps.list"
echo "etapes_installation.txt"
echo "integreted account in ubuntu => works?"
echo "flatpak / pika / contacts / Todo (endeavour)"
echo "if protonvpn dont work sudo pip install -U pyopenssl cryptography"


#     ___        __           
#    |_ _|_ __  / _| ___  ___ 
#     | || '_ \| |_ / _ \/ __|
#     | || | | |  _| (_) \__ \
#    |___|_| |_|_|  \___/|___/
#	
#	acpi						Informations batterie
#
#	build-essential				Librairies requises pour pycurl => pyload
#
#	clamav rkhunter cpulimit	securite
#
#	dconf-editor				Edition parametres "cachés"
#	
#	default-jre					Java
#
#	dialog						Requis pour protonvpn
#	
#	digikam						Album photos
#	
#	dolphin-emu					Emulateur
#	
#	evolution					thunderbird like with contacts tasks and agenda integrated
#	
#	
#	fonts-symbola				Police avec des symboles pour thunderbird
#	
#	geany						Text editor for coding
#	
#	
#	
#	handbrake					file format conversion
#	
#	
#	jhead						Manipulation datetime photos
#	
#	libgconf-2-4				Librairies requises pour rambox
#
#	libimage-exiftool-perl		Manipulation datetime photos
#
#	libcurl4-openssl-dev		Librairies requises pour pycurl => pyload (entre autres)
#
#	libssl-dev					Librairies requises pour pycurl => pyload (entre autres)
#	
#	net-tools					Librairies requises pour rambox
#	
#	openvpn						Requis pour protonvpn
#	
#	picard						music brainz picard => renommer de la musique
#	
#	
#	pngnq						Compression image
#	
#	python3-pip					Requis pour protonvpn
#	
#	python-pycurl				Librairies requises pour pycurl => pyload
#	
#	python3-setuptools			Requis pour protonvpn
#	
#	
#	pv							Timeline with pipe
#	
#	
#	scrot						Screenshot
#	
#	shotcut						Montage video
#	
#	stacer						cleaning pc
#	
#	streamer					Capture webcam
#	
#	
#	sysprof						profiler le systeme, enregistre pour faire des analyses d'un logiciel
#	
#	testdisk
#	
#	timeshift					incremental backup
#	
#	tlp tlp-rdw					Gestionnaire de batterie
#	
#	
#	ubuntu-restricted-extras	codecs
#	
#	
#	
#	
#	
#	xsel						higlighted text
#	
#	
#	
#	yuzu (a DL)					Emulation switch (a besoin de firmware (avec mii pour mario kart) + keys
#	 ou Ryujinx
#	
#	
#	
#	
#	
#	
#	
#	
#	
#	
#	
#	
#	
#	
#	
#	
#	
#	
#	
#	
#	
#	
#	
#	
#	
#	
#	
#	
#	
#	
#	






