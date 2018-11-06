# Looking for information on environment variables?
# We don't declare them here — take a look at our docs.
# https://github.com/swagger-api/swagger-ui/blob/master/docs/usage/configuration.md

FROM nginx:1.15-alpine

RUN apk add nodejs

LABEL maintainer="fehguy"

RUN apk --no-cache -U upgrade

ENV API_KEY "**None**"
ENV SWAGGER_JSON "/app/swagger.json"
ENV PORT 8080
ENV BASE_URL ""

RUN addgroup -S swagger \
    && \
    adduser -D -G swagger -u 1000 -s /bin/bash -h /home/swagger swagger

COPY ./docker/nginx.conf /etc/nginx/

# copy swagger files to the `/js` folder
COPY ./dist/* /usr/share/nginx/html/
COPY ./docker/run.sh /usr/share/nginx/
COPY ./docker/configurator /usr/share/nginx/configurator

RUN chmod +x /usr/share/nginx/run.sh

RUN chown -R swagger:swagger /usr/share/nginx /etc/nginx

USER 1000

EXPOSE 8080

CMD ["sh", "/usr/share/nginx/run.sh"]
