#!/bin/bash
set -Eeuo pipefail

# Save script output so setup problems can be diagnosed after launch.
exec > >(tee -a /var/log/user-data.log) 2>&1

APP_DIR="/opt/EC2_Heartbeat_Python_Automation"
SERVICE_USER="heartbeat"
REPO_URL="https://github.com/Andrey242-GH/EC2_Heartbeat_Python_Automation.git"
BRANCH="main"

echo "Starting EC2 Heartbeat Automation setup..."

dnf update -y
dnf install -y git python3 python3-pip

if ! id -u "$SERVICE_USER" >/dev/null 2>&1; then
    useradd \
        --system \
        --home-dir "$APP_DIR" \
        --shell /sbin/nologin \
        "$SERVICE_USER"
fi

git clone \
    --single-branch \
    --branch "$BRANCH" \
    "$REPO_URL" \
    "$APP_DIR"

chown -R "$SERVICE_USER:$SERVICE_USER" "$APP_DIR"

runuser -u "$SERVICE_USER" -- \
    python3 -m venv "$APP_DIR/.venv"

runuser -u "$SERVICE_USER" -- \
    "$APP_DIR/.venv/bin/python" -m pip install --upgrade pip

runuser -u "$SERVICE_USER" -- \
    "$APP_DIR/.venv/bin/python" -m pip install \
    -r "$APP_DIR/requirements.txt"

mkdir -p /var/lib/heartbeat
chown "$SERVICE_USER:$SERVICE_USER" /var/lib/heartbeat
chmod 750 /var/lib/heartbeat

cd "$APP_DIR"

runuser -u "$SERVICE_USER" -- \
    "$APP_DIR/.venv/bin/python" -m pytest -v

cp "$APP_DIR/systemd/heartbeat.service" \
    /etc/systemd/system/heartbeat.service

cp "$APP_DIR/systemd/heartbeat.timer" \
    /etc/systemd/system/heartbeat.timer

cp "$APP_DIR/systemd/heartbeat-web.service" \
    /etc/systemd/system/heartbeat-web.service

systemctl daemon-reload

systemctl start heartbeat.service
systemctl enable --now heartbeat.timer
systemctl enable --now heartbeat-web.service

echo "Heartbeat automation deployment completed."
