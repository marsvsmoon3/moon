#!/bin/bash

command="$1"


echo "Reading primary info"
#gatttool -b E7:5A:53:79:82:A4 -t random --primary

echo "Reading characteristics info"
#gatttool -b E7:5A:53:79:82:A4 -t random --characteristics

echo "Reading characteristics desc"
#gatttool -b E7:5A:53:79:82:A4 -t random --char-desc


#echo "Attempt to write something -> 0x000c"
#gatttool -b E7:5A:53:79:82:A4 -t random --char-write-req --handle=0x000c --value=0100


# 55:00:ff:b5:4c:75:b1:b4:0c:88:ef:aa
# 55:01:ff:b5:4c:75:b1:b4:0c:88:ef:aa
# 55:02:ff:b5:4c:75:b1:b4:0c:88:ef:aa
# 55:03:ff:b5:4c:75:b1:b4:0c:88:ef:aa
#sdf

(( i=0 ))
while true; do
  echo "Attempt to write something -> 0x000c"
  gatttool -b E7:5A:53:79:82:A4 -t random --char-write-req --handle=0x000c --value=0100
  sleep 0.5;
  
  #gatttool -b E7:5A:53:79:82:A4 -t random --listen &
  magic=`printf "55%02xffb54c75b1b40c88efaa" $i`
 
  
  echo "Attempt to write something -> 0x000e ($magic)"
  sleep 0.5;
  gatttool -b E7:5A:53:79:82:A4 -t random --char-write-req --handle=0x000e --value=$magic --listen >response  &
  gettpid=$!
  #echo "Forked to pid $gettpid"
  sleep 0.5;
  #echo "Killing to pid $gettpid"
  kill $gettpid  >/dev/null 2>/dev/null
  wait $gettpid 2>/dev/null
  response=`cat response`;
  reply=`echo $response | grep "value:" | sed "s/.*value: \(.*\)/\\1/g"`
  echo -n "REPLY:$reply"
  
  is_authorized=`echo $reply | awk '{print $4}'`
  echo " <$is_authorized> "
  if [[ $is_authorized == "01" ]]; then 
    echo  "Authorized"
    break;
  else
    echo  "HOLD + button"
  fi;
  
  if [[ $reply == "" ]]; then
     echo "No reply"
     (( i = (i + 1) % 256 ));
  else    
     (( i = (i + 1) % 256 ));
  fi
  
done;

echo "Ok";

# Requesting status

if [[ $command == "query" ]]; then
  while true; do
    #echo "Attempt to write something -> 0x000c"
    gatttool -b E7:5A:53:79:82:A4 -t random --char-write-req --handle=0x000c --value=0100
    sleep 0.5;
    
    #gatttool -b E7:5A:53:79:82:A4 -t random --listen &
    magic=`printf "55%02x06aa" $i`
  
    
    #echo "Attempt to write something -> 0x000e ($magic)"
    sleep 0.5;
    gatttool -b E7:5A:53:79:82:A4 -t random --char-write-req --handle=0x000e --value=$magic --listen >response  &
    gettpid=$!
    #echo "Forked to pid $gettpid"
    sleep 0.5;
    #echo "Killing to pid $gettpid"
    kill $gettpid  >/dev/null 2>/dev/null
    wait $gettpid 2>/dev/null
    response=`cat response`;
    reply=`echo $response | grep "value:" | sed "s/.*value: \(.*\)/\\1/g"`
    
    kettle_on=`echo $reply | awk '{print $12}'`
    kettle_temp=`echo $reply | awk '{print $14}'`
    
    if [[ $kettle_on == "00" ]]; then
      echo -n "OFF"
    else
      echo -n "ON"
    fi
    
    echo -n " "  
    echo -n "$((16#$kettle_temp))C"
    echo -n " "  
    echo "REPLY:$reply"
    
    
    if [[ $reply == "" ]]; then
      echo "No reply"
      (( i = (i + 1) % 256 ));
    else    
      (( i = (i + 1) % 256 ));
    fi
    
  done;
fi;

if [[ $command == "on" ]]; then
    while true; do
      #echo "Attempt to write something -> 0x000c"
      gatttool -b E7:5A:53:79:82:A4 -t random --char-write-req --handle=0x000c --value=0100
      sleep 0.5;
      magic=`printf "55%02x0500002800aa" $i`
      
      #echo "Attempt to write something -> 0x000e ($magic)"
      sleep 0.5;
      gatttool -b E7:5A:53:79:82:A4 -t random --char-write-req --handle=0x000e --value=$magic --listen >response  &
      gettpid=$!
      #echo "Forked to pid $gettpid"
      sleep 0.5;
      #echo "Killing to pid $gettpid"
      kill $gettpid  >/dev/null 2>/dev/null
      wait $gettpid 2>/dev/null
      response=`cat response`;
      reply=`echo $response | grep "value:" | sed "s/.*value: \(.*\)/\\1/g"`
      
      is_on=`echo $reply | awk '{print $4}'`
      echo " <$is_on> "
      if [[ $is_on == "01" ]]; then 
	echo  "Success"
	break;
      else
	echo  "Trying again..."
      fi;
      
      if [[ $reply == "" ]]; then
	echo "No reply"
	(( i = (i + 1) % 256 ));
      else    
	(( i = (i + 1) % 256 ));
      fi        
   done;
    
fi;

if [[ $command == "off" ]]; then
   while true; do
      #echo "Attempt to write something -> 0x000c"
      gatttool -b E7:5A:53:79:82:A4 -t random --char-write-req --handle=0x000c --value=0100
      sleep 0.5;
      magic=`printf "55%02x04aa" $i`
      
      #echo "Attempt to write something -> 0x000e ($magic)"
      sleep 0.5;
      gatttool -b E7:5A:53:79:82:A4 -t random --char-write-req --handle=0x000e --value=$magic --listen >response  &
      gettpid=$!
      #echo "Forked to pid $gettpid"
      sleep 0.5;
      #echo "Killing to pid $gettpid"
      kill $gettpid  >/dev/null 2>/dev/null
      wait $gettpid 2>/dev/null
      response=`cat response`;
      reply=`echo $response | grep "value:" | sed "s/.*value: \(.*\)/\\1/g"`
      
      is_on=`echo $reply | awk '{print $4}'`
      echo " <$is_on> "
      if [[ $is_on == "01" ]]; then 
	echo  "Success"
	break;
      else
	echo  "Trying again..."
      fi;
      
      if [[ $reply == "" ]]; then
	echo "No reply"
	(( i = (i + 1) % 256 ));
      else    
	(( i = (i + 1) % 256 ));
      fi        
   done;
fi;