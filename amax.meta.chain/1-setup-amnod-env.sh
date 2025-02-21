source ./conf.env
CONF_DIR=~/.amax_${NET}_${container_id}
mkdir -p $CONF_DIR
echo $CONF_DIR

[ ! -f "$CONF_DIR/amnod.env" ]                          && \
    cp      ./amnod/$NET/amnod.env      $CONF_DIR/      && \
    cp      ./amnod/$NET/genesis.json   $CONF_DIR/      && \
    cp      ./amnod/docker-compose.yml  $CONF_DIR/      && \
    cp -r   ./amnod/conf                $CONF_DIR/      && \
    cp      ./amnod/$NET/node.ini       $CONF_DIR/conf/ && \
    cp -r   ./amnod/bin                 $CONF_DIR/

if [ "$NET" = "mainnet" ]; then
    P2P_PORT=9806
    RPC_PORT=8888
    HIST_WS_PORT=8889
elif [ "$NET" = "testnet" ]; then
    P2P_PORT=19806
    RPC_PORT=18888
    HIST_WS_PORT=18889
elif [ "$NET" = "devnet" ]; then
    P2P_PORT=29806
    RPC_PORT=28888
    HIST_WS_PORT=28889
fi

echo "NET=$NET" >> $CONF_DIR/amnod.env
echo "container_id=$container_id" >> $CONF_DIR/amnod.env
echo "agent_name=$agent_name" >> $CONF_DIR/amnod.env
echo "p2p_server_address=$p2p_server_address" >> $CONF_DIR/amnod.env
echo "p2p_peer_addresses=(${p2p_peer_addresses[*]})" >> $CONF_DIR/amnod.env
echo "P2P_PORT=$P2P_PORT" >> $CONF_DIR/amnod.env
echo "RPC_PORT=$RPC_PORT" >> $CONF_DIR/amnod.env
echo "HIST_WS_PORT=$HIST_WS_PORT" >> $CONF_DIR/amnod.env
echo "AMNOD_IMG_VER=$AMNOD_IMG_VER" >> $CONF_DIR/amnod.env
echo "NODE_HOME=$NODE_HOME" >> $CONF_DIR/amnod.env
echo "history_plugin=$history_plugin" >> $CONF_DIR/amnod.env
echo "state_plugin=$state_plugin" >> $CONF_DIR/amnod.env
echo "bp_plugin=$bp_plugin" >> $CONF_DIR/amnod.env

cp ./run-amnod.sh $CONF_DIR/run.sh
chmod +x $CONF_DIR/run.sh