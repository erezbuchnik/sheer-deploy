#!/bin/bash 
set +x

# Define IP, port
MACHINE=172.18.0.2
PORT=10000
PASSWORD='"xena"'  # Must be in double quotes
OWNER='"BASHTEST"' # Must be in double quotes


#while IFS='' read -r line || [[ -n "$line" ]]; do
#    echo "Text read from file: $line"
#done < "$1"


# Open file handle 3 as TCP connection to chassis:port
exec 3<> /dev/tcp/${MACHINE}/${PORT}
if [ $? -eq 0 ]
then
  echo "Openmul Telnet accepting connections"
else
  echo "Openmul Telnet connections not possible"
  exit 1
fi

while read -t 1 <&3 LINE; do echo "${LINE}"; done

while IFS='' read -r line || [[ -n "$line" ]]; do

	command="\n${line}\n"
	echo -e "${command}" >&3
	while read -t 1 <&3 LINE; do echo "${LINE}"; done

done < "$1"

command="exit\n"
echo -e ${command} >&3
while read -t 1 <&3 LINE; do echo "${LINE}"; done

command="exit\n"
echo -e ${command} >&3
while read -t 1 <&3 LINE; do echo "${LINE}"; done

command="exit\n"
echo -e ${command} >&3
while read -t 1 <&3 LINE; do echo "${LINE}"; done




command="\nenable\n"
echo -e ${command} >&3
while read -t 1 <&3 LINE; do echo ${LINE}; done

command="\nshow of-switch all\n"
echo -e ${command} >&3
while read -t 1 <&3 LINE; do echo ${LINE}; done

command="\nconfigure terminal\n"
echo -e ${command} >&3
while read -t 1 <&3 LINE; do echo ${LINE}; done

command="\nmul-conf\n"
echo -e ${command} >&3
while read -t 1 <&3 LINE; do echo ${LINE}; done

command="exit\n"
echo -e ${command} >&3
while read -t 1 <&3 LINE; do echo ${LINE}; done

command="exit\n"
echo -e ${command} >&3
while read -t 1 <&3 LINE; do echo ${LINE}; done

command="exit\n"
echo -e ${command} >&3
while read -t 1 <&3 LINE; do echo ${LINE}; done








# Send commands with echo command to file handle 3
command="\n\n\n\n\n"
echo -e ${command}
echo -e ${command} >&3
sleep 1
# Read answers from file handle 3, (one line a time)
read -d\  <&3 
# Answers are put in $REPLY variable 
echo "$REPLY"

command="enable\n\n"
echo -e ${command}
echo -e ${command} >&3
sleep 1
read -d\  <&3 
echo "$REPLY"

echo -e "show of-switch all\n\n"  >&3
sleep 1
read  <&3 
echo ["$REPLY"]

echo -e "configure terminal\n\n"  >&3
sleep 1
read  <&3 
echo ["$REPLY"]

echo -e "mul-conf\n\n"  >&3
sleep 1
read  <&3 
echo "$REPLY"

echo -e "exit\n\n"  >&3
sleep 1
read  <&3 
echo "$REPLY"

# Close file handle 3
exec 3>&-
if [ $? -eq 0 ]
then
    echo "Openmul Telnet accepting close"
else
    echo "Openmul Telnet close not possible"
fi

exit


# Here are some examples
echo -en "C_OWNER ${OWNER}\r\n"  >&3
read  <&3 
echo $REPLY
echo -en "C_TIMEOUT 20\r\n" >&3
read  <&3 
echo $REPLY
echo -en "C_CONFIG ?\r\n" >&3  # Will create 5 lines of answer
read  <&3 # will only read one line of answer
echo $REPLY 
read  <&3 # will only read one line of answer
echo $REPLY
read  <&3 # will only read one line of answer
echo $REPLY
read  <&3 # will only read one line of answer
echo $REPLY
read  <&3 # will only read one line of answer
echo $REPLY

#
#
# Now echo your CLI commands to ">&3" and read the answers from "<&3"
#
#



# Close file handle 3
exec 3>&-
if [ $? -eq 0 ]
then
    echo "Telnet accepting close"
else
    echo "Telnet close not possible"
fi


set +x


