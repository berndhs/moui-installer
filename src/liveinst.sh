#!/bin/sh
#
# Simple script to kick off an install from a live CD
#
# Copyright (C) 2007  Red Hat, Inc.  All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

. /etc/init.d/functions

cmdline=$(cat /proc/cmdline)
export PATH=/sbin:/usr/sbin:$PATH

echo "instalateur"

if [ -z "$LIVE_BLOCK" ]; then
    if [ -b "/dev/mapper/live-osimg-min" ]; then
        LIVE_BLOCK="/dev/mapper/live-osimg-min"
    else
        LIVE_BLOCK="/dev/live-osimg"
    fi
fi


/sbin/swapoff -a

# if instalateur and anaconda script both exists, launch the dialog to choose 
if [ -x /usr/sbin/instalateur ] && [ -x /usr/sbin/anaconda ]; then
    MODE=`dialog --no-cancel --stdout --backtitle  "MeeGo Installer" --title "Installation mode selection" --menu "Choose the mode to start install" 0 40 0 1 "Text Mode" 2 "GUI Mode"`
    clear
    if [ $MODE = "1" ]; then
        /usr/sbin/instalateur
        exit 0
    fi
else
    # only instalateur exists
    if [ -x /usr/sbin/instalateur ]; then
        if strstr "$cmdline" nosplash ; then
            nosplash="yes"
        fi
        #set forground terminal  back to 1 in level 4 for running instalateur
        if strstr "$cmdline" " 4" && [ -z "$nosplash" ]; then
            [ -x /usr/bin/chvt ] && /usr/bin/chvt 1
        fi
        /usr/sbin/instalateur
        exit 0
    fi
fi

#no instalateur or user chose graphical, try to run anaconda
ANACONDA="/usr/sbin/anaconda --liveinst --method=livecd://$LIVE_BLOCK $INSTLANG --enablefirstboot"
export ANACONDA_PRODUCTNAME=$( cat /etc/system-release | cut -d ' ' -f 1 )
export ANACONDA_PRODUCTVERSION=$( cat /etc/system-release | sed -r -e 's/^.*([0-9]+) *\(.*$/\1/' )
export ANACONDA_BUGURL=${ANACONDA_BUGURL:="http://bugzilla.meego.com/"}

# Disable IM during installation
unset GTK_IM_MODULE

uname=$(uname -r)
if strstr "$uname" moblin && strstr "$uname" netbook ; then
    echo "You are running an meego netbook image." > /dev/tty5
    gpuid=$(lspci -s 00:02.0 -n)
    if strstr "$gpuid" 8086; then
        echo "PCIInfo for your graphics: $gpuid" > /dev/tty5
    else
        echo "PCIInfo for your graphics: $gpuid"
        echo "WARNING: Your graphics card is not in our support list, the installation might be fail on your platform!"
    fi
fi

$ANACONDA $* 2>/dev/null

# Reboot after installation is done
if strstr "$cmdline" liveinst || strstr "$cmdline" netinst || strstr "$cmdline" liveimg; then
    # check whether the installation completed sucessfully
    install_status=$( tail -n 2 /tmp/anaconda.log )
    if strstr "$install_status" "to step complete" ; then 
        #Succeed, reboot
        exec /sbin/reboot
    else
        #Failed, kill mini-wm, return to tty
        WMPID=$( ps aux | grep "/usr/bin/mini-wm" | grep -v grep | awk '{print $2}')
        echo "kill mini-wm, pid = $WMPID" > /dev/tty5
        kill -9 "$WMPID"
    fi
fi


