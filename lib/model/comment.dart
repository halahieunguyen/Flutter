import 'package:intl/intl.dart';
import 'package:mxh/model/user.dart';
import 'dart:convert';

class Comment {
  late int _id;
  late User _user;
  late int _postId;
  int? _commentId;
  late String _data;
  String? _srcImage;
  List<Comment> _comments = <Comment>[];
  bool stillComment = true;

  DateTime? _createdAt;
  late DateTime _updatedAt;
  Comment (
  int id,
  User user,
  String data,
  int postId,

  ) {
    this._postId = postId;
    this._id = id;
    this._user = user;
    this._data = data;

  }
  Comment.ajax (
   Map<String, dynamic> options
  ) {
    if(options['id']!=null) {
      this._id = options['id'];
    };
    if(options['user_id'] != null) {
      this._user = new User.ajaxOptimize(options['user']);
    };

    if(options['post_id']!=null) {
      if (options['post_id'].runtimeType == String)
      this._postId = int.parse(options['post_id']);
      else
      this._postId = options['post_id'];
    };

    if(options['comment_id']!=null) {
      this._commentId = options['comment_id'];
    };
    if(options['created_at']!=null) {

      this._createdAt = DateTime.parse(options['created_at']);
    };
    if(options['updated_at']!=null) {
      this._updatedAt = DateTime.parse(options['updated_at']);
    };
    if(options['data']!=null) {
      this._data = options['data'];
    };
    if(options['src_images']!=null) {
     var decode = jsonDecode(options['src_images']);
      if (decode != "") {
        this._srcImage = List.from(jsonDecode(options['src_images']))[0] ?? null;
        print(this._srcImage);
      }
    };
  }


int get getId => _id;
User get getUser => _user;
int? get getPostId => _postId;
DateTime? get getCreatedAt => _createdAt;
DateTime get getUpdatedAt => _updatedAt;
String get getData => _data;
String? get getImage => _srcImage;
}