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
    
echo "NET=$NET" >> $CONF_DIR/amnod.env
echo "container_id=$container_id" >> $CONF_DIR/amnod.env
echo "agent_name=$agent_name" >> $CONF_DIR/amnod.env
echo "p2p_server_address=$p2p_server_address" >> $CONF_DIR/amnod.env
echo "p2p_peer_addresses=$p2p_peer_addresses" >> $CONF_DIR/amnod.env

cp ./run-amnod.sh $CONF_DIR/run.sh
chmod +x $CONF_DIR/run.sh