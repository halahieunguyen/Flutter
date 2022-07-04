import 'dart:convert';

import 'package:mxh/model/Relationship.dart';

class User {
  int? _id;
  int? _countFollowed;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phone;
  DateTime? _birdDay;
  String? _address;
  String? _avatar;
  String? _cover;
  String? _story;
  List<Map<String, dynamic>> _workplace = [];
  List<Map<String, dynamic>> _education= [];
  DateTime? _createdAt;
  Relationship? _relationship1;
  Relationship? _relationship2;
  User (
    int id,
    String firstName,
    String lastName,
    String email,
    String phone,
    DateTime birdDay,
    String address,
    String avatar,
    String cover,
    String story,
    DateTime createdAt
  ) {
    this._id = id;
    this._firstName = firstName;
    this._lastName = lastName;
    this._email = email;
    this._phone = phone;
    this._birdDay = birdDay;
    this._address = address;
    this._avatar = avatar;
    this._cover = cover;
    this._story = story;
    this._createdAt = createdAt;
  }

  User.ajaxOptimize(
   Map<String, dynamic> options
  ) {
    if(options['id']!=null) {
      this._id = options['id'];
    };

    if(options['avatar']!=null) {
      this._avatar = options['avatar'];
    };

    if(options['last_name']!=null) {
      this._lastName = options['last_name'];
    };
    if(options['story']!=null) {
      this._story = options['story'];
    };
    if(options['cover']!=null) {
      this._cover = options['cover'];
    };

    if(options['address']!=null) {
      this._address = options['address'];
    };

    //  if(options['education']!=null) {
    //   print("---------------------------------------------------------");

    //   json.decode(options['education']).forEach(( value) {
    //     Map<String, dynamic> education = {};

    //   });
    // };
    if(options['first_name']!=null) {
      this._firstName = options['first_name'];
    };
    if(options['relationship1']!=null && options['relationship1'].length >0) {
      this._relationship1 = new Relationship.ajax(options['relationship1'][0]);
    };
    if(options['relationship2']!=null && options['relationship2'].length >0) {
      this._relationship2 = new Relationship.ajax(options['relationship2'][0]);
    };
  }
  static User? currentUser;
  String get getFullname => "$_firstName $_lastName";
  String get getLastName => _lastName ?? "";
  dynamic get getId => _id;
  dynamic get getAvatar => _avatar;
  dynamic get getCover => _cover;
  dynamic get getStory => _story;
  dynamic get getAddress => _address;
  dynamic get getCountFollowed => _countFollowed;
  dynamic get getRelationship => _relationship1 ?? _relationship2;
  set setRelationship (int userId){
    this._relationship1 = new Relationship.empty(userId);
  }

  set setCountFollowed (int count){
    this._countFollowed = count;
  }
set  updateTypeFriend (int typeFirend){
    if (_relationship2!= null) {
      _relationship2?.setTypeFriend = typeFirend;
    } else {
      switch (typeFirend) {
          case Relationship.noFriend:
            _relationship1?.setTypeFriend = Relationship.noFriend;
            break;
          case Relationship.friend:
            _relationship1?.setTypeFriend = Relationship.friend;
            break;
          case Relationship.requestFriend:
            _relationship1?.setTypeFriend = Relationship.requestFriended;
            break;
          case Relationship.requestFriended:
            _relationship1?.setTypeFriend = Relationship.requestFriend;
            break;
          case Relationship.prevent:
            _relationship1?.setTypeFriend = Relationship.prevented;
            break;
          case Relationship.prevented:
            _relationship1?.setTypeFriend = Relationship.prevent;
            break;
        }

    }
  }

  set  updateTypeFollow (int typeFollow){
    if (_relationship1!= null) {
      _relationship1?.setTypeFollow = typeFollow;
    } else {
      switch (typeFollow) {
          case Relationship.noFollow:
            _relationship1?.setTypeFriend = Relationship.noFollow;
            break;
          case Relationship.doubleFollow:
            _relationship1?.setTypeFriend = Relationship.doubleFollow;
            break;
          case Relationship.follow:
            _relationship1?.setTypeFriend = Relationship.followed;
            break;
          case Relationship.followed:
            _relationship1?.setTypeFriend = Relationship.follow;
            break;
        }
    }
  }
}