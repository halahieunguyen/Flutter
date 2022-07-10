import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
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
        for (var item in data['data']) {
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

  Future<Post?> createPost({int? groupId,int? postId, int? userId2, int? typeShow, List<XFile>? images, String data = "", Function? onSuccess, Function(String)? onError}) async {
    Post? result;
    if (typeShow == null) typeShow = Post.typeShow['public'];
    List<String> linkImages = <String>[];
    if (images != null) {
      var responseImg;
      File? img;
      Map dataImg;
      for (XFile image in images) {
        img = File(image!.path);
        responseImg = await httpMXH.postImg('image/upload',  img);
        if (responseImg.statusCode == 200) {
          dataImg = json.decode(await responseImg.stream.bytesToString());
          if (dataImg["status"] == 'success')
          linkImages.add(dataImg['data']);
        } else {
          onError!("Upload ảnh thất bại.");
          return result;
        }
      }
    }
    Map<String, dynamic> options = {
      'data': data,
      'type_show': typeShow.toString(),
      // 'user_view_posts': json.encode([]),
      'images' : json.encode(linkImages)
    };
    if (groupId != null) {
      options['group_id'] = groupId.toString();
    }
    if (postId != null) {
      options['post_id'] = postId.toString();
    }
    if (userId2 != null) {
      options['user_id_2'] = userId2.toString();
    }
    var response = await httpMXH.post('post/create', options);

    if (response.ok) {
      var data = json.decode(response.body);
      if (data['status'] == 'success') {
       onSuccess!(data['message']);
       result = new Post.ajax(data['data']);
      } else {
        onError!(data['message']);
      }
    } else {
      onError!("Đã có lỗi xảy ra, vui lòng thử lại");
    }
    return result;
  }

  Future<Comment?> createComment({int? postId, int? commentId, List<XFile>? images, String data = "", Function? onSuccess, Function(String)? onError}) async {
    Comment? result;
    List<String> linkImages = <String>[];
    if (images != null) {
      var responseImg;
      File? img;
      Map dataImg;
      for (XFile image in images) {
        img = File(image!.path);
        responseImg = await httpMXH.postImg('image/upload',  img);
        if (responseImg.statusCode == 200) {
          dataImg = json.decode(await responseImg.stream.bytesToString());
          if (dataImg["status"] == 'success')
          linkImages.add(dataImg['data']);
        } else {
          onError!("Upload ảnh thất bại.");
          return result;
        }
      }
    }
    Map<String, dynamic> options = {
      'data': data,
      'images' : json.encode(linkImages)
    };
    if (commentId != null) {
      options['comment_id'] = commentId.toString();
    }
    if (postId != null) {
      options['post_id'] = postId.toString();
    }
    var response = await httpMXH.post('comment/create', options);

    if (response.ok) {
      var data = json.decode(response.body);
      if (data['status'] == 'success') {
       onSuccess!(data['message']);
       result = new Comment.ajax(data['data']);
      } else {
        onError!(data['message']);
      }
    } else {
      onError!("Đã có lỗi xảy ra, vui lòng thử lại");
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
      onSuccess();
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
