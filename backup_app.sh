#!/bin/bash
# Backup app configuration

USER=$(whoami)
backup_dir=/home/$USER/Documents/backup/data/
mkdir -p $backup_dir

echo 'Starting backup'
echo 'SSH Keys'
cd /home/$USER/.ssh/
tar zcvf - . | gpg2 -e -r 3208496504ADBD0552D31699EAD008DA5746FED5 > $backup_dir/ssh_keys.tar.gz.gpg

echo 'Music playlists'
cp /home/$USER/.local/share/rhythmbox/playlists.xml $backup_dir

echo 'Rhythmbox conf'
cp /home/$USER/.local/share/rhythmbox/rhythmdb.xml $backup_dir

echo "Git config"
cp /home/$USER/.gitconfig $backup_dir

echo 'Syncthing' # TODO encrypt
cd /home/$USER/.config/syncthing/
tar zcvf $backup_dir/syncthing.tar.gz .

echo 'ZSH files'
cd /home/$USER/
tar zcvf $backup_dir/zsh_files.tar.gz .zsh_*

echo 'Telegram' # TODO encrypt
cd /home/$USER/.local/share/TelegramDesktop/
tar \
 --exclude='user_data' \
 -zcvf $backup_dir/telegram.tar.gz .

echo 'Calibre'
cd /home/$USER/.config/calibre/
tar zcvf $backup_dir/calibre.tar.gz .

echo 'Firefox'
cd /home/$USER/snap/firefox/common/.mozilla/firefox/
tar \
 --exclude='Crash Reports' \
 --exclude='Pending Pings' \
 -zcvf $backup_dir/firefox.tar.gz .

echo 'Thunderbird' # TODO encrypt
cd /home/$USER/.thunderbird/
tar \
 --exclude='ImapMail' \
 --exclude='Crash Reports' \
 --exclude='Pending Pings' \
 --exclude='saved-telemetry-pings' \
 --exclude='mediacache' \
 --exclude='Local Folders' \
 -zcvf $backup_dir/thunderbird.tar.gz .

echo 'Rambox' # TODO encrypt
ramboxVersion=$(snap list rambox | grep rambox  | awk '{print $3}')
cd /home/$USER/snap/rambox/${ramboxVersion}/.config/
tar \
 --exclude='Cache' \
 --exclude='Code Cache' \
 --exclude='GPUCache' \
 --exclude='databases' \
 --exclude='IndexedDB' \
 --exclude='Service Worker' \
 --exclude='Session Storage' \
 --exclude='VideoDecodeStats' \
 --exclude='webrtc_event_logs' \
 -zcvf $backup_dir/rambox.tar.gz rambox/
# Files after Fresh install :
#drwxrwxr-x  2 robby robby 4.0K Nov 18 09:48 autostart/
#drwxrwxr-x  2 robby robby 4.0K Nov 17 15:13 dconf/
#drwxrwxr-x  2 robby robby 4.0K Nov 17 15:13 fontconfig/
#drwxrwxr-x  2 robby robby 4.0K Nov 17 15:13 gtk-2.0/
#drwxrwxr-x  2 robby robby 4.0K Nov 17 15:13 gtk-3.0/
#drwxrwxr-x  2 robby robby 4.0K Nov 18 09:43 ibus/
#drwx------  2 robby robby 4.0K Nov 17 15:14 pulse/
#drwx------ 14 robby robby 4.0K Nov 18 09:45 rambox/
#-rw-rw-r--  1 robby robby  688 Nov 17 15:13 user-dirs.dirs
#-rw-rw-r--  1 robby robby   36 Nov 17 15:13 user-dirs.dirs.md5sum
#-rw-rw-r--  1 robby robby    5 Nov 17 13:30 user-dirs.locale
#-rw-rw-r--  1 robby robby   36 Nov 17 15:13 user-dirs.locale.md5sum

echo 'PhpStorm'
phpStormVersion=$(snap list phpstorm | grep phpstorm | awk '{print $2}')
cd /home/$USER/.config/JetBrains/PhpStorm${phpStormVersion}/
tar zcvf $backup_dir/phpstorm.tar.gz .

echo 'Mega Sync' # TODO encrypt
cp "/home/robby/.local/share/data/Mega Limited/MEGAsync/MEGAsync.cfg" $backup_dir

echo 'Nautilus bookmarks'
cp /home/$USER/.config/gtk-3.0/bookmarks $backup_dir

echo 'Shell extensions'
echo '- Settings'
dconf dump /org/gnome/shell/extensions/ > $backup_dir/shell_extensions_settings.txt

echo "- Extensions"
cd /home/$USER/.local/share/gnome-shell/
tar zcvf $backup_dir/gnome_extensions.tar.gz .
gsettings get org.gnome.shell enabled-extensions > $backup_dir/gnome_extensions_enabled.txt

echo 'Media keys shortcut'
dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > $backup_dir/media_keys_shortcut.txt

echo 'Favorites launcher (icons in bar)'
gsettings get org.gnome.shell favorite-apps > $backup_dir/favorites-launcher.txt

echo "Online accounts" # TODO encrypt
cp /home/$USER/.config/goa-1.0/accounts.conf $backup_dir

echo "Protonvpn" # TODO verify # TODO encrypt
cp /home/$USER/.config/protonvpn/user_configurations.json $backup_dir/protonvpn-user_configurations.json
cd /home/$USER/.cert/nm-openvpn
tar zcvf $backup_dir/protonvpn.tar.gz .

echo 'Digikam'
cd /home/$USER/.config/
tar zcvf $backup_dir/digikam.tar.gz *digikam*

echo "Joplin" # TODO is it enough
cp /home/$USER/.config/joplin-desktop/settings.json $backup_dir/joplin-settings.json


# echo 'TODO Filezilla' # TODO

exit 0
