#!/bin/bash 


echo $(kdialog --password "sudo password required") | sudo -S bash -c "rm /usr/local/bin/custom_theme.sh /etc/systemd/system/custom_theme.service" << EOF
rm "$HOME/bin/global_theme" "$HOME/.config/autostart/custom_theme.desktop"
EOF

if [ ! -d "$(ls -A $HOME/bin)" ]; then
   rm -rf $HOME/bin
fi