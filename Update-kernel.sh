#!/bin/bash

echo "=== 开始更新内核 ==="

echo "1. 切换到/tmp工作目录"
cd /tmp
if [ $? -ne 0 ]; then
    echo "错误：无法进入/tmp目录"
    exit 1
fi

echo "2. 下载内核：image/headers"
wget https://github.com/GengWei1997/kernel-deb/releases/download/v6.18/linux-image-xiaomi-raphael.deb
if [ $? -ne 0 ]; then
    echo "错误：linux-image 下载失败"
    exit 1
fi
wget https://github.com/GengWei1997/kernel-deb/releases/download/v6.18/linux-headers-xiaomi-raphael.deb
if [ $? -ne 0 ]; then
    echo "错误：linux-headers 下载失败"
    exit 1
fi

echo "3. 显示当前已安装的Linux相关软件包"
dpkg --get-selections | grep linux

echo "4. 查找并卸载所有linux-xiaomi内核包"
echo "   正在查找linux-xiaomi相关包..."
dpkg -l | grep -E "linux-headers|linux-image|linux-xiaomi-raphael" | awk '{print $2}' | xargs -r dpkg -P

echo "5. 清理/lib/modules目录（删除所有内核模块）"
rm -rf /lib/modules/*

echo "6. 安装新的 linux-image 与 linux-headers"
if [ -f "linux-image-xiaomi-raphael.deb" ] && [ -f "linux-headers-xiaomi-raphael.deb" ]; then
    dpkg -i linux-image-xiaomi-raphael.deb linux-headers-xiaomi-raphael.deb
    if [ $? -ne 0 ]; then
        echo "错误：安装 image/headers 失败"
        exit 1
    fi
else
    echo "错误：缺少 image/headers 安装文件"
    exit 1
fi

echo "7. 显示安装后的Linux相关软件包"
dpkg --get-selections | grep linux

echo "8. 为所有内核生成initramfs镜像"
update-initramfs -c -k all
if [ $? -ne 0 ]; then
    echo "警告：initramfs更新可能存在问题"
fi

echo "9. 清理旧的启动文件"
rm -f /boot/initramfs
rm -f /boot/linux.efi

echo "10. 重命名启动文件"
echo "   将最新的initrd.img移动到/boot/initramfs"
latest_initrd=$(ls -t /boot/initrd.img-* 2>/dev/null | head -1)
if [ -n "$latest_initrd" ]; then
    mv "$latest_initrd" /boot/initramfs
    echo "   已移动: $latest_initrd -> /boot/initramfs"
else
    echo "   警告：未找到initrd.img-*文件"
fi

echo "   将最新的vmlinuz移动到/boot/linux.efi"
latest_vmlinuz=$(ls -t /boot/vmlinuz-* 2>/dev/null | head -1)
if [ -n "$latest_vmlinuz" ]; then
    mv "$latest_vmlinuz" /boot/linux.efi
    echo "   已移动: $latest_vmlinuz -> /boot/linux.efi"
else
    echo "   警告：未找到vmlinuz-*文件"
fi

echo "11. 显示/boot目录内容"
ls -la /boot

echo "=== 验证启动文件 ==="
if [ -f "/boot/initramfs" ] && [ -f "/boot/linux.efi" ]; then
    echo "✓ 验证成功："
    echo "  - /boot/initramfs 文件存在"
    echo "  - /boot/linux.efi 文件存在"
    echo ""
    echo "文件详细信息："
    ls -lh /boot/initramfs /boot/linux.efi
else
    echo "✗ 验证失败："
    [ -f "/boot/initramfs" ] || echo "  - /boot/initramfs 文件缺失"
    [ -f "/boot/linux.efi" ] || echo "  - /boot/linux.efi 文件缺失"
    echo ""
    echo "请检查上述步骤是否有错误"
fi

echo "12. 清理下载的文件"
rm -f linux-image-xiaomi-raphael.deb linux-headers-xiaomi-raphael.deb

echo "=== 脚本执行完成 ==="