#!/bin/bash

PREV_TOTAL=0
PREV_IDLE=0

while true; do

 CPU=($(sed -n 's/^cpu\s//p' /proc/stat))
 IDLE=${CPU[3]}
 TOTAL=0

 for VALUE in "${CPU[@]:0:8}"; do
  TOTAL=$((TOTAL+VALUE))
 done

 DIFF_IDLE=$((IDLE-PREV_IDLE))
 DIFF_TOTAL=$((TOTAL-PREV_TOTAL))
 DIFF_USAGE=$(((1000*(DIFF_TOTAL-DIFF_IDLE)/DIFF_TOTAL+5)/10))

 echo -en "\rCPU: $DIFF_USAGE%  \b\b"
 PREV_TOTAL="$TOTAL"
 PREV_IDLE="$IDLE"

 sleep 1

done
