#!/bin/bash

BASEDIR=`dirname "$0"`
DIFF=`which diff`
FIND=`which find`
PRINTF=`which printf`

FLAGS=""

VALDIFF=$(which colordiff || which diff)

cd "$BASEDIR"

if [ ! -x "$DIFF" ]
then
    echo "Cannot find the diff command. Exiting."
    exit 1
fi

if [ ! -x "$FIND" ]
then
    echo "Cannot find the find command. Exiting."
    exit 1
fi

if [ ! -x "$PRINTF" ]
then
    echo "Could not find the printf command. Falling back on echo -- expect ugly output."
    PRINTF="echo"
fi

if [ -x "$BASEDIR/../coop" ]
then
    COOP="$BASEDIR/../coop"
elif [ -x "$BASEDIR/../coop.native" ]
then
    COOP="$BASEDIR/../coop.native"
elif [ -x "$BASEDIR/../coop.byte" ]
then
    COOP="$BASEDIR/../coop.byte"
else
    echo "Cannot find the Coop executable. Compile Coop first."
    exit 1
fi

VALIDATE=0
if [ "$1" = "-v" ]
then
    VALIDATE=1
    shift
fi

FILES="$@"
if [ "$FILES" = "" ]
then
    FILES=$($FIND "$BASEDIR" -name "*.coop")
fi

_EXIT=0

for FILE in $FILES
do
    while :
    do
        "$COOP" $FLAGS "$FILE" >"$FILE.out" 2>&1
        if [ -f $FILE.ref ]
        then
            RESULT=`"$DIFF" "$FILE.ref" "$FILE.out"`
            if [ "$?" = "0" ]
            then
                $PRINTF "Test: $FILE                        \r"
                $PRINTF "SUCCESS: $FILE\n"
                rm "$FILE.out"
            else
                _EXIT=1
                echo "FAILED:  $FILE                          "
                if [ "$VALIDATE" = "1" ]
                then
                    # Is it about whitespace?
                    "$DIFF" --ignore-blank-lines --ignore-all-space "$FILE.ref" "$FILE.out" 2>/dev/null 1>/dev/null
                    if [ "$?" = "0" ]
                    then
                        ONLYWHITE="\n[Note: only white space changed]"
                    else
                        ONLYWHITE=""
                    fi
                    "$VALDIFF" --unified "$FILE.ref" "$FILE.out"
                    echo "$ONLYWHITE"
                    echo "Validate $FILE.out as new .ref?"
                    read -p "[y:yes, n:no, q:quit, r:rerun) [n] " ans
                    if [ "$ans" = "y" -o "$ans" = "Y" ]
                    then
                        mv "$FILE.out" "$FILE.ref"
                        echo "Validated: $FILE"
                    elif [ "$ans" = "q" -o "$ans" = "Q" ]
                    then
                        exit 0
                    elif [ "$ans" = "r" -o "$and" = "R" ]
                    then
                        continue
                    fi
                fi
            fi

        else
            mv "$FILE.out" "$FILE.ref"
            echo "Created: $FILE.ref                        "
        fi
        break
    done
done
echo "Done.                                       "
exit $_EXIT
