#!/bin/sh
set -e

if [[ $ROSBOT_ADDR =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  ROSBOT_IP=$ROSBOT_ADDR
elif [[ $ROSBOT_ADDR =~ ^[0-9a-fA-F:]+$ ]]; then
  ROSBOT_IP="[$ROSBOT_ADDR]"
else
  ROSBOT_IP=$(grep $ROSBOT_ADDR /etc/hosts | awk '{ print $1 }')
fi

if [ -z "$ROSBOT_IP" ]; then
  echo "ERROR: ROSBOT_ADDR not found in /etc/hosts"
  exit 1
fi

echo "rosbot IP is: ${ROSBOT_IP}"
sed -i "s|file:///ros2_ws|http://$ROSBOT_IP:$PORT/ros2_ws|g" /src/rosbot_xl.urdf /src/rosbot.urdf

exec "$@"
