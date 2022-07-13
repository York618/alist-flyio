# Alist on Fly.io
## 状态
[![Fly Deploy cd](https://github.com/York618/alist-flyio/actions/workflows/main.yml/badge.svg)](https://github.com/York618/alist-flyio/actions/workflows/main.yml)
## 有问题去Discussions，HostLoc等不是工单论坛
## 概述
在[Fly.io](https://fly.io)部署[Alist](https://github.com/Xhofe/alist)
特点：彻底摆脱ban权限zhi（荷兰🇳🇱，阿姆斯特丹），自带cdn
## 如何部署
1. 先到 [Fly.io](https://fly.io/) 注册账号，***注意：注册时要记得绑定信用卡，银联的就行***
2. GitHub Actions 增加`FLY_API_TOKEN`、`APP_NAME`、`DATABASE`、`SQLUSER`、`SQLPASSWORD`、`SQLHOST`、`SQLPORT`和`SQLNAME`安全字段（Secrets)
* FLY_API_TOKEN - Fly API 接口 Token 值，可访问 <https://web.fly.io/user/personal_access_tokens> 或在本地执行`flyctl auth token`查看
* APP_NAME - 应用名称，注意此名称全局唯一
* DATABASE - 数据库类型（sqlite3 / mysql）
* SQLUSER - MySQL 用户名（数据库类型为远程 MySQL 时需要更改）
* SQLPASSWORD - MySQL 密码（数据库类型为远程 MySQL 时需要更改）
* SQLHOST - MySQL 主机地址（数据库类型为远程 MySQL 时需要更改）
* SQLPORT - MySQL 端口（数据库类型为远程 MySQL 时需要更改）
* SQLNAME - MySQL 数据库名称（数据库类型为远程 MySQL 时需要更改）
3. 推送代码即可触发部署，另外已设置每月三号八点（UTC）自动部署
## F&Q
账号密码？
Log里写着的
