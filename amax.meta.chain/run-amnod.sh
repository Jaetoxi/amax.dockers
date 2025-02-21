
[ ! -f ./amnod.env ] && echo "not in amnod env, hence existing ..." && exit 1

set -a && source ./amnod.env

DEST_HOME="${NODE_HOME}/amax_${NET}_${container_id}"
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
    for peer in ${p2p_peer_addresses[@] }; do
        echo "p2p-peer-address = $peer" >> $DEST_CONF
    done
fi


if  [ "${history_plugin}" == "true" ]; then
    echo " " >> $DEST_CONF
    echo "#### History plugin conf: " >> $DEST_CONF
    cat ./conf/plugin_history.ini >> $DEST_CONF
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
fi

docker network create amax
docker-compose --env-file ./amnod.env up -d
#podman-compose --env-file ./amnod.env up -d

if   [ "$NET" = "mainnet" ]; then
    sudo iptables -I INPUT -p tcp -m tcp --dport 9806 -j ACCEPT
    sudo iptables -I INPUT -p tcp -m tcp --dport 8888 -j ACCEPT

elif [ "$NET" = "testnet" ]; then
    sudo iptables -I INPUT -p tcp -m tcp --dport 19806 -j ACCEPT
    sudo iptables -I INPUT -p tcp -m tcp --dport 18888 -j ACCEPT

elif [ "$NET" = "devnet" ]; then
    sudo iptables -I INPUT -p tcp -m tcp --dport 29806 -j ACCEPT
    sudo iptables -I INPUT -p tcp -m tcp --dport 28888 -j ACCEPT
fi
