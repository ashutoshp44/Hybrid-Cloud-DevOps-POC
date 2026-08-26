FROM nginx:alpine

RUN apk update && apk upgrade

COPY app/index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
