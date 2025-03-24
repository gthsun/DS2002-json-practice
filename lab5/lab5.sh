#!/bin/bash

curl -s "https://aviationweather.gov/api/data/metar?ids=KMCI&format=json&taf=false&hours=12&bbox=40,-90,45,-85" > aviation.json

jq '.[] | .receiptTime' aviation.json | head -n 6

temperatures=$(jq '.[] | .temp' aviation.json)
average_temp=$(echo "$temperatures" | awk '{sum+=$1; num++} END {print sum/num}')
echo "Average Temperature: $average_temp"

clouds=$(jq -r '.[] | .clouds' aviation.json)
cloudy=$(echo "$clouds" | grep -vc "CLR")
total=$(echo "$clouds" | wc -l)
if (( cloudy > (total / 2) )); then
    echo "Mostly Cloudy: true"
else
    echo "Mostly Cloudy: false"
fi