FROM alpine:3.18.4
RUN apk add --no-cache php82-openssl php82-curl php82-pdo_sqlite php82-dom php82-zlib php82-json php82-iconv php82-xml php82-fpm bash curl nginx vim php82
RUN mkdir /var/www/rainloop && cd /var/www/rainloop && curl -sL https://repository.rainloop.net/installer.php | php82 && \
    adduser -s /sbin/nologin -D -H -u 1000 -h /var/www/ www && \
    sed -i -E 's/(user|group) = nobody/\1 = www/ig' /etc/php82/php-fpm.d/www.conf && \
    sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 25M/' /etc/php82/php.ini && \
    sed -i 's/post_max_size = 8M/post_max_size = 25M/' /etc/php82/php.ini
COPY default.conf /etc/nginx/http.d/default.conf

VOLUME /var/www/rainloop/data

CMD /bin/bash -c "chown -R www:www /var/www/rainloop/data && php-fpm82 && nginx -g 'daemon off;'"
