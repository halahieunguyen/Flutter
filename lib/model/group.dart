import 'package:intl/intl.dart';
import 'package:mxh/model/user.dart';
import 'dart:convert';

class Group {
  late int _id;
  String? _intro;
  late String _name;
  String? _cover;
  String? _regulations;
  int _type = 1;
  int _browsePost = 1;
  late DateTime _createdAt;

  static const browsePostYes = 1;
  static const browsePostNo = 0;
  static const typePublic = 1;
  static const typePrivate = 2;

  Group (
    int id,
    String? intro,
    String name,
    String? cover,
    String? regulations,
    int type,
    int browsePost,
    DateTime createdAt

  ) {
    _id = id;
    _intro = intro;
    _name = name;
    _cover = cover;
    _regulations = regulations;
    _type = type;
    _browsePost = browsePost;
    _createdAt = createdAt;
  }
  Group.ajax (
   Map<String, dynamic> options
  ) {
    if(options['id']!=null) {
      this._id = options['id'];
    };
    if(options['intro']!=null) {
      this._intro = options['intro'];
    };
    if(options['name']!=null) {
      this._name = options['name'];
    };
    if(options['type']!=null) {
      this._type = options['type'];
    };
    if(options['browse_post']!=null) {
      this._browsePost = options['browse_post'];
    };
    if(options['regulations']!=null) {
      this._regulations = options['regulations'];
    };
    if(options['created_at']!=null) {

      this._createdAt = DateTime.parse(options['created_at']);
    };

    if(options['cover']!=null) {
        this._cover = options['cover'];
    };
  }


int get getId => _id;
String? get getIntro => _intro;
String get getName => _name;
String get getCover => _cover ?? "";
String? get getRegulations => _regulations;
int get getType => _type;
int get getBrowsePost => _browsePost;
DateTime get getCreatedAt => _createdAt;

}