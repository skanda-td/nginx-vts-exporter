FROM nginx:1.25.4

# Install build dependencies
RUN apt-get update && apt-get install -y \
    git build-essential libpcre3 libpcre3-dev zlib1g-dev libssl-dev wget

# Set up working directory
WORKDIR /tmp

# Download Nginx source (matching version)
RUN wget http://nginx.org/download/nginx-1.25.4.tar.gz && \
    tar zxvf nginx-1.25.4.tar.gz

# Clone VTS module
RUN git clone https://github.com/vozlt/nginx-module-vts.git

# Build Nginx with VTS module
WORKDIR /tmp/nginx-1.25.4
RUN ./configure --with-http_ssl_module --add-module=/tmp/nginx-module-vts && \
    make && make install

# Cleanup and set up directory
RUN mkdir -p /etc/nginx/conf.d /usr/share/nginx/html && \
    echo "Nginx with VTS Module built successfully" > /usr/share/nginx/html/index.html && \
    apt-get remove -y build-essential git wget && apt-get autoremove -y && rm -rf /var/lib/apt/lists/* /tmp/*

EXPOSE 8080

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]