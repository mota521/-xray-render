FROM alpine:3.19
RUN apk add --no-cache ca-certificates curl unzip \
    && curl -L -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/download/v25.1.30/Xray-linux-64.zip \
    && unzip /tmp/xray.zip -d /usr/local/bin/ \
    && rm /tmp/xray.zip \
    && chmod +x /usr/local/bin/xray
COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]
