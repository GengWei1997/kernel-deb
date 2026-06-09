#!/bin/bash
set -e  # 遇到错误立即退出

# 克隆指定版本的内核源码
git clone https://github.com/GengWei1997/linux.git --branch raphael-$1 --depth 1 linux
#git clone https://github.com/Aospa-raphael-unofficial/linux.git --branch sm8150/$1 --depth 1 linux

# 内核配置文件
mv uboot-raphael.config linux/arch/arm64/configs/raphael.config
#mv uefi-raphael.config linux/arch/arm64/configs/raphael.config

cd linux

# 生成内核配置
make -j$(nproc) ARCH=arm64 LLVM=-22 defconfig raphael.config
cp .config ../raphael.config

# 清理源码目录
rm -rf linux
