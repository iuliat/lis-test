#!/bin/bash

########################################################################
#
# Linux on Hyper-V and Azure Test Code, ver. 1.0.0
# Copyright (c) Microsoft Corporation
#
# All rights reserved. 
# Licensed under the Apache License, Version 2.0 (the ""License"");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0  
#
# THIS CODE IS PROVIDED *AS IS* BASIS, WITHOUT WARRANTIES OR CONDITIONS
# OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
# ANY IMPLIED WARRANTIES OR CONDITIONS OF TITLE, FITNESS FOR A PARTICULAR
# PURPOSE, MERCHANTABLITY OR NON-INFRINGEMENT.
#
# See the Apache Version 2.0 License for specific language governing
# permissions and limitations under the License.
#
########################################################################

# Description:
#	To check if there is any call trace present in dmesg.	


echo "########################################################"
echo "	To check if there is any call trace present in dmesg.	"

DEBUG_LEVEL=3

dbgprint()
{
    if [ $1 -le $DEBUG_LEVEL ]; then
        echo "$2"
    fi
}

UpdateTestState()
{
    echo $1 > $HOME/state.txt
}

if [ -e ~/summary.log ]; then
    dbgprint 1 "Cleaning up previous copies of summary.log"
    rm -rf ~/summary.log
fi

cd ~

#
# Convert any .sh files to Unix format
#

dos2unix -f *.sh > /dev/null  2>&1

# Source the constants file

if [ -e ~/constants.sh ]; then
 . ~/constants.sh
else
 echo "ERROR: Unable to source the constants file."
 exit 1
fi


#
# Create the state.txt file so the ICA script knows
# we are running


UpdateTestState "TestRunning"

echo "Test: Checking if there is any call trace in dmesg  "


dmesg > /root/dmesg

CALL_TRACE=`cat /root/dmesg | grep -i "Call Trace"`

if [  "$CALL_TRACE" != "" ] ; then
	
	 echo -e "Test Fail : Call trace is present in dmesg"
	 echo "Call trace is present in dmesg" >> ~/summary.log
	 UpdateTestState "TestFailed"
	 dmesg
	 exit 1
else
	echo "No call trace in dmesg"
	echo "No call trace in dmesg" >> ~/summary.log
        dmesg


fi

rm -rf /root/dmesg

echo "#########################################################"
echo "Result : Test Completed Succesfully"
dbgprint 1 "Exiting with state: TestCompleted."
UpdateTestState "TestCompleted"

 
