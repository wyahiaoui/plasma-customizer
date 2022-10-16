#!/bin/bash


create_service() {
    cp custom_look/custom_theme.sh /usr/local/bin
    cp custom_look/custom_theme.service /usr/lib/systemd/system/
    chmod 744 /usr/local/bin/custom_theme.sh
    chmod 644 /usr/lib/systemd/system/custom_theme.service
    systemctl daemon-reload
    systemctl enable  custom_theme.service
}

select_user() {
    user_ids=(`grep -E '^UID_MIN|^UID_MAX' /etc/login.defs |awk '{print $2}'`)
    user_list=$(printf "{${user_ids[0]}..%s}" "${user_ids[@]:1}")

    user_list="{1000..1001}"

    output=$(eval "getent passwd "${user_list[@]}" |cut -d ":" -f1")
    output+=("All")
}

append_bash() {
    if [ "$(grep  $(pwd)/global_theme.sh /home/$USER/.bashrc)" = "" ]
    then
        echo "sh $(pwd)/global_theme.sh" >> /home/$USER/.bashrc 
    fi
}

PASS=$(kdialog --password "sudo password required")
echo $PASS | sudo -S bash -c "$(declare -f create_service); create_service"

if [ ! -d "$HOME/bin" ]; then
  mkdir -p "$HOME/bin"
fi

touch "$HOME/.config/custom_theme"
# echo $PASS | sudo -E custom_theme.sh
echo "$(ls /usr/share/sddm/themes/ |tail -1)" > "$HOME/.config/custom_theme"

cp custom_look/global_theme "$HOME/bin"

kdialog --title "Timer Or Boot" --yesno "Running it  peridically? \nNo means it starts direct after sddm"
if [ $? = 0 ]; then 
    sed -i "s|ExecStart=.*|ExecStart=$HOME/bin/global_theme|g" "custom_look/global_theme.service"
    sed -i "s|User=.*|User=$USER|g" "custom_look/global_theme.service"
    TIMER_SETTINGS=$(kdialog --title "Timer Settings" --inputbox "Set Time a in systemd, 0 or empty means only at boot (same without timer "No")" "1min")
    sed -i "s|OnBootSec=.*|OnBootSec=$TIMER_SETTINGS|g" "custom_look/global_theme.service"
    sed -i "s|OnUnitActiveSec=.*|OnUnitActiveSec=$TIMER_SETTINGS|g" "custom_look/global_theme.service"
    echo $PASS | sudo -S bash -c "cp custom_look/global_theme.service custom_look/global_theme.timer /usr/lib/systemd/user/"
    systemctl --user daemon-reload
    systemctl --user enable --now global_theme.timer
else 
    sed -i "s|ExecStart=.*|ExecStart=$HOME/bin/global_theme|g" "custom_look/custom_theme.desktop"
    cp custom_look/custom_theme.desktop "$HOME/.config/autostart"
fi







