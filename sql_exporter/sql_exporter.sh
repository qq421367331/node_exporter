#/bin/bash

cd /opt/software
wget https://github.com/free/sql_exporter/releases/download/0.5/sql_exporter-0.5.linux-amd64.tar.gz
tar -zxf sql_exporter-0.5.linux-amd64.tar.gz 
mv sql_exporter-0.5.linux-amd64 /usr/local/sql_exporter

#启动程序
vi /usr/lib/systemd/system/sql_exporter.service
[Unit]
Description=sql_exporter

[Service]
Type=simple
ExecStart=/usr/local/sql_exporter/sql_exporter -config.file=/usr/local/sql_exporter/sql_exporter.yml
Restart=on-failure

[Install]
WantedBy=multi-user.target

#
systemctl daemon-reload
systemctl start sql_exporter.service
systemctl enable sql_exporter.service

#访问地址
http://ip:9399/metrics

#添加到prometheus
  - job_name: 'sql_exporter'
    static_configs:
    - targets: ['121.40.215.2:9399']
