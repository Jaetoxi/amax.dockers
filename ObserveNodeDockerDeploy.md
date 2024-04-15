## 观察者节点容器化部署
### 服务器硬件要求
```
推荐使用 Ubuntu 18.04 LTS 或更高 Ubuntu 20.04 LTS、Ubuntu 22.04 LTS 版本

最低配置

CPU: 8 cores 8核或更高
RAM: 64GB 内存
NET: 10Mbps 10M带宽或更高
Storage Disk Space: SSD 500G 硬盘或更大
```

### 一、准备启动脚本 
```
git clone https://github.com/armoniax/amax.dockers.git
cd amax.dockers/amax.meta.chain
sh setup-amnod.sh mainnet 001
```

打印出一个目录/xxx/.amax_mainnet_001 (先记住这个路径，后面用到)


### 二、准备区块数据快照

```
cd /opt/data
mkdir -p amax_mainnet_001/data/snapshots/
cd amax_mainnet_001/data/snapshots/
```


打开 https://snapshot.amaxscan.io/ , 复制文件链接.


下载、解压文件(安装解压工具：```yum install zstd```)

```
wget https://snapshot.amaxscan.io/snapshot-03c7xx.bin.zst
unzstd snapshot.amaxscan.io/snapshot-03c7xx.bin.zst
```

### 三、启动docker 容器

进入第一步生成的文件夹

```
cd /xxx/.amax_mainnet_001
vim bin/start.sh
```

找到./data/snapshots/snapshot-03c75e09723daf6e18a716a37934059c68aa5f00de0b89a1a277f6ab36b08294.bin,更新snapshot文件名

根据需要打开插件（查询历史交易：history_plugin，扫链：state_plugin）

```
vim amnod.env
history_plugin=false
state_plugin=false
```


运行启动命令

```sh run.sh```

即可启动容器amnod-mainnet-001

### 四、检查容器状态

进入容器

```docker exec -it amnod-mainnet-001 bash```

检查节点状态

```amcli get info```

（需要5-10分钟时间同步快照数据）


