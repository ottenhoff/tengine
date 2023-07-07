#!/bin/bash

# Test to see if our version of gcc supports __SIZEOF_INT128__
if gcc -dM -E - </dev/null | grep -q __SIZEOF_INT128__
then
  ecflag="enable-ec_nistp_64_gcc_128"
else
  ecflag=""
fi

version_pcre=/home/ubuntu/dev/pcre-8.45
version_zlib=/home/ubuntu/dev/zlib-1.2.13
version_openssl=/home/ubuntu/dev/openssl

./configure \
  --prefix=/etc/nginx \
  --with-cc-opt="-O3 -fPIE -fstack-protector-strong -Wformat -Werror=format-security" \
  --with-ld-opt="-Wl,-Bsymbolic-functions -Wl,-z,relro" \
  --with-pcre="$version_pcre" \
  --with-zlib="$version_zlib" \
  --with-openssl-opt="no-weak-ssl-ciphers no-ssl3 no-shared $ecflag -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong" \
  --with-openssl="$version_openssl" \
  --sbin-path=/usr/sbin/nginx \
  --modules-path=/usr/lib/nginx/modules \
  --conf-path=/etc/nginx/nginx.conf \
  --error-log-path=/var/log/nginx/error.log \
  --http-log-path=/var/log/nginx/access.log \
  --pid-path=/var/run/nginx.pid \
  --lock-path=/var/run/nginx.lock \
  --http-client-body-temp-path=/var/cache/nginx/client_temp \
  --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
  --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
  --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
  --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
  --user=nginx \
  --group=nginx \
  --with-file-aio \
  --with-http_auth_request_module \
  --with-http_gunzip_module \
  --with-http_gzip_static_module \
  --with-http_realip_module \
  --with-http_ssl_module \
  --with-http_stub_status_module \
  --with-http_sub_module \
  --with-http_v2_module \
  --with-pcre-jit \
  --with-threads \
  --without-http_empty_gif_module \
  --without-http_geo_module \
  --without-http_split_clients_module \
  --without-http_ssi_module \
  --without-mail_imap_module \
  --without-mail_pop3_module \
  --without-mail_smtp_module \
  --add-module=modules/ngx_http_upstream_session_sticky_module \
  --add-module=modules/ngx_http_upstream_check_module
make
sudo make install
sudo make clean
#sudo strip -s /usr/sbin/nginx*
