## To run locally 

- install mongodb

- npm install
- bower install

- grunt serve

## To deploy

npm install -g imagemin imagemin-optipng imagemin-pngquant pm2

grunt build 

cd dist 
NODE_ENV=production pm2 server/coc.js 

