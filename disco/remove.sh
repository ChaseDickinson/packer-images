#!/bin/bash

#pause before beginning install
sleep 10

#remove unwanted applications
echo -e '\n ... Uninstalling Bloat ... \n'
echo $PASSWORD | sudo -S apt-get remove --purge -qq -y thunderbird transmission-gtk gnome-todo baobab rhythmbox cheese vino shotwell totem usb-creator-gtk deja-dup gnome-calendar remmina simple-scan thunderbird-gnome-support aisleriot gnome-mahjongg gnome-mines gnome-sudoku branding-ubuntu libreoffice-style-breeze libreoffice-gnome libreoffice-writer libreoffice-calc libreoffice-impress libreoffice-math libreoffice-draw libreoffice-ogltrans libreoffice-pdfimport libreoffice-l10n-en-gb libreoffice-l10n-es libreoffice-l10n-zh-cn libreoffice-l10n-zh-tw libreoffice-l10n-pt libreoffice-l10n-pt-br libreoffice-l10n-de libreoffice-l10n-fr libreoffice-l10n-it libreoffice-l10n-ru libreoffice-l10n-en-za libreoffice-help-en-gb libreoffice-help-es libreoffice-help-zh-cn libreoffice-help-zh-tw libreoffice-help-pt libreoffice-help-pt-br libreoffice-help-de libreoffice-help-fr libreoffice-help-it libreoffice-help-ru libreoffice-help-en-us thunderbird-locale-en thunderbird-locale-en-gb thunderbird-locale-en-us thunderbird-locale-es thunderbird-locale-es-ar thunderbird-locale-es-es thunderbird-locale-zh-cn thunderbird-locale-zh-hans thunderbird-locale-zh-hant thunderbird-locale-zh-tw thunderbird-locale-pt thunderbird-locale-pt-br thunderbird-locale-pt-pt thunderbird-locale-de thunderbird-locale-fr thunderbird-locale-it thunderbird-locale-ru ubuntu-web-launchers

#removing leftovers
echo -e '\n ... Cleaning Up ... \n'
echo $PASSWORD | sudo -S apt-get autoremove

#reboot
echo -e '\n ... Rebooting ... \n'
echo $PASSWORD | sudo -S reboot