#!/bin/bash

ip=$2

filepath=$PWD/backup

useage()
{

    base=$(basename $0)
    cat <<EOUSAGE
    Available Commands:

    $base backup   [ip]

    $base restore  [ip]
EOUSAGE
    exit 1
}

if [ $# -ne 2 ]; then
    useage
    exit 1
fi




backup()
{
    echo "Target IP: $ip  backup consul to $filepath"
    docker run -it --rm consul:1.6 kv export -http-addr="http://$ip"  > "$filepath"
}

restore()
{
    echo "Target IP: $ip  restore consul from $filepath"
    docker run -it --rm -v $filepath:/backup consul:1.6 kv import -http-addr="http://$ip" @backup
}

############################


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

