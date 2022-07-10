import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mxh/model/post.dart';

import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mxh/config.dart';
import 'dart:async';
import 'package:mxh/extension/http.dart' as httpMXH;

import '../model/comment.dart';
import '../model/group.dart';
import '../model/member.dart';
class GroupBloc {
  GroupBloc() {
  }

  Future<List<Group>> ajaxGetList(int page,Function onSuccess, Function(String) onError, {String? type}) async {
    List<Group> listGroup = <Group>[];
    Map<String, dynamic> options = {
      'page': page.toString()
    };
    String url = "group/get_list_group";
    if (type != null) {
      url = 'group/' + type;
    }
    var response = await httpMXH.get(url, options);
    if (response.ok) {
      var data = json.decode(response.body);
      if (data['status'] == 'success') {
        print(data['group'].length);
        for (var item in data['group']) {
          print(item);
            listGroup.add(new Group.ajax(item));
        }
      } else {
          if (data['errors'].containsKey('user_id'))  onError(data['errors']['user_id'][0]);

      }
    } else {
      onError("Đã có lỗi xảy ra, vui lòng thử lại");
    }
    return listGroup;
  }

  Future<Member?> getMember(int groupId,Function onSuccess, Function(String) onError) async {
    Member? member = null;
    Map<String, dynamic> options = {
      'group_id': groupId.toString()
    };
    String url = "member";

    var response = await httpMXH.get(url, options);
    if (response.ok) {
      var data = json.decode(response.body);
      if (data['status'] == 'success') {
          member = new Member.ajax(data['member']);
      } else {
        onError(data['message']);

      }
    } else {
      onError("Đã có lỗi xảy ra, vui lòng thử lại");
    }
    return member;
  }
}
