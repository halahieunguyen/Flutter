import 'package:intl/intl.dart';
import 'package:mxh/model/user.dart';
import 'dart:convert';

class Member {
  late int _id;
  late int _groupId;
  late int _userId;
  late int _status;
  late int _role;
  late DateTime _createdAt;


  Member (
    int id,
    int groupId,
    int userId,
    int status,
    int role,
    DateTime createdAt,

  ) {
    _id = id;
    _groupId = groupId;
    _userId = userId;
    _status = status;
    _role = role;
    _createdAt = createdAt;
  }
   Member.ajax (
   Map<String, dynamic> options
  ) {
    if(options['id']!=null) {
      this._id = options['id'];
    };
    if(options['groupId']!=null) {
      this._groupId = options['groupId'];
    };
    if(options['userId']!=null) {
      this._userId = options['userId'];
    };
    if(options['status']!=null) {
      this._status = options['status'];
    };
    if(options['role']!=null) {
      this._role = options['role'];
    };
    if(options['created_at']!=null) {

      this._createdAt = DateTime.parse(options['created_at']);
    };

  }
int get getId => _id;
int get getGroupId => _groupId;
int get getUserId => _userId;
int get getStatus => _status;
int get getRole => _role;
DateTime get getCreatedAt => _createdAt;

}