#!/bin/bash

AMAX=/opt/amax
DATADIR=$AMAX/data
GENESIS=$AMAX/genesis.json

if [ -f $DATADIR"/node.pid" ]; then
    pid=$(cat $DATADIR"/node.pid")
    echo $pid
    kill $pid
    rm -r $DATADIR"/node.pid"

    echo -ne "Stopping node"

    while true; do
        [ ! -d "/proc/$pid/fd" ] && break
        echo -ne "."
        sleep 1
    done
    echo -ne "\rnode stopped. \n"

fi