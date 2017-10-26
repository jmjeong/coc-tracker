# Clash of Clans tracker

Demo Site - http://coc.jmjeong.com 

## To run locally 

- install mongodb

- npm install
- bower install

- grunt serve

## To deploy

- npm install -g imagemin imagemin-optipng imagemin-pngquant pm2

- grunt build 

- cd dist 
- NODE_ENV=production pm2 start server/coc.js

## Update the information

### Update costs, level 

- change information from client/data/building.js, hero.js, research.js
- change client/app/main/about.jade
- change client/components/navbar/navbar.controller.coffee 

### To add new building, troop etc

- change server/api/users/user.model.js file 
```
	ex) building: {
			…
		    bombtower: [Number],
			…
		}
```

- set initial value in mongodb
```
	ex) db.users.update( 
		{}, 
		{ $set: {"building.bombtower": [] } }, 
		{ multi:true })
```

## License

The MIT License (MIT)

Copyright(c) Jaemok Jeong
