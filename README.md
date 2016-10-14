## Demo Site

- http://coc.jmjeong.com 

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


## To Add new building, troop 

- change server/api/users/user.model.js file 
	ex) building: {
			…
		​ bombtower: [Number],
			…
		}
- set initial value in mongodb

	ex) db.users.update( 
		{}, 
		{ $set: {"building.bombtower": [] } }, 
		{ multi:true })
