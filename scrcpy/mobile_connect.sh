#!/bin/bash

# IP முகவரியை சேமிக்க ஒரு டெக்ஸ்ட் ஃபைல்
IP_FILE="$HOME/.saved_mobile_ip.txt"

# சேமிக்கப்பட்ட IP இருந்தால் அதை எடுத்துக்கொள்ளும்
if [ -f "$IP_FILE" ]; then
    SAVED_IP=$(cat "$IP_FILE")
else
    SAVED_IP="100.101.100.104:5555" # டிஃபால்ட் IP
fi

# Zenity மூலம் ஒரு சின்ன விண்டோவை ஓபன் செய்து IP-ஐ கேட்கும்
IP=$(zenity --entry \
--title="Scrcpy Mobile Connect" \
--text="Enter your Mobile IP and Port:" \
--entry-text="$SAVED_IP")

# பயனர் Cancel கொடுத்தால் ஸ்கிரிப்ட் வெளியேறும்
if [ -z "$IP" ]; then
    exit 0
fi

# புதிய IP-ஐ அடுத்த முறைக்காக சேமித்து வைக்கும்
echo "$IP" > "$IP_FILE"

# பழைய கனெக்ஷன்களை துண்டித்துவிட்டு, புதிய IP-ல் கனெக்ட் செய்யும்
adb disconnect
CONNECT_OUT=$(adb connect "$IP" 2>&1)

if [[ $CONNECT_OUT == *"connected to"* ]] || [[ $CONNECT_OUT == *"already connected"* ]]; then
    # Scrcpy-ஐ தொடங்கும், பிழை ஏற்பட்டால் அதை காட்ட
    SCRCPY_OUT=$(scrcpy 2>&1)
    if [ $? -ne 0 ]; then
        zenity --error --title="Scrcpy Error" --text="Scrcpy failed to start:\n\n$SCRCPY_OUT"
    fi
else
    zenity --error --title="Connection Failed" --text="Could not connect to $IP.\n\nDetails:\n$CONNECT_OUT"
fi
