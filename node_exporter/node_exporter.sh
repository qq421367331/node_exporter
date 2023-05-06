#!/bin/bash
#下载node_exporter包
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
#解压移动
tar -xvf node_exporter-1.5.0.linux-amd64.tar.gz
mv node_exporter-1.5.0.linux-amd64 /usr/local/node_exporter
#设置启动文件
cat > /usr/lib/systemd/system/node_exporter.service <<EOF
[Unit] 
Description=node_exporter 
Documentation=https://prometheus.io/ 
After=network.target 
[Service] 
ExecStart=/usr/local/node_exporter/node_exporter
Execreload=/bin/kill -s HUP$MAINPID
Restart=on-failure 
[Install] 
WantedBy=multi-user.target
EOF
# 写入系统服务文件
systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter
# 系统服务重载并启动

if  [ -n "$1" ]
then 
    hostname=$1
else
    hostname="default"
fi
#带一个参数指定备注
ip=`ip address show eth0 | head -n4 |grep inet | awk '{print$2}'`
curl "http://*****/node?ip=${ip}&des=${hostname}"
#向api发送信息报告
echo "node_exporter部署完成"
