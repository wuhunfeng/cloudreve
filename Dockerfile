FROM debian:latest

RUN apt-get update && apt-get install -y \
    wget \
    unzip
RUN apt-get update && apt-get install -y aria2
WORKDIR /app

RUN wget https://github.com/cloudreve/cloudreve/releases/download/4.10.1/cloudreve_4.10.1_linux_amd64.tar.gz \
    && unzip cloudreve_4.10.1_linux_amd64.tar.gz \
    && rm cloudreve_4.10.1_linux_amd64.tar.gz

RUN chmod 777 /app
COPY aria2.conf /app/aria2.conf
# 复制配置文件模板到容器中
COPY conf.ini /app/conf.ini
# 定义 ARG 变量（构建时使用）
ARG SLAVE_SECRET
# 用 sed 替换配置文件中的占位符
RUN sed -i "s|TEMP_SLAVE_SECRET|${SLAVE_SECRET}|g" /app/conf.ini

RUN chmod +x ./cloudreve

RUN mkdir -p /aria2/data

RUN chmod 777 /aria2/data

EXPOSE 8080

# CMD ["./cloudreve","-c","/app/conf.ini"]
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh
CMD ["/app/start.sh"]
