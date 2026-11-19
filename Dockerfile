FROM archlinux:latest
USER root

#ENV http_proxy="http://192.168.31.5:20122"
#ENV https_proxy="http://192.168.31.5:20122"

# 安装 OpenSSH 和 curl
RUN pacman -Sy --noconfirm openssh curl \
    && curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 \
        -o /usr/local/bin/cloudflared \
    && chmod +x /usr/local/bin/cloudflared \
    && pacman -S php\
    && pacman -Scc --noconfirm

# 设置 root 密码
RUN echo "root:rootpass" | chpasswd 

RUN mkdir -p /etc/ssh/keys \
    && ssh-keygen A 
RUN chmod -R 777 /etc/ssh
# 静态站点根目录
RUN mkdir -p /app
COPY index.html /app/index.html
WORKDIR /app

EXPOSE 8888
# 启动 sshd 和 cloudflared
CMD whoami&& nohup php -S 0.0.0.0:${PORT} -t /app & /usr/sbin/sshd -D & cloudflared tunnel --no-autoupdate run --token "eyJhIjoiNDI2YmVjZjY0ODhiZDFhYjk3YTYxNzYxMmZkZTFlYjAiLCJ0IjoiMjA1NGI5NzEtMzg5MS00YWQ4LWIxOTYtMzBlMjRiNmMyYTZkIiwicyI6Ik1XWXlOR1kyTlRFdE56TXpPUzAwTkRnM0xUZzVPVGd0WkRsa1pXRXlOVGs1TlRJeCJ9"


