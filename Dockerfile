FROM nodejs

MAINTAINER Jaemok Jeong "jmjeong@gmail.com"

RUN npm install -g pm2

VOLUME ["/app"]
ADD dist /app
CMD ["pm2" "/app/server/coc.js"]

EXPOSE 9000
