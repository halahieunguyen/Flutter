import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mxh/src/resources/post/post.dart';
import 'package:mxh/blocs/TimeLineBloc.dart';
import 'package:mxh/src/resources/dialog/MessageDialog.dart';
import 'package:mxh/model/post.dart';

class ViewTimeLine extends StatefulWidget {
  ViewTimeLine({Key? key}) : super(key: key);
  @override
  State<ViewTimeLine> createState() => _ViewTimeLineState();
}

class _ViewTimeLineState extends State<ViewTimeLine> {
  // List<ViewPost> _listViewPost = <ViewPost>[];
  List<Post> _listPost = <Post>[];
  TimeLineBloc _timeLineBloc = new TimeLineBloc();

  @override
  void initState() {
    super.initState();
    ajaxLoadListPost(1);
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
    child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
               children : [
                 for (Post postItem in _listPost) ViewPost(postItem),
               ]
              ),

    );
  }
   Future<void> ajaxLoadListPost(int page) async {
       _listPost += await _timeLineBloc.ajaxLoadListPost(page, () {}, (msg) {
          MessageDialog.showMessageDialog(context, 'Trang chủ', msg);
        });
      setState(() {
        _listPost;
    });
  }
}