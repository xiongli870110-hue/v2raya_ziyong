# 📘 v2rayA 离线安装包部署指南

## 📦 项目简介

本项目提供 **v2rayA 的离线安装包**，适用于无法访问 GitHub 或希望快速部署的环境。  
安装包内容包括：

- ✅ **v2rayA 主程序**（v2.2.7.3）
- ✅ **v2ray-core 可执行文件**
- ✅ **geoip.dat 与 geosite.dat 数据文件**
- ✅ **systemd 服务配置**
- ✅ **自动软链接设置**

---

## 🖥️ 支持平台

- Ubuntu 16.04 及以上
- Debian 8/9 及以上
- QNAP NAS（x86_64 架构）
- 其他支持 **systemd** 的 Linux 系统

---

## 🚀 快速安装步骤

1. **下载离线安装包与安装脚本**
  
  ```bash
  wget https://github.com/xiongli870110-hue/v2raya_ziyong/releases/download/v2rayA-bundle-v2.2.7.3/v2rayA-bundle.tar.gz
  wget https://your-repo/install-v2raya-bundle-github-systemd.sh
  chmod +x install-v2raya-bundle-github-systemd.sh
  ```
  
2. **执行安装脚本**
  
  ```bash
  ./install-v2raya-bundle-github-systemd.sh
  ```
  
3. **安装完成后访问**
  
  ```
  http://<你的IP>:2017
  ```
  

---

## 🔧 安装内容说明

| 路径  | 内容说明 |
| --- | --- |
| `/opt/v2ray/` | 主程序、核心程序、数据文件 |
| `/usr/local/bin/` | `v2rayA` 与 `v2ray` 的软链接 |
| `/usr/local/share/v2ray/` | `geoip.dat` 与 `geosite.dat` 的软链接 |
| `/etc/systemd/system/v2rayA.service` | systemd 服务配置文件 |

---

## 🛠️ 服务管理命令

```bash
systemctl start v2rayA      # 启动服务
systemctl stop v2rayA       # 停止服务
systemctl restart v2rayA    # 重启服务
systemctl status v2rayA     # 查看状态
```

---

## 📤 卸载方法（可选）

```bash
systemctl stop v2rayA
systemctl disable v2rayA

rm -rf /opt/v2ray        /usr/local/bin/v2ray        /usr/local/bin/v2rayA        /usr/local/share/v2ray        /etc/systemd/system/v2rayA.service

systemctl daemon-reload
```

---

✨ **非常棒的离线部署方案！**  
可快速在任何支持 systemd 的 Linux 系统中完成 v2rayA 的独立安装与运行。
