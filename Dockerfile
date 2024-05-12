
FROM public.ecr.aws/nginx/nginx:latest

LABEL maintainer="Abhishek Gujjar"

COPY index.html /usr/share/nginx/html

COPY img*.png /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

