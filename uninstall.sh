#!/bin/bash 

PASS=$(kdialog --password "sudo password required")
echo $PASS | sudo -S bash -c "rm /usr/local/bin/custom_theme.sh /etc/systemd/system/graphical.target.wants/custom_theme.service /usr/lib/systemd/user/global_theme.*" << EOF

EOF

rm "$HOME/bin/global_theme" "$HOME/.config/custom_theme" "$HOME/.config/autostart/custom_theme.desktop"


if [ ! -d "$(ls -A $HOME/bin)" ]; then
   rm -rf $HOME/bin
fi
