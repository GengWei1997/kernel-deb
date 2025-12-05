# 一键更新内核脚本

sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/GengWei1997/kernel-deb/refs/heads/main/Update-kernel.sh)"

更新内容：
跟随主线更新到mainline:	6.18.0
添加ufw缺失的ipv6模块

# 执行完后出现

11. 显示/boot目录内容
总计 83932
drwx------  5 root root     4096  1月  1  1970 .
drwxr-xr-x 24 root root     4096 10月  6 13:16 ..
-rwx------  1 root root   245936 12月  5 00:03 config-6.18.0-sm8150-g54db96405339
drwx------  2 root root     4096 12月  3 15:50 dtbs
drwx------  3 root root     4096 11月 22 21:35 efi
-rwx------  1 root root 70902608 12月  5 11:31 initramfs
-rwx------  1 root root 14766592 12月  5 00:03 linux.efi
drwx------  3 root root     4096 11月 22 21:35 loader
=== 验证启动文件 ===
✓ 验证成功：
  - /boot/initramfs 文件存在
  - /boot/linux.efi 文件存在

文件详细信息：
-rwx------ 1 root root 68M 12月  5 11:31 /boot/initramfs
-rwx------ 1 root root 15M 12月  5 00:03 /boot/linux.efi
12. 清理下载的内核包
=== 脚本执行完成 ===


# 重启手机即可
