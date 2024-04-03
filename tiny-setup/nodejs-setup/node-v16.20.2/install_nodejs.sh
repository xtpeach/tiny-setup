#!/bin/bash
# 下载地址：wget https://nodejs.org/dist/v16.20.2/node-v16.20.2-linux-x64.tar.xz

# 如果文件不存在，下载安装文件
if [[ ! -f node-v16.20.2-linux-x64.tar.xz ]]; then
  wget https://nodejs.org/dist/v16.20.2/node-v16.20.2-linux-x64.tar.xz
fi

# 文件在了就执行安装
if [[ -f node-v16.20.2-linux-x64.tar.xz ]]; then
  # 解压文件
  tar -xvf node-v16.20.2-linux-x64.tar.xz -C /usr/local/
  cd /usr/local/
  rm -rf /usr/local/node-v16.20.2
  mv node-v16.20.2-linux-x64 node-v16.20.2
  cd node-v16.20.2/bin/

  # 创建 /usr/bin 链接
  rm -rf /usr/bin/node
  rm -rf /usr/bin/npm
  ln -s /usr/local/node-v16.20.2/bin/node /usr/bin/node
  ln -s /usr/local/node-v16.20.2/bin/npm /usr/bin/npm

  echo "success node version:"
  node -v
  echo "success node version:"
  npm -v
else
  echo "node-v16.20.2-linux-x64.tar.xz 文件无法获取"
fi
