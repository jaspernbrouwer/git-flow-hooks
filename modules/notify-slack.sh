#!/usr/bin/env bash

if [ $# -gt 5 ]; then
    exit 1
fi

if [[ $(__notify_to_slack) == false ]]; then
    return 0
fi

COMMAND=$1
CURRENT_VERSION=$2
ACTION=$3
USER=$4
CHANGES=$5

CHANGES=`echo $CHANGES | sed "s/\"/'/g"`
SLACK_MESSAGE="\`$COMMAND/$CURRENT_VERSION\` $ACTION by $USER\n\nChanges:\n$CHANGES"

curl -X POST -s --data-urlencode "payload={\"text\":\"$SLACK_MESSAGE\"}" $SLACK_WEBHOOK_URL
