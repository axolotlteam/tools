#!/bin/bash

IP=$2
FILE=$3
FILEPATH=${FILE:= $PWD/backup}
FILENAME=$(basename $FILEPATH)


useage()
{
    base=$(basename $0)
    cat <<EOUSAGE
    Available Commands:

    $base backup   [IP]

    $base restore  [IP]
EOUSAGE
    exit 1
}

backup()
{
    echo "Target IP: $IP  backup consul to $FILEPATH"
    docker run -it --rm consul:1.6 kv export -http-addr="http://$IP"  >> "$FILEPATH"
}

restore()
{
    echo "Target IP: $IP  restore consul from $FILEPATH"
    docker run -it --rm -v $FILEPATH:/backup consul:1.6 kv import -http-addr="http://$IP" @$FILENAME
}

############################
if [ $# -lt 2 ]; then
    useage
    exit 1
fi

[ ! -f $FILEPATH ] && touch $FILEPATH


case $1 in
    "-b"|"backup")
        backup
    ;;
    "-r"|"restore")
        restore
    ;;
    *)
    useage
    exit 1
    ;;
esac

