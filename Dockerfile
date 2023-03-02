FROM python:latest as build-step

RUN pip install mkdocs-material

COPY . /app

WORKDIR /app

RUN mkdocs build -d site

FROM nginx:1.23.3-alpine

COPY --from=build-step /app/site /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
