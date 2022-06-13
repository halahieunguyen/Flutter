import 'dart:convert';
import 'package:mxh/model/user.dart';

import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mxh/config.dart';
import 'dart:async';
import 'package:mxh/extension/http.dart' as httpMXH;
class UserBloc {
  UserBloc() {
  }
  // StreamController _page = new StreamController();
  void dispose() {
    // _page.close();
  }
  // Stream get emailStream => _page.stream;


  Future<List<User>> ajaxGetList(int page,Function onSuccess, Function(String) onError, {int? userId, String? type}) async {
    List<User> listUser = <User>[];
    Map<String, dynamic> options = {
      'page': page.toString()
    };
    if (userId != null) {
      options['user_id'] = userId.toString();
    }
    String url = "relationship/list_friend";
    if (type != null) {
      switch (type) {
        case 'listRequestFriended':
          url = "relationship/list_request_friended";
          break;
        case 'listFriend':
          url = "relationship/list_friend";
          break;
        case 'listFriendSuggestions':
          url = "relationship/list_friend_suggestions";
          break;

      }
    }
    var response = await httpMXH.get(url, options);
    if (response.ok) {
      var data = json.decode(response.body);
      if (data['status'] == 'success') {
        print(data['data'].length);
        for (var item in data['data']) {
          print(item);
            listUser.add(new User.ajaxOptimize(item));
        }
      } else {
          if (data['errors'].containsKey('user_id'))  onError(data['errors']['user_id'][0]);

      }
    } else {
      onError("Đã có lỗi xảy ra, vui lòng thử lại");
    }
    return listUser;
  }

  Future<bool> ajaxPostRelationship( int userId, String type,Function onSuccess, Function(String) onError) async {
    List<User> listUser = <User>[];
    Map<String, dynamic> options = {
      'user_id': userId.toString(),
    };
    String url = "relationship/request_friend";
    switch (type) {
      case 'requestFriend':
        url = "relationship/request_friend";
        break;
      case 'cancelRequestFriend':
        url = "relationship/cancel_request_friend";
        break;
      case 'acceptFriend':
        url = "relationship/accept_friend";
        break;
      case 'cancelFriend':
        url = "relationship/cancel_friend";
        break;
      case 'follow':
        url = "relationship/follow";
        break;
      case 'cancelFollow':
        url = "relationship/cancel_follow";
        break;
      case 'prevent':
        url = "relationship/prevent";
        break;
      case 'cancelPrevent':
        url = "relationship/cancel_prevent";
        break;
    }
    var response = await httpMXH.post(url, options);
    if (response.ok) {
      var data = json.decode(response.body);
      if (data['status'] == 'success') {
        if(data.containsKey('message')) {
          onSuccess(data['message']);
        }
        return true;
      } else {
          if(data.containsKey('errors')) {
            if (data['errors'].containsKey('user_id'))  onError(data['errors']['user_id'][0]) ;
          } else if (data.containsKey('message'))  onError(data['message']) ;


      }
    } else {
      onError("Đã có lỗi xảy ra, vui lòng thử lại");
    }
    return false;
  }
}
