var mongoose = require('mongoose');
var _  = require('lodash');
var async = require('async');
var usr1 = mongoose.connect('mongodb://localhost/coc');
var usr2 = mongoose.createConnection('mongodb://localhost/coc2');

// mongoose.connection.on("open", function(){
//   console.log("mongodb is connected!!");
// });
// mongoose.connection.on('error', console.error);

var Schema = mongoose.Schema;

var UserSchema1 = new Schema({
  name: String,
  email: { type: String, lowercase: true },
  role: {
    type: String,
    default: 'user'
  },
  data: Schema.Types.Mixed,
  lastUpdated: Date,
  log: [ {
      title: String,
      level: Number,
      complete: Date
  }],
  hashedPassword: String,
  provider: String,
  salt: String
}, {collection: 'users'});


var UserSchema2 = new Schema({
  name: String,
  email: { type: String, lowercase: true },
  role: {
    type: String,
    default: 'user'
  },
  lastUpdated: Date,
  setting: {
    hideDoneBuilding: Boolean,
    hideDoneResearch: Boolean,
    hall: Number,
    setuphall: Number,
    limitTo: Number,
    builder: Number
  },
  building: {
      airdefense: [Number],
      airsweeper: [Number],
      archertower: [Number],
      cannon: [Number],
      eagleartillery: [Number],
      hiddentesla: [Number],
      infernotower: [Number],
      mortar: [Number],
      wizardtower: [Number],
      xbow: [Number],

      airbomb: [Number],
      bomb: [Number],
      giantbomb: [Number],
      seekingairmine: [Number],
      skeletontrap: [Number],
      springtrap: [Number],

      armycamp: [Number],
      barracks: [Number],
      darkbarracks: [Number],
      darkspellfactory: [Number],
      laboratory: [Number],
      spellfactory: [Number],

      darkelixirdrill: [Number],
      darkelixirstorage: [Number],
      elixircollector: [Number],
      elixirstorage: [Number],
      goldmine: [Number],
      goldstorage: [Number],

      clancastle: [Number],
      townhall: [Number]
  },
  research: {
      barbarian: Number,
      archer: Number,
      goblin: Number,
      giant: Number,
      wallbreaker: Number,
      balloon: Number,
      wizard: Number,
      healer: Number,
      dragon: Number,
      pekka : Number,
      minion: Number,
      hogrider: Number,
      valkyrie: Number,
      golem: Number,
      witch: Number,
      lavahound: Number,
      bowler: Number,
      lightning: Number,
      healing: Number,
      rage: Number,
      jump: Number,
      freeze: Number,
      poison: Number,
      earthquake: Number,
      haste: Number
  },
  walls: [ Number],
  log: [ {
      title: String,
      level: Number,
      complete: Date
  }],
  hero: {
      barbarianking: Number,
      archerqueen: Number,
      grandwarden: Number
  },
  upgrade: [ {
    name: String,
    title: String,
    index: Number,
    level: Number,
    time: Number,
    due: Date
    } ],
  hashedPassword: String,
  provider: String,
  salt: String
}, {collection: 'users'});          

var buildingList = [ 'airdefense', 'airsweeper', 'archertower', 'cannon', 'eagleartillery', 'hiddentesla', 'infernotower',
    'mortar', 'wizardtower', 'xbow', 'airbomb', 'bomb', 'giantbomb', 'seekingairmine', 'skeletontrap', 'springtrap',
    'armycamp', 'barracks', 'darkbarracks', 'darkspellfactory', 'laboratory', 'spellfactory',
    'darkelixirdrill', 'darkelixirstorage', 'elixircollector', 'elixirstorage', 'goldmine', 'goldstorage', 'clancastle', 'townhall'];

var researchList = ['barbarian', 'archer', 'goblin', 'giant', 'wallbreaker', 'balloon', 'wizard', 'healer', 'dragon',
'pekka', 'minion', 'hogrider', 'valkyrie', 'golem', 'witch', 'lavahound', 'bowler', 'lightning', 'healing', 'rage',
'jump', 'freeze', 'poison', 'earthquake', 'haste'];

var heroList = ['barbarianking', 'archerqueen', 'grandwarden'];

function convert() {
    var Users1 = usr1.model('Users', UserSchema1);
    var Users2 = usr2.model('Users', UserSchema2);

    Users1.find({}, function(err, users) {
        if (err) console.error(err);
        console.log('Convert v1.71 into v2 data. Total:', users.length);
        var count = 0;
        _.map(users, function(u) {
            console.log(' Converting ... ', u.name, '(', u.email, ')');
            Users2.find({email: u.email}, function(err, u2s) {
                if (u2s.length == 0) {
                    u2 = new Users2;
                    u2.email = u.email;
                }
                else u2 = u2s[0];

                u2.name = u.name;

                u2.log = u.log;
                u2.hashedPassword = u.hashedPassword;
                u2.lastUpdated = u.lastUpdated;
                u2.provider = u.provider;
                u2.role = u.role;
                if (u2.email == 'jmjeong@gmail.com') u2.role = 'admin';
                u2.salt = u.salt;

                var v1data = JSON.parse(u.data);

                u2.upgrade = v1data.upgrade;
                // console.log('v1data ', v1data);
                // console.log('v1data.set', v1data.set);
                if ('set' in v1data) {
                    u2.setting.hideDoneBuilding = v1data.set.hideDone;
                    u2.setting.hideDoneResearch = v1data.set.hideDoneResearch;
                    u2.setting.hall = v1data.hall;
                    u2.setting.setuphall = v1data.hall;
                }
                else {
                    u2.setting.hideDoneBuilding = false;
                    u2.setting.hideDoneResearch = false;
                    u2.setting.hall = 9;
                    u2.setting.setuphall = 9;
                }
                u2.setting.limitTo = 5;
                u2.setting.builder = v1data.builder;

                _.forEach(buildingList, function(v) {
                    u2.building[v] = v1data[v]
                   // console.log(v);
                });
                u2.building.xbow = v1data['x-bow'];
                _.forEach(researchList, function(v) {
                   u2.research[v] = v1data[v];
                });
                u2.research.pekka = v1data['p.e.k.k.a'];
                _.forEach(heroList, function(v) {
                    u2.hero[v] = v1data[v];
                });
                u2.walls = v1data.walls;


                u2.save(function(err) {
                    err && console.log(err);
                    if (users.length == ++count) {
                        console.log('Converting done');
                        process.exit(0);
                    }

                });
                // process.exit();
            });

        })
    });
}


convert();
