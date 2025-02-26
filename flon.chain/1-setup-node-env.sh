source ./conf.env
CONF_DIR=~/.flon_${NET}_${container_id}
mkdir -p $CONF_DIR
echo $CONF_DIR

[ ! -f "$CONF_DIR/node.env" ]                          && \
    cp      ./node/$NET/genesis.json   $CONF_DIR/      && \
    cp      ./node/docker-compose.yml  $CONF_DIR/      && \
    cp -r   ./node/conf                $CONF_DIR/      && \
    cp      ./node/$NET/node.ini       $CONF_DIR/conf/ && \
    cp -r   ./node/bin                 $CONF_DIR/

if [ "$NET" = "mainnet" ]; then
    P2P_PORT=${P2P_PORT}
    RPC_PORT=${RPC_PORT}
    HIST_WS_PORT=${HIST_WS_PORT}
elif [ "$NET" = "testnet" ]; then
    P2P_PORT=1${P2P_PORT}
    RPC_PORT=1${RPC_PORT}
    HIST_WS_PORT=1${HIST_WS_PORT}
elif [ "$NET" = "devnet" ]; then
    P2P_PORT=2${P2P_PORT}
    RPC_PORT=2${RPC_PORT}
    HIST_WS_PORT=2${HIST_WS_PORT}
fi

echo "NET=$NET" >> $CONF_DIR/node.env
echo "container_id=$container_id" >> $CONF_DIR/node.env
echo "agent_name=$agent_name" >> $CONF_DIR/node.env
echo "p2p_server_address=$p2p_server_address" >> $CONF_DIR/node.env
echo "p2p_peer_addresses=(${p2p_peer_addresses[*]})" >> $CONF_DIR/node.env
echo "P2P_PORT=$P2P_PORT" >> $CONF_DIR/node.env
echo "RPC_PORT=$RPC_PORT" >> $CONF_DIR/node.env
echo "HIST_WS_PORT=$HIST_WS_PORT" >> $CONF_DIR/node.env
echo "NODE_IMG_VER=$NODE_IMG_VER" >> $CONF_DIR/node.env
echo "NODE_HOME=$NODE_HOME" >> $CONF_DIR/node.env
echo "trace_plugin=$trace_plugin" >> $CONF_DIR/node.env
echo "state_plugin=$state_plugin" >> $CONF_DIR/node.env
echo "bp_plugin=$bp_plugin" >> $CONF_DIR/node.env

cp ./node/run-node-template.sh $CONF_DIR/run.sh
chmod +x $CONF_DIR/run.sh