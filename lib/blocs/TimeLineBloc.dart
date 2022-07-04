import 'dart:convert';
import 'package:mxh/model/post.dart';

import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mxh/config.dart';
import 'dart:async';
import 'package:mxh/extension/http.dart' as httpMXH;
class TimeLineBloc {
  int? _groupId;
  int? _userId;
  TimeLineBloc() {
  }
  TimeLineBloc.groupId(int group_id) {
    this._groupId = group_id;
  }

  TimeLineBloc.userId(int userId) {
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
}
