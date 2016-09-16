#!/usr/bin/env bash

if [ $# -gt 5 ]; then
    exit 1
fi

if [[ $(__notify_to_hipchat) == false ]]; then
    return 0
fi

COMMAND=$1
CURRENT_VERSION=$2
ACTION=$3
USER=$4
CHANGES=$5

CHANGES=`echo $CHANGES | sed -e 's/^/<li>/' -e 's/\\\\n[ ]*/<li>/g' -e 's/<li>$//'`
HIPCHAT_MESSAGE="<strong>$COMMAND/$CURRENT_VERSION</strong> $ACTION by $USER<br /><br />Changes:<br /><ul>$CHANGES</ul>"

curl -H "Content-Type: application/json" \
     -X POST \
     -d "{\"color\": \"yellow\", \"message_format\": \"html\", \"message\": \"$HIPCHAT_MESSAGE\"}" \
     $HIPCHAT_URL/v2/room/$HIPCHAT_ROOM_ID/notification?auth_token=$HIPCHAT_AUTH_TOKEN
