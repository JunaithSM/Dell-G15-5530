#!/bin/bash
#Must run as root!!!!
if [[ $EUID -ne 0 ]]; then
    echo "Error: This script must be run as root. Use sudo:"
    echo -e "run:\nsudo $0 $@"
    exit 1
fi

#Fan main control Script
#Don't change below this
fan1="0x32" 
fan2="0x33"
sets="0x15"
gets="0x14"
set_boost="0x02"
get_boost="0x0c"
fan_rpm="0x05"
#-------------------

fan1_speed=10
fan2_speed=10
set_fan_boost(){
	if ! [[ "$2" =~ ^[0-9]+$ ]] || [ "$2" -lt 0 ] || [ "$2" -gt 100 ]; then
		echo "Error: Fan speed must be an integer between 0 and 100." >&2
		exit 1
	fi
	speed=$(printf "0x%02x" $(( $2 * 0xff / 100 )))
	echo "$sets {$set_boost, $1, $speed, 0x00}"  
}

get_fan_boost(){
	echo "$gets {$get_boost $1 0x00 0x00}"
}

get_fan_rpm(){
	echo "$gets {$fan_rpm $1 0x00 0x00}"
}
run_cmd(){
	if [[ -z "$1" || "$1" =~ [^0-9a-fA-Fx{},[:space:]] ]]; then
		echo "Invalid ACPI command: '$1'" 
		exit 1
	fi
	echo "\_SB.AMWW.WMAX 0 $1" > /proc/acpi/call
}
usage() {
    echo "Usage: fan [OPTIONS]"
    echo
    echo "Options:"
    echo "  -s, --set <1-100>           Set both fans to the specified speed"
    echo "  -s -cpu <1-100>             Set CPU fan only"
    echo "  -s -gpu <1-100>             Set GPU fan only"
    echo
    echo "  -g, --get                   Get speed info for both fans"
    echo "  -g -cpu                     Get CPU fan info"
    echo "  -g -gpu                     Get GPU fan info"
    echo
    echo "  -h, --help                  Show this help message"
}

display_reading(){
	run_cmd "$(get_fan_boost "$1")"
	echo "Fan Speed: $(( $(tr -d '\000' < /proc/acpi/call) * 100 / 255 ))%"
    	run_cmd "$(get_fan_rpm "$1")"
	echo "Fan RPM: $(( $(tr -d '\000' < /proc/acpi/call) )) rpm"
}

case "$1" in
	-s|--set)
		if [[ "$2" == "-cpu" && -n "$3" ]]; then
			fan1_speed="$3"
			run_cmd "$(set_fan_boost "$fan1" "$fan1_speed")"
			echo -e "\nSet CPU fan speed to $3%"
		elif [[ "$2" == "-gpu" && -n "$3" ]]; then
			fan2_speed="$3"
			run_cmd "$(set_fan_boost "$fan2" "$fan2_speed")"
			echo -e "\nSet GPU fan speed to $3%"
		elif [[ -n "$2" ]]; then
			fan1_speed="$2"
			fan2_speed="$2"
			run_cmd "$(set_fan_boost "$fan1" "$fan1_speed")"
			run_cmd "$(set_fan_boost "$fan2" "$fan2_speed")"
			echo -e "\nSet both fans speed to $2%"
		else
			usage
			exit 1
		fi
		;;
	-g|--get)
		if [[ "$2" == "-cpu" ]]; then
			echo "CPU:"
			display_reading "$fan1"
		elif [[ "$2" == "-gpu" ]]; then
			echo "GPU:"
			display_reading "$fan2"
		else
			echo "CPU:"
			display_reading "$fan1"
			echo -e "\n\n"
			echo "GPU:"
			display_reading "$fan2"
		fi
		;;
	-h|--help)
		usage
		exit 1
		;;
	*)
		usage
		exit 
		;;
esac

echo -e "\n\n"
