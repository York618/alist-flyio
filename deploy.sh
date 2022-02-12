#!/bin/sh

REGION="ams"

if ! command -v flyctl >/dev/null 2>&1; then
    printf '\e[33m进度1/5：安装Fly.io CLI。\n\e[0m'
    curl -L https://fly.io/install.sh | FLYCTL_INSTALL=/usr/local sh
fi

if [ -z "${APP_NAME}" ]; then
    printf '\e[31m错误：未指定APP名称。\n\e[0m' && exit 1
fi

flyctl info --app "${APP_NAME}" >/tmp/${APP_NAME} 2>&1;
if [ "$(cat /tmp/${APP_NAME} | grep -o "Could not resolve App")" = "Could not resolve App" ]; then
    printf '\e[33m进度2/5：创建应用\n\e[0m'
    flyctl apps create "${APP_NAME}" >/dev/null 2>&1;

    flyctl info --app "${APP_NAME}" >/tmp/${APP_NAME} 2>&1;
    if [ "$(cat /tmp/${APP_NAME} | grep -o "Could not resolve App")" != "Could not resolve App" ]; then
        printf '\e[32m创建应用成功\n\e[0m'
    else
        printf '\e[31m错误：创建应用失败\n\e[0m' && exit 1
    fi
else
    printf '\e[33m应用已被创建，跳过……\n\e[0m'
fi

printf '\e[33m进度3/5：创建配置文件\n\e[0m'
cat <<EOF >./fly.toml
app = "$APP_NAME"
kill_signal = "SIGINT"
kill_timeout = 5
processes = []
[env]
[experimental]
  allowed_public_ports = []
  auto_rollback = true
[[services]]
  http_checks = []
  internal_port = 2233
  # processes = ["app"]
  protocol = "tcp"
  script_checks = []
  [services.concurrency]
    hard_limit = 50
    soft_limit = 35
    type = "connections"
  [[services.ports]]
    handlers = ["http"]
    port = 80
  [[services.ports]]
    handlers = ["tls", "http"]
    port = 443
  [[services.tcp_checks]]
    grace_period = "120s"
    interval = "15s"
    restart_limit = 0
    timeout = "2s"
EOF
printf '\e[32m成功创建配置\n\e[0m'
printf '\e[33m进度4/5：创建环境变量及部署区域\n\e[0m'

flyctl secrets set DATABASE="${DATABASE}"
flyctl secrets set SQLUSER="${SQLUSER}"
flyctl secrets set SQLPASSWORD="${SQLPASSWORD}"
flyctl secrets set SQLHOST="${SQLHOST}"
flyctl secrets set SQLPORT="${SQLPORT}"
flyctl secrets set SQLNAME="${SQLNAME}"
flyctl regions set ${REGION}
printf '\e[32m进度5/5：部署\n\e[0m'
flyctl deploy --detach
# flyctl status --app ${APP_NAME}
