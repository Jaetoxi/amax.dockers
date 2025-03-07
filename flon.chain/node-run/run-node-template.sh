
[ ! -f ./node.env ] && echo "not in node env, hence existing ..." && exit 1

set -a && source ./node.env

DEST_HOME="${NODE_HOME}/flon_${NET}_${container_id}"
DEST_CONF="${DEST_HOME}/conf/config.ini"
mkdir -p $DEST_HOME/conf $DEST_HOME/data $DEST_HOME/logs

cp -r   ./bin                   $DEST_HOME/         && \
cp      ./genesis.json          $DEST_HOME/conf/    && \
cp      ./conf/base.ini         $DEST_CONF

# copy conf node info into config
echo " " >> $DEST_CONF
echo "#### Node base conf: " >> $DEST_CONF
cat ./conf/node.ini >> $DEST_CONF

sed -i "s/agent_name/${agent_name}/g" $DEST_CONF
sed -i "s/p2p_server_address/${p2p_server_address}/g" $DEST_CONF
sed -i "s/P2P_PORT/${P2P_PORT}/g" $DEST_CONF
if [ "${p2p_peer_addresses}" != "" ]; then
    for peer in "${p2p_peer_addresses[@]}"; do
        echo "p2p-peer-address = $peer" >> $DEST_CONF
    done
fi


if  [ "${trace_plugin}" == "true" ]; then
    echo " " >> $DEST_CONF
    echo "#### Trace plugin conf: " >> $DEST_CONF
    cat ./conf/plugin_trace.ini >> $DEST_CONF
fi

if  [ "${state_plugin}" == "true" ]; then
    echo " " >> $DEST_CONF
    echo "#### State plugin conf: " >> $DEST_CONF
    cat ./conf/plugin_state.ini >> $DEST_CONF
fi

if  [ "${bp_plugin}" == "true" ]; then
    echo " " >> $DEST_CONF
    echo "#### Block producer plugin conf: " >> $DEST_CONF
    cat ./conf/plugin_bp.ini >> $DEST_CONF
    for producer_name in "${producer_names[@]}"; do
        echo "producer-name = $producer_name" >> $DEST_CONF
    done
    for signature_provider in "${signature_providers[@]}"; do
        echo "signature-provider = $signature_provider " >> $DEST_CONF
    done
fi

docker network create flon
docker-compose --env-file ./node.env up -d
#podman-compose --env-file ./node.env up -d

sudo iptables -I INPUT -p tcp -m tcp --dport ${RPC_PORT} -j ACCEPT
sudo iptables -I INPUT -p tcp -m tcp --dport ${P2P_PORT} -j ACCEPT
sudo iptables -I INPUT -p tcp -m tcp --dport ${HIST_WS_PORT} -j ACCEPT