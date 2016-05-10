#!/usr/bin/env bash

MERGE_FILES=""

for FILE in $(__get_commit_files); do
    if egrep -rls "^<<<<<<< |^>>>>>>> $" "$FILE" > /dev/null; then
        if ! __is_binary "$FILE"; then
            MERGE_FILES="$MERGE_FILES\n      $FILE"
        fi
    fi
done

if [ -z "$MERGE_FILES" ]; then
    return 0
else
    __print_fail "Merge markers found in:$MERGE_FILES"
    return 1
fi
