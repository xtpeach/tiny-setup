#!/bin/bash
# 下载地址：wget https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tgz

# 需要修改如下两个文件以修改 yum
# python -> python2
# /usr/libexec/urlgrabber-ext-down
# /usr/bin/yum

# 环境准备
yum install -y wget zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make zlib zlib-devel libffi-devel

# 安装python
tar -zxvf Python-2.7.9.tgz
cd ./Python-2.7.9
./configure --prefix=/usr/local/python2

# 执行编译
make && make install

# 修改原来的python连接
rm -f /usr/bin/python2
ln -s /usr/local/python2/bin/python2 /usr/bin/python2

python2 -V