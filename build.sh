#!/bin/bash

# ---------------------------------------------------------
# >>> Init Vars
  HOMEDIR=${PWD}
  # JOBS=`cat /proc/cpuinfo | grep processor | wc -l`;
  # If you uncomment the "JOBS" var make sure you comment the 
  # "JOBS" var down below in the build config
# ---------------------------------------------------------

# ---------------------------------------------------------
# >>> AOSP S4
# >>> Copyright 2013 broodplank.net
# >>> REV2
# ---------------------------------------------------------

# ---------------------------------------------------------
# >>> Check for updates before starting?
#
  CHECKUPDATES=0        # 0 to disable, 1 for repo sync 
  MAKEPARAM=""          # set make param, like -k 
# ---------------------------------------------------------

# ---------------------------------------------------------
#
# >>> BUILD CONFIG
#
# ---------------------------------------------------------
#
# >>> Main Configuration (intended for option 6, All-In-One) 
#
  JOBS=5                 # CPU Cores + 1 (also hyperthreading)
  MAKEOTAPACKAGE=1       # Make installable zip from output
# ---------------------------------------------------------


if [[ "${CHECKUPDATES}" == "1" ]]; then

	clear
	echo "----------------------------------------"
	echo "- Syncing repositories...              -"
	echo "----------------------------------------"
	repo sync
	clear
else
	echo
	echo "Skipping repo sync"
	clear
fi


export USEROLD=`whoami`;
export ULENGTH=`expr length ${USEROLD}`
if [[ ${ULENGTH} -gt 9 ]]; then
	clear
	echo
	echo
	echo "----------------------------------------"
	echo "-        Eclipse AOSP 4.3               -"
	echo "----------------------------------------"
	echo
	echo "Your username seems to exceed the max of 9 characters (${ULENGTH} chars)"
        echo "Due to a temp issue the max amount of characters is limited"
        echo "If the limit is exceeded the camera refuses to take pictures"
	echo 
	echo "Do you want to pick a new username right now that's below 9 chars? ( y / n )"
	read choice
	echo
	if [ ${choice} == "y" ]; then
		echo "New username:"
		read username
		export USER=${username}
		echo
		echo "Replacing values in build.prop after building"
		echo
	else
		echo "Taking pictures with camera won't work, you're warned!"
		echo
	fi;
fi;


. build/envsetup.sh
clear
echo
echo
echo "----------------------------------------"
echo "-         AOSP 4.3 FOR I9505           -"
echo "----------------------------------------"
echo
echo
echo " >>> Choosing full_jfltexx-userdebug"
echo
echo
lunch full_jfltexx-userdebug
echo
echo
busybox sleep 2
clear


echo " "	
echo "----------------------------------------"
echo "-        Compiling AOSP 4.3            -"
echo "-  Number of simultaneous jobs: ${JOBS}      -"
echo "----------------------------------------"
echo " "
busybox sleep 1
echo "Building!"
echo " "
make -j${JOBS} ${MAKEPARAM}



if [[ "$MAKEOTAPACKAGE" == "1" ]]; then
	make otapackage -j ${JOBS} ${MAKEPARAM}
else 
	echo "Skipping otapackage"
fi;

