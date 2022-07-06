import 'package:flutter/material.dart';
import 'package:flutter_reactive_button/flutter_reactive_button.dart';
import 'package:mxh/model/post.dart';
import 'package:mxh/model/like.dart';
import 'package:mxh/src/resources/user/viewUserOptimize.dart';
import 'package:intl/intl.dart';

import '../../../blocs/PostBloc.dart';
import '../../../model/comment.dart';
import '../dialog/MessageDialog.dart';
import '../ui/paddingTop.dart';
class ViewComment extends StatefulWidget {
  ViewComment(Post post,{Key? key}) : super(key: key) {
   this._post = post;
  }
  late Post _post;
  @override
  State<ViewComment> createState() => View_CommentState(_post);
}

class View_CommentState extends State<ViewComment> {
  View_CommentState(Post post) {
     this._post = post;
  }
  PostBloc _postBloc = new PostBloc();
  int _page = 1;
  late Post _post;
  @override
  void initState() {
    super.initState();
    ajaxLoadComments();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body:SingleChildScrollView(
          child: Container(
            color:Colors.white,
            child: Column(
              children: [
                PaddingTop(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop(this);
                    },
                  ),
                ),
                for (Comment comment in _post.getComments) Text(comment.getData),
              ],
            ),
          )
        )
      )
    );
  }

  Future<void> ajaxLoadComments() async {
    _post.pushComments(await _postBloc.loadComment(_page, () {
      _page++;
    }, (msg) {
              MessageDialog.showMessageDialog(context, 'Bài viết', msg);
            },
          )
      , commentId: _post.getId
    );
  }
}