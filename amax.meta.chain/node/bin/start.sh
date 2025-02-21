#!/bin/bash

AMAX=$1
LOGFILE=$AMAX/logs/node.log
source $AMAX/bin/start.env
ulimit -c unlimited
ulimit -n 65535
ulimit -s 64000

TIMESTAMP=$(/bin/date +%s)
NEW_LOGFILE="${AMAX}/logs/${TIMESTAMP}.log" && touch $NEW_LOGFILE

OPTIONS="--data-dir $AMAX/data --config-dir $AMAX/conf"
if [[ ! -f $AMAX/data/state/shared_memory.bin ]] && [[ -f "$SNAPSHOT" ]]; then
  OPTIONS="$OPTIONS --snapshot ${SNAPSHOT} "
elif [[ ! -f $AMAX/data/blocks/blocks.index ]]; then
  OPTIONS="$OPTIONS --genesis-json $AMAX/conf/genesis.json"
fi

trap 'echo "[$(date)]Start Shutdown"; kill $(jobs -p); wait; echo "[$(date)]Shutdown ok"' SIGINT SIGTERM

## launch node program...
node $params $OPTIONS >> $NEW_LOGFILE 2>&1 &
#node  $params $OPTIONS --delete-all-blocks >> $NEW_LOGFILE 2>&1 &
#node  $params $OPTIONS --hard-replay-blockchain --truncate-at-block 87380000 >> $NEW_LOGFILE 2>&1 &
echo $! > $AMAX/node.pid


[[ -f "$LOGFILE" ]] && unlink $LOGFILE
ln -s $NEW_LOGFILE $LOGFILE

# tail -f /dev/null
wait
