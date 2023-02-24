FROM python:latest as build-step

RUN pip install mkdocs-material

COPY . /app

WORKDIR /app

RUN mkdocs build -d site

FROM nginx:1.23.3-alpine

RUN apk add --no-cache --virtual .build-deps \
       gcc \
       libc-dev \
       make \
       openssl-dev \
       pcre-dev \
       zlib-dev \
       git

#RUN   git clone https://github.com/zmartzone/nginx-oidc.git /tmp/nginx-oidc && \
#        cd /tmp/nginx-oidc && \
#        git checkout v1.18.0 && \
#        ./configure --with-compat --add-dynamic-module=modules/ngx_http_auth_openidc && \
#        make modules && \
#        cp /tmp/nginx-oidc/modules/ngx_http_auth_openidc_module.so /usr/lib/nginx/modules/ && \
#        echo "load_module /usr/lib/nginx/modules/ngx_http_auth_openidc_module.so;" > /etc/nginx/conf.d/load_module.conf && \
#        apk add --no-cache openssl-dev


COPY --from=build-step /app/site /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
