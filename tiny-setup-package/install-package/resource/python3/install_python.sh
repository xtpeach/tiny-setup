# 下载python源码包
wget https://www.python.org/ftp/python/3.11.1/Python-3.11.1.tar.xz

# 解压源码包
tar -xf Python-3.11.1.tar.xz

# 进入源码包文件夹
cd Python-3.11.1

# 配置编译
./configure --prefix=/usr/local

# 编译安装
make && make install

# 添加快捷调用
ln -s /usr/local/python3/bin/python3 /usr/bin/python3

# 打印python版本
python3 --version