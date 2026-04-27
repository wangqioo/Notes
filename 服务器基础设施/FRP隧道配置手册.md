# FRP 隧道配置手册

> 最后更新：2026-04-27

## 架构总览

```
公网服务器 (frps)
  IP: 150.158.146.192
  frps 端口: 7000
  API/Dashboard: :7500
  frp-manager 面板: http://150.158.146.192:6128/

局域网设备 (frpc 客户端)
  Spark1    — WiFi: 192.168.1.23  | 公网 SSH: :6001
  Spark2    — WiFi: 192.168.1.43  | 公网 SSH: :6002
  Mac Mini  — WiFi: 192.168.1.5   | 公网 SSH: :6003
  Orin Nano — WiFi: 192.168.1.9   | 公网 SSH: :6004 (端口待确认)
```

---

## frps 服务端（150.158.146.192）

- 配置目录：`/opt/frp/`
- 认证 Token：`D3DW87VREu1q5sMKWpqizcCF9u9ue4UP`
- 管理 API：`http://127.0.0.1:7500`（Basic Auth: admin/admin）
- 服务管理：`systemctl status frps`

---

## frpc 客户端配置

### Spark1（192.168.1.23）

- 配置文件：`/opt/frp/frpc.toml`
- 服务：`systemctl status frpc`
- serverAddr 直连：`150.158.146.192:7000`

### Spark2（192.168.1.43）

- 配置文件：`/opt/frp/frpc.toml`
- 服务：`systemctl status frpc`
- serverAddr 直连：`150.158.146.192:7000`

### Mac Mini（192.168.1.5）

> **重要**：Mac Mini 所在 ISP 的 DPI 会识别并拦截 frp v0.61 的 HTTP/2 协议指纹，
> 导致直连 frps:7000 时反复 EOF 断线。**必须通过 SSH 隧道中转。**

#### SSH 隧道服务（launchd）

文件：`/Users/wangqi/Library/LaunchAgents/com.ssh.frp.tunnel.plist`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Label</key><string>com.ssh.frp.tunnel</string>
  <key>ProgramArguments</key><array>
    <string>/usr/bin/ssh</string>
    <string>-o</string><string>StrictHostKeyChecking=no</string>
    <string>-o</string><string>ServerAliveInterval=30</string>
    <string>-o</string><string>ServerAliveCountMax=3</string>
    <string>-o</string><string>ExitOnForwardFailure=yes</string>
    <string>-L</string><string>17000:150.158.146.192:7000</string>
    <string>-N</string><string>wq@192.168.1.43</string>
  </array>
  <key>RunAtLoad</key><true/>
  <key>KeepAlive</key><true/>
  <key>StandardOutPath</key>
    <string>/Users/wangqi/.frp/ssh_tunnel.out.log</string>
  <key>StandardErrorPath</key>
    <string>/Users/wangqi/.frp/ssh_tunnel.err.log</string>
</dict></plist>
```

原理：Mac Mini → SSH → Spark2(192.168.1.43) → 转发到 frps:7000，绕过 ISP DPI。

#### frpc 配置（/Users/wangqi/.frp/frpc.toml）

```toml
serverAddr = "127.0.0.1"
serverPort = 17000           # 走本地 SSH 隧道，不直连公网
auth.method = "token"
auth.token = "D3DW87VREu1q5sMKWpqizcCF9u9ue4UP"
transport.heartbeatInterval = 30
transport.heartbeatTimeout = 90
transport.tls.enable = false
loginFailExit = false
log.to = "/Users/wangqi/.frp/frpc.log"
log.level = "debug"
log.maxDays = 3

[[proxies]]
name = "macmini-ssh"
type = "tcp"
localIP = "127.0.0.1"
localPort = 22
remotePort = 6003

[[proxies]]
name = "alicization-town"
type = "tcp"
localIP = "127.0.0.1"
localPort = 5660
remotePort = 6150

[[proxies]]
name = "macmini-consultant"
type = "tcp"
localIP = "127.0.0.1"
localPort = 3005
remotePort = 6158
```

服务管理（launchd）：

```bash
launchctl load   ~/Library/LaunchAgents/com.frp.client.plist
launchctl unload ~/Library/LaunchAgents/com.frp.client.plist
```

### Orin Nano（192.168.1.9）

- 系统账号：`nvidia` / 密码：`nvidia`
- 配置文件：`/opt/frp/frpc.toml`
- 服务管理：`echo 'nvidia' | sudo -S systemctl restart frpc`
- serverAddr 直连：`150.158.146.192:7000`

#### frpc.toml 追加（Caddy HTTPS 隧道）

```toml
# Caddy HTTPS Web Frontend
[[proxies]]
name = "orin-caddy"
type = "tcp"
localIP = "127.0.0.1"
localPort = 443
remotePort = 6205
```

访问方式：`https://150.158.146.192:6205`（自签证书，需忽略证书警告）

---

## 端口分配表

| 远程端口 | 设备 | 服务 | 备注 |
|---------|------|------|------|
| 6001 | Spark1 | SSH :22 | — |
| 6002 | Spark2 | SSH :22 | — |
| 6003 | Mac Mini | SSH :22 | — |
| 6117 | Spark2 | MinerU API :8765 | — |
| 6125 | Spark2 | LinkBox Web :8767 | — |
| 6128 | Spark2 | frp-manager 面板 :6128 | — |
| 6150 | Mac Mini | alicization-town :5660 | — |
| 6158 | Mac Mini | consultant :3005 | 原 6140，冲突改此 |
| 6205 | Orin Nano | Caddy HTTPS :443 | 自签证书 |

---

## frp-manager 管理面板

- 位置：`/home/wq/frp-manager/`（Spark2）
- 访问：`http://150.158.146.192:6128/`
- 设备配置：`/home/wq/frp-manager/devices.json`
- 功能：代理列表从 frps API 动态读取，设备增删改配置文件

---

## 常用运维命令

```bash
# 查看 frps 上所有在线代理
curl -s http://150.158.146.192:7500/api/proxy/tcp \
  -u admin:admin | python3 -m json.tool

# 从 Spark1/Spark2 跳板 SSH 到 Mac Mini
ssh -J wq@150.158.146.192:6002 wangqi@127.0.0.1 -p 6003

# Orin Nano 重启 frpc
ssh nvidia@192.168.1.9 "echo 'nvidia' | sudo -S systemctl restart frpc"
```

---

## 历史问题与解决方案

| 问题 | 原因 | 解决 |
|------|------|------|
| Mac Mini frpc 反复 EOF 断线 | ISP DPI 拦截 frp HTTP/2 协议指纹 | SSH 隧道绕过 DPI |
| Mac Mini IP 变更（31.187→1.5） | DHCP 重新分配 | 扫描 192.168.1.x 子网重新发现 |
| macmini-consultant 端口冲突 | 6140 已被 spark2-lab-mgmt 占用 | 改为 6158 |
| 工作区 SSH key 未授权 Mac Mini | 首次访问 | sshpass+scp 方式添加到 authorized_keys |
| Orin Nano frpc 重启需 sudo 密码 | systemctl 需要交互认证 | `echo 'nvidia' \| sudo -S` 管道方式 |
