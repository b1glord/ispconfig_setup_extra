	if [[ ! "$CFG_HHVM" =~ $RE ]]; then
	if (whiptail --title "HHVM" --backtitle "$WT_BACKTITLE" --nocancel --radiolist "Do you want to install HHVM (Hip Hop Virtual Machine) as PHP engine?" 10 50 2 "no" "(default)" ON "yes" "" OFF 3>&1 1>&2 2>&3) then
			CFG_HHVM=yes
		else
			CFG_HHVM=no
		fi
	fi
