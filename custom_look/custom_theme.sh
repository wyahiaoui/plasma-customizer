#!/bin/bash 

ACTUAL_USER="wissem"
FILE_DST="/home/$ACTUAL_USER/.config/custom_theme"

theme_to_sddm() {
    if [[ "$theme" == com.github* ]]
    then 
        arr=(${theme//./ });
        cont_arr=${arr[@]:3};
        current=${cont_arr// /-};
    else  
        current=$(echo "$theme" | sed -r -e 's/.desktop//' -e 's/org.kde.//');
    fi 
}

themes_to_sddm() {
    for i in ${themes[@]}; 
    do 
        theme_to_sddm
    done
}   

g_themes=(`ls /usr/share/plasma/look-and-feel`) 
l_themes=(`ls /home/*/.local/share/plasma/look-and-feel`)
themes=("${g_themes[@]}" "${l_themes[@]}")
themes_count=${#themes[@]}
theme=${themes[$(( ( RANDOM % ${themes_count} )))]}
echo "$theme" > $FILE_DST
chown root:$ACTUAL_USER $FILE_DST
# export CUSTOM_THEME=$theme

sddm_themes=(`ls /usr/share/sddm/themes/`)
sddm_themes_count=${#sddm_themes[@]}
sddm_theme=${sddm_themes[$(( ( RANDOM % ${sddm_themes_count} )))]}
theme_to_sddm
echo "$current"

# echo "${themes##*.}"

if [[ " ${sddm_themes[*]} " =~ " ${current} " ]]; then
    # whatever you want to do when array contains value
    sed -i "s|Current=.*/Current=$current/g" "/etc/sddm.conf.d/kde_settings.conf"
else 
    sed -i "s/Current=.*/Current=$sddm_theme/g" "/etc/sddm.conf.d/kde_settings.conf"
fi



# lookandfeeltool -a $theme;
# lookandfeeltool -a $theme;
