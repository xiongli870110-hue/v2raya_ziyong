📘 README.md — v2rayA 离线安装包部署指南
📦 项目简介
本项目提供 v2rayA 的离线安装包，适用于无法访问 GitHub 或希望快速部署的环境。安装包包含：

✅ v2rayA 主程序（v2.2.7.3）

✅ v2ray-core 可执行文件

✅ geoip.dat 和 geosite.dat 数据文件

✅ systemd 服务配置

✅ 自动软链接设置

🖥️ 支持平台
Ubuntu 16.04+

Debian 8/9+

QNAP NAS（x86_64 架构）

其他支持 systemd 的 Linux 系统

🚀 快速安装步骤
下载离线安装包 v2rayA-bundle.tar.gz 和安装脚本：
wget https://github.com/xiongli870110-hue/v2raya_ziyong/releases/download/v2rayA-bundle-v2.2.7.3/v2rayA-bundle.tar.gz
wget https://your-repo/install-v2raya-bundle-github-systemd.sh
chmod +x install-v2raya-bundle-github-systemd.sh

执行安装脚本：
./install-v2raya-bundle-github-systemd.sh

安装完成后访问：
http://<你的IP>:2017

🔧 安装内容说明
路径	内容
/opt/v2ray/	主程序、核心程序、数据文件
/usr/local/bin/	v2rayA 和 v2ray 的软链接
/usr/local/share/v2ray/	geoip.dat 和 geosite.dat 的软链接
/etc/systemd/system/v2rayA.service	systemd 服务配置

🛠️ 管理服务命令
systemctl start v2rayA
systemctl stop v2rayA
systemctl restart v2rayA
systemctl status v2rayA

📤 卸载方法（可选）
systemctl stop v2rayA
systemctl disable v2rayA
rm -rf /opt/v2ray /usr/local/bin/v2ray /usr/local/bin/v2rayA /usr/local/share/v2ray /etc/systemd/system/v2rayA.service
systemctl daemon-reload


very nice!








