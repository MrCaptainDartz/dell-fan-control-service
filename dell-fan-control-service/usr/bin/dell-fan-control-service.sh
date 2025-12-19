#!/bin/bash

# Variables
# Fan speed in %
SPEED0="0x00"
SPEED5="0x05"
SPEED10="0x0a"
SPEED15="0x0f"
SPEED20="0x14"
SPEED25="0x19"
SPEED30="0x1e"
TEMP_THRESHOLD="60" # iDRAC dynamic control enable thershold in Celcius
TEMP_SENSOR="0Eh"  # CPU 1 Temp
LOOP_COUNT=4
LOOP_DELAY=15 #seconds

for ((i=1; i<=$LOOP_COUNT; i++))
do
    # Get temperature from iDARC.
    T=$(ipmitool sdr type temperature | grep $TEMP_SENSOR | cut -d"|" -f5 | cut -d" " -f2)

    # If ambient temperature is above threshhold enable dynamic control and exit, if below set manual control.
    if [[ $T -ge $TEMP_THRESHOLD ]]
    then
        echo "--> Temperature is above $TEMP_THRESHOLD deg C"
        echo "--> Enabling dynamic fan control"
        ipmitool raw 0x30 0x30 0x01 0x01
        exit 1
    else
        echo "--> Temperature is below $TEMP_THRESHOLD deg C"
        echo "--> Disabling dynamic fan control"
        ipmitool raw 0x30 0x30 0x01 0x00
    fi

    # Set fan speed based on cpu temp
    if [ "$T" -ge 1 ] && [ "$T" -le 20 ]
    then
        echo "--> Setting fan speed to 0%"
        ipmitool raw 0x30 0x30 0x02 0xff $SPEED0

    elif [ "$T" -ge 21 ] && [ "$T" -le 40 ]
    then
        echo "--> Setting fan speed to 5%"
        ipmitool raw 0x30 0x30 0x02 0xff $SPEED5

    elif [ "$T" -ge 41 ] && [ "$T" -le 45 ]
    then
        echo "--> Setting fan speed to 10%"
        ipmitool raw 0x30 0x30 0x02 0xff $SPEED10
    elif [ "$T" -ge 46 ] && [ "$T" -le 50 ]
    then
        echo "--> Setting fan speed to 15%"
        ipmitool raw 0x30 0x30 0x02 0xff $SPEED15
    elif [ "$T" -ge 51 ] && [ "$T" -le 55 ]
    then
        echo "--> Setting fan speed to 20%"
        ipmitool raw 0x30 0x30 0x02 0xff $SPEED20
    elif [ "$T" -ge 56 ] && [ "$T" -le 60 ]
    then
        echo "--> Setting fan speed to 30%"
        ipmitool raw 0x30 0x30 0x02 0xff $SPEED30
    fi

    if [ $i -lt $LOOP_COUNT ]; then
    echo "Waiting $LOOP_DELAY seconds..."
    sleep $LOOP_DELAY
    fi
done
echo "=== SCRIPT END ==="