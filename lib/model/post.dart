import 'package:intl/intl.dart';
import 'package:mxh/model/user.dart';
import 'package:mxh/model/like.dart';
import 'dart:convert';
import 'comment.dart';

class Post {
  static const typeShow = {
    'public': 1,
    'friend': 2,
    'private': 3,
    'specific_friend': 4,
    'friends_except': 5,
  };

  late int _id;
  late User _user;
  User? _user2;
  Like? _isLike;
  List<Comment> _comments = <Comment>[];
  int? _groupId;
  int? _postId;
  int? _typePost;
  int? _typeShow;
  DateTime? _createdAt;
  DateTime? _updatedAt;
  String? _data;
  int _likeCount = 0;
  int _shareCount = 0;
  int _commentCount = 0;
  List<String> _srcImages = <String>[];
  bool stillComment = true;
  Post (
    int id,
    User user,
    int typePost,
    int typeShow,
    DateTime createdAt,
    DateTime updatedAt,
    int shareCount,
    int commentCount,
    String? data,
    List<String> srcImages,
    int likeCount,
    int userIdBrowse,
    {
      int? postId,
      Like? isLike,
      int? groupId,
      User? user2,
    }
  ) {
    this._id = id;
    this._user = user;
    this._typePost = typePost;
    this._typeShow = typeShow;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._likeCount = likeCount;
    this._shareCount = shareCount;
    this._commentCount = commentCount;
    this._data = data;

    this._srcImages = srcImages;
    if (isLike != null) {
      this._isLike = isLike;
    }
    if (user2 != null) {
      this._user2 = user2;
    }
    if (groupId != null) {
      this._groupId = groupId;
    }
    if (postId != null) {
         this._postId = postId;
    }
    if (user2 != null) {
      this._user2 = user2;
    }

  }
  Post.ajax (
   Map<String, dynamic> options
  ) {
    if(options['id']!=null) {
      this._id = options['id'];
    };
    if(options['user_id'] != null) {
      this._user = new User.ajaxOptimize(options['user']);
    };
    if(options['user_id_2'] !=null) {
      this._user2 = new User.ajaxOptimize(options['user_2']);
    };
    if(options['group_id']!=null) {
      this._groupId = options['group_id'];
    };
    if(options['post_id']!=null) {
      this._postId = options['post_id'];
    };
    if(options['type_post']!=null) {
      this._typePost = options['type_post'];
    };
    if(options['type_show']!=null) {
      this._typeShow = options['type_show'];
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
    if(options['like_count']!=null) {
      this._likeCount = options['like_count'];
    };
    if(options['share_count']!=null) {
      this._shareCount = options['share_count'];
    };
    if(options['comment_count']!=null) {
      this._commentCount = options['comment_count'];
    };

    if(options['is_like']!=[] && options['is_like'].length >0) {
      this._isLike = new Like.ajax(options['is_like'][0]);
    };
    if(options['src_images']!=null) {
      var decode = jsonDecode(options['src_images']);
      if (decode != "") {
        this._srcImages = List.from(jsonDecode(options['src_images']));
      }
    };

  }


int get getId => _id;
User get getUser => _user;
User? get getUser2 => _user2;
int? get getGroupId => _groupId;
int? get getPostId => _postId;
int? get getTypePost => _typePost;
int? get getTypeShow => _typeShow;
DateTime? get getCreatedAt => _createdAt;
DateTime? get getUpdatedAt => _updatedAt;
String get getData => _data ?? "";
int get getCountLike => _likeCount;
int get getCountComment => _commentCount;
int get getCountShare => _shareCount;
Like? get getIsLike => _isLike;
List<String> get getSrcImages => _srcImages;
set setId (int x) {
  _id = x;
}
List<Comment> get getComments => _comments;
void pushComments(List<Comment>? comments) {
  if (comments != null)
  _comments += comments;
  if (_comments.length % 5 != 2) {
    stillComment = false;
  }
}

void createComment(Comment comment) {
  _comments = [comment] + _comments;
}


set setIsLike(String type) {
  if (_isLike!= null &&_isLike?.getType != 0) {
    this._likeCount--;
  }
   if (type != "0") {
    this._likeCount++;
  }
  if (_isLike == null) {
    int idFake = 0;
    _isLike = new Like(idFake, int.parse(type), _user.getId, _id);
  } else
    _isLike?.setTypeString = type;
  }
}