source ./conf.env
CONF_DIR=~/.amax_${NET}_${tag}_${id}
mkdir -p $CONF_DIR
echo $CONF_DIR

[ ! -f "$CONF_DIR/amnod.env" ]                          && \
    cp      ./amnod/$NET/amnod.env      $CONF_DIR/      && \
    cp      ./amnod/$NET/genesis.json   $CONF_DIR/      && \
    cp      ./amnod/docker-compose.yml  $CONF_DIR/      && \
    cp -r   ./amnod/conf                $CONF_DIR/      && \
    cp -r   ./amnod/bin                 $CONF_DIR/
    
echo "NET=$NET" >> $CONF_DIR/amnod.env
echo "tag=$tag" >> $CONF_DIR/amnod.env
echo "id=$id" >> $CONF_DIR/amnod.env
echo "agentname=$agentname" >> $CONF_DIR/amnod.env
echo "localp2p=$localp2p" >> $CONF_DIR/amnod.env

cp ./run-amnod.sh $CONF_DIR/run.sh
chmod +x $CONF_DIR/run.sh