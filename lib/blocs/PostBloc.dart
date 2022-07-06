import 'dart:convert';
import 'package:mxh/model/post.dart';

import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mxh/config.dart';
import 'dart:async';
import 'package:mxh/extension/http.dart' as httpMXH;

import '../model/comment.dart';
class PostBloc {
  int? _groupId;
  int? _userId;
  PostBloc() {
  }
  PostBloc.groupId(int group_id) {
    this._groupId = group_id;
  }

  PostBloc.userId(int userId) {
    this._userId = userId;
  }


  StreamController _page = new StreamController();
  void dispose() {
    _page.close();
  }
  Stream get emailStream => _page.stream;


  Future<List<Post>> ajaxLoadListPost(int page,Function onSuccess, Function(String) onError, {int? userId,}) async {
    List<Post> listPost = <Post>[];
    Map<String, dynamic> options = {
      'page': page.toString()
    };
    if (userId != null) {
      options['user_id'] = userId.toString();
    }
    if (_groupId != null) {
      options['group_id'] = _groupId.toString();
    }
     if (_userId != null) {
      options['user_id'] = _userId.toString();
    }
    var response = await httpMXH.get('post/get_list', options);
    if (response.ok) {
      var data = json.decode(response.body);
      if (data['status'] == 'success') {
        print(data['data'].length);
        for (var item in data['data']) {
          print(item);
            listPost.add(new Post.ajax(item));
        }
      } else {
          if (data['errors'].containsKey('group_id'))  onError(data['errors']['group_id'][0]);
          if (data['errors'].containsKey('user_id'))  onError(data['errors']['user_id'][0]);

      }
    } else {
      onError("Đã có lỗi xảy ra, vui lòng thử lại");
    }
    return listPost;
  }

  Future<bool> likePost(int postId, String type,Function onSuccess, Function(String) onError) async {
    Map<String, dynamic> options = {
      'post_id': postId.toString(),
      'type': type
    };
    bool result = false;
    var response = await httpMXH.post('like', options);
    if (response.ok) {
      var data = json.decode(response.body);
      print(data);
      if (data['status'] == 'success') {
       result = true;
      } else {
        onError("Bài viết không tồn tại.");
      }
    } else {
      onError("Đã có lỗi xảy ra, vui lòng thử lại");
    }
    return result;
  }

  Future<List<Comment>?> loadComment(int page, Function onSuccess, Function(String) onError, {int? postId, String? commentId}) async {
    List<Comment> listComment = <Comment>[];
    Map<String, dynamic> options = {
      'page': page.toString(),
    };
    if (commentId != null) {
      options['comment_id'] = commentId.toString();
    }

    if (postId != null) {
      options['post_id'] = postId.toString();
    }
    bool result = false;
    var response = await httpMXH.get('comment/get', options);
    if (response.ok) {
      var data = json.decode(response.body);
      print("----------------------------------------------------------------------");
      print(data);
      print(options);
      if (data['status'] == 'success') {
       for (var item in data['data']) {
            listComment.add(new Comment.ajax(item));
        }
      } else {
        onError("Bài viết không tồn tại.");
        return null;
      }
    } else {
      onError("Đã có lỗi xảy ra, vui lòng thử lại");
      return null;
    }
    return listComment;
  }
}
