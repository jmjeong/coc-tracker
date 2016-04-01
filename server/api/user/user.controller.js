'use strict';

var User = require('./user.model');
var passport = require('passport');
var config = require('../../config/environment');
var jwt = require('jsonwebtoken');
var _ = require('lodash');
var moment = require('moment');
var logger = require('log4js').getLogger('user.controller');

logger.setLevel('INFO');

var validationError = function(res, err) {
  return res.json(422, err);
};

/**
 * Get list of users
 * restriction: 'admin'
 */
exports.index = function(req, res) {
  User.find({}, '-salt -hashedPassword', function (err, users) {
    if(err) return res.send(500, err);
    res.json(200, users);
  });
};

/**
 * Creates a new user
 */
exports.create = function (req, res, next) {
  var newUser = new User(req.body);
  //  console.log(req.body);
  newUser.provider = 'local';
  newUser.role = 'user';
  newUser.save(function(err, user) {
    if (err) return validationError(res, err);
    var token = jwt.sign({_id: user._id }, config.secrets.session, { expiresInMinutes: 60*24*10 });
    res.json({ token: token });
  });
};

/**
 * Get a single user
 */
exports.show = function (req, res, next) {
  var userId = req.params.id;

  User.findById(userId, function (err, user) {
    if (err) return next(err);
    if (!user) return res.send(401);
    res.json(user.profile);
  });
};

/**
 * Deletes a user
 * restriction: 'admin'
 */
exports.destroy = function(req, res) {
  User.findByIdAndRemove(req.params.id, function(err, user) {
    if(err) return res.send(500, err);
    return res.send(204);
  });
};

/**
 * Change a users password
 */
exports.changePassword = function(req, res, next) {
  var userId = req.user._id;
  var oldPass = String(req.body.oldPassword);
  var newPass = String(req.body.newPassword);

  User.findById(userId, function (err, user) {
    if(user.authenticate(oldPass)) {
      user.password = newPass;
      user.save(function(err) {
        if (err) return validationError(res, err);
        res.send(200);
      });
    } else {
      res.send(403);
    }
  });
};

/**
 * Get my info
 */
exports.me = function(req, res, next) {
  var userId = req.user._id;
  User.findOne({
    _id: userId
  }, 'name email role lastUpdated', function(err, user) { // don't ever give out the password or salt
    if (err) return next(err);
    if (!user) return res.json(401);
    res.json(user);
  });
};

exports.getData = function(req, res, next) {
    // console.log(req.params.id)
    if (req.params.id) {
        var userId = req.params.id;
    }
    else {
        var userId = req.user._id;
    }
    User.findOne({
        _id: userId
    }, 'name log upgrade settting research building', function(err, user) { // don't ever give out the password or salt
        if (err) return next(err);
        if (!user) return res.json(401);
        logger.info(user);
        res.json(user);
    });
};

exports.getLog = function(req, res, next) {
    // console.log(req.params.id)
    if (req.params.id) {
        var userId = req.params.id;
    }
    else {
        var userId = req.user._id;
    }
    User.findOne({
        _id: userId
    }, 'name log', function(err, user) {
        if (err) return next(err);
        if (!user) return res.json(401);
        res.json(user);
    });
};

exports.getUpgrade = function(req, res, next) {
    // console.log(req.params.id)
    if (req.params.id) {
        var userId = req.params.id;
    }
    else {
        var userId = req.user._id;
    }
    User.findOne({
        _id: userId
    }, 'name upgrade', function(err, user) {
        if (err) return next(err);
        if (!user) return res.json(401);
		logger.info(user);
        res.json(user);
    });
};

exports.putData = function(req, res, next) {
    logger.info('putData', req.user._id, req.body.action, req.body.data);
    var lastUpdated = new moment();

    switch (req.body.action) {
        case 'setting': {
            User.findById(req.user._id, function(err, user) {
                if (err) return res.send(500,err);
                if (!user) return res.send(404);

                _.map(req.body.data, function(d) {
                    user.setting[d.name] = d.value;
                });
                user.lastUpdated = lastUpdated;
            });
        }
    }
/*
    User.findById(req.user._id, function (err, user) {
        if (err) return res.send(500, err);
        if (!user) return res.send(404);

        var data = {}
        if (user.data)
            data = JSON.parse(user.data);

		logger.info('userdata', data);
        var HEROFLAG = 100;
        if (req.body.action) {
            user.lastUpdated = new moment();
            switch (req.body.action) {
            case 'changeLevel':
                _.map(req.body.data, function (d) {
                    var name = d.name;
                    var index = d.index;
                    var level = d.level;
                    if (index < 0 || index == HEROFLAG) {
                        data[name] = level;
                    }
                    else {
                        if (typeof data[name] == 'undefined') {
                            data[name] = [];
                        }
                        data[name][index] = level;
                    }
                });
                break;
            case 'completeUpgrade':
				console.log('complete Upgrade', data.upgrade);
                    var now = new moment();
                    _.map(data.upgrade, function(u) {
                        if (now.isAfter(moment(u.due))) {
                            if (u.index < 0 || u.index == HEROFLAG) {
                                data[u.name] = u.level;
                            }
                            else {
                                if (typeof data[u.name] == 'undefined') {
                                    data[u.name] = [];
                                }
                                data[u.name][u.index] = u.level;
                            }
                            user.log.push({title:u.title, level:u.level, complete:u.due});
                            // console.log(user.log);
                        }
                    });
                    _.remove(data.upgrade, function(u) {
                        return now.isAfter(moment(u.due));
                    });
                    break;
            case 'changeUpgrade':
                _.map(req.body.data, function(d) {
                    var find = _.findIndex(data.upgrade, {
                        name: d.name,
                        index: d.index
                    });
                    if (find < 0) {
                        if (!('upgrade' in data)) {
                            data.upgrade = [];
                        }
                        data.upgrade.push(d);
                    }
                    else data.upgrade[find] = d;
                });
                break;
            case 'cancelUpgrade':
                _.map(req.body.data, function(d) {
                    var name = d.name;
                    var index = d.index;
                    _.remove(data.upgrade, {
                        name: name,
                        index: index
                    })
                });
                break;
            case 'set':
                _.map(req.body.data, function(d) {
                    data[d.name] = d.value;
                });
                break;
            }
        }
        user.data = JSON.stringify(data);
        user.markModified('data');
        user.save(function (err) {
            if (err) return res.send(500, err);
            res.send(200);
        });
    });
    */
};

/**
 * Authentication callback
 */
exports.authCallback = function(req, res, next) {
  res.redirect('/');
};

