import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:mxh/src/resources/dialog/MessageDialog.dart';
import 'package:mxh/src/resources/post/post.dart';
import 'package:mxh/src/resources/ui/paddingTop.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:mxh/src/resources/post/formPost.dart';

import '../../blocs/PostBloc.dart';
import '../../model/post.dart';
import 'dialog/LoadingDialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  with AutomaticKeepAliveClientMixin<HomePage> {
  final key = GlobalKey<AnimatedListState>();
  int _page = 1;
  bool loadingPage = false;
  PostBloc _postBloc = new PostBloc();
  List<Post> _listPost = <Post>[];
  @override
  void initState() {
    ajaxLoadListPost();
    super.initState();
  }

  void pushNewPost(Post post) {
      List<Post> _listPost1;
      _listPost1 = _listPost;

      setState(() {
      _listPost = <Post>[];
      });
      new Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          _listPost = [post] + _listPost1;
        });
      });

    }

  @override
  Widget build(BuildContext context) {
    return LazyLoadScrollView(
      onEndOfPage: () => {
        setState(() {
          ajaxLoadListPost();
        })
      },
      child: SingleChildScrollView(
      child: Column(children:
         [
            PaddingTop(),
            ViewFormPost(pushNewPostCallBack: (Post post) => pushNewPost(post)),
            Column(
            mainAxisAlignment: MainAxisAlignment.start,
              children : [
                for (Post postItem in _listPost) ViewPost(postItem),
              ]
            ),
            if (loadingPage) LoadingDialog.ajaxLoadListView(),
         ]
      ,)
      ),
    );
  }
   Future<void> ajaxLoadListPost() async {
      if (loadingPage) return;
      loadingPage = true;
       _listPost += await _postBloc.ajaxLoadListPost(_page, () {}, (msg) {
          MessageDialog.showMessageDialog(context, 'Trang chủ', msg);
        });
      setState(() {
        _listPost;
        _page++;
        loadingPage= false;
    });
  }
  @override
  bool get wantKeepAlive => true;
}