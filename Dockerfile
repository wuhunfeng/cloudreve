FROM debian:bullseye-slim

# Install dependencies in single layer
RUN apt-get update && apt-get install -y \
    wget \
    tar \
    unzip \
    aria2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Download and extract Cloudreve
RUN wget https://github.com/cloudreve/Cloudreve/files/14327249/cloudreveplus-linux-amd64v2.zip \
    && unzip cloudreveplus-linux-amd64v2.zip \
    && rm cloudreveplus-linux-amd64v2.zip
    && chmod +x ./cloudreve

# Create data directory with proper permissions
RUN mkdir -p /aria2/data && chown -R 1000:1000 /aria2/data

# Copy configuration files
COPY aria2.conf /app/aria2.conf
COPY conf.ini /app/conf.ini
COPY start.sh /app/start.sh

# Set permissions
RUN chmod +x /app/start.sh && \
    chown -R 1000:1000 /app

# Replace secret in config
ARG SLAVE_SECRET
RUN sed -i "s|TEMP_SLAVE_SECRET|${SLAVE_SECRET}|g" /app/conf.ini

# Runtime settings
USER 1000
EXPOSE 8100
VOLUME ["/aria2/data"]
CMD ["/app/start.sh"]
