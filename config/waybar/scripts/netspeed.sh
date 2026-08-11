#!/bin/env bash

# ┌────────────────────────────────────────────┐
# │ AuthorModify : KyawNyeinThant              │
# │ Github       : kntlifelovelive             │
# │ Date         : 2026 , March, 13            │
# │ Internet Network Speed Show Script         │
# └────────────────────────────────────────────┘

# Detect default network interface (ethernet, wifi, vpn)
INTERFACE=$(ip route | awk '/default/ {print $5; exit}')

if [ -z "$INTERFACE" ]; then
  echo "<b><span color='Red'>Net</span></b>"
  exit 0
fi

RX1=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
sleep 1
RX2=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)

RX_RATE=$(((RX2 - RX1) / 1024)) # KB/s

# Convert & pick unit
if [ $RX_RATE -ge 1024 ]; then
  SPEED="$(echo "scale=1; $RX_RATE/1024" | bc)"
  UNIT="MB"
else
  SPEED="$RX_RATE"
  UNIT="KB"
fi

# Color thresholds
if [ $RX_RATE -ge 1024 ]; then
  COLOR="blue" # >= 1 MB/s
elif [ $RX_RATE -ge 700 ]; then
  COLOR="yellow" # 700 KB/s ~ 1 MB/s
else
  COLOR="white" # < 700 KB/s
fi

echo "<b><span color='$COLOR'>$SPEED $UNIT</span></b>"
