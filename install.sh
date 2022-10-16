#!/bin/bash


create_service() {
    cp custom_look/custom_theme.sh /usr/local/bin
    cp custom_look/custom_theme.service /etc/systemd/system
    chmod 744 /usr/local/bin/custom_theme.sh
    chmod 644 /etc/systemd/system/custom_theme.service
    systemctl daemon-reload
    systemctl enable --now custom_theme.service
}

select_user() {
    user_ids=(`grep -E '^UID_MIN|^UID_MAX' /etc/login.defs |awk '{print $2}'`)
    user_list=$(printf "{${user_ids[0]}..%s}" "${user_ids[@]:1}")

    user_list="{1000..1001}"

    output=$(eval "getent passwd "${user_list[@]}" |cut -d ":" -f1")
    output+=("All")
}

append_bash() {
    if [ "$(grep  $(pwd)/global_theme.sh /home/wissem/.bashrc)" = "" ]
    then
        echo "sh $(pwd)/global_theme.sh" >> /home/wissem/.bashrc 
    fi
}

echo $(kdialog --password "sudo password required") | sudo -S bash -c "$(declare -f create_service); create_service"

if [ ! -d "$HOME/bin" ]; then
  mkdir -p "$HOME/bin"
fi

sed -i "s|Exec=.*|Exec=$HOME/bin/global_theme|g" "custom_look/custom_theme.desktop"
cp custom_look/global_theme "$HOME/bin"
cp custom_look/custom_theme.desktop "$HOME/.config/autostart"
touch "$HOME/.config/custom_theme"



