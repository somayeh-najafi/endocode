FROM centos:centos7

WORKDIR /tmp

# Install prerequisites for Nginx compile
RUN yum install -y  openssl-devel\
        gcc \
        gcc-c++ \
        make \
        zlib-devel \
        pcre-devel \
        gd-devel \
        krb5-devel \
        openldap-devel
       

# Copy Nginx source 
RUN mkdir /tmp/nginx
ADD project/ /tmp/nginx/

# Compile Nginx
WORKDIR /tmp/nginx
RUN ./configure \
        --user=nginx \
        --with-debug \
        --group=nginx \
        --prefix=/usr/website/nginx \
        --sbin-path=/usr/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --pid-path=/run/nginx.pid \
        --lock-path=/run/lock/subsys/nginx \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --with-http_gzip_static_module \
        --with-http_stub_status_module \
        --with-http_ssl_module \
        --with-pcre \
        --with-http_image_filter_module \
        --with-file-aio \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module && \
    make && \
    make install

WORKDIR /tmp

# Add nginx user
RUN adduser -c "Nginx user" nginx && \
    setcap cap_net_bind_service=ep /usr/sbin/nginx

RUN touch /run/nginx.pid

RUN chown nginx:nginx /etc/nginx /etc/nginx/nginx.conf /var/log/nginx /usr/website/nginx /run/nginx.pid

# Cleanning
RUN yum remove -y gcc \
        gcc-c++ \
        make && \
    yum autoremove -y && \
    rm -rf /tmp/*

# PORTS
EXPOSE 80
EXPOSE 443

USER nginx

CMD ["nginx", "-g", "daemon off;"] 
