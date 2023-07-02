FROM nginx as builder

WORKDIR /etc/nginx/

RUN rm nginx.conf conf.d/default.conf

FROM builder

COPY ./proxy /etc/nginx/

COPY ./certs /etc/ssl/certs/

ARG CHECK_PORT

ARG CHECK_DOMAIN

ENV CHECK_PORT=${CHECK_PORT}

ENV CHECK_DOMAIN=${CHECK_DOMAIN}

RUN cat /etc/nginx/conf.d/auth.template | envsubst '${CHECK_DOMAIN}' > /etc/nginx/conf.d/auth.conf
RUN cat /etc/nginx/conf.d/auth.template | envsubst '${CHECK_PORT}' > /etc/nginx/conf.d/auth.conf

RUN cat /etc/nginx/conf.d/check_apis.template | envsubst '${CHECK_DOMAIN}' > /etc/nginx/conf.d/check_apis.conf
RUN cat /etc/nginx/conf.d/check_apis.template | envsubst '${CHECK_PORT}' > /etc/nginx/conf.d/check_apis.conf

RUN cat /etc/nginx/api_gateway.template  | envsubst '${CHECK_DOMAIN}' > /etc/nginx/api_gateway.conf 
RUN cat /etc/nginx/api_gateway.template  | envsubst '${CHECK_PORT}' > /etc/nginx/api_gateway.conf 

RUN rm -rf *.template conf.d/*.template