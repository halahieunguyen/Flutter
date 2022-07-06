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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  with AutomaticKeepAliveClientMixin<HomePage> {
  int _page = 1;
  bool loadingPage = false;
  PostBloc _postBloc = new PostBloc();
  List<Post> _listPost = <Post>[];
  @override
  void initState() {
    ajaxLoadListPost(1);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return LazyLoadScrollView(
      onEndOfPage: () => {
        setState(() {
          loadingPage = true;
          _page++;
          ajaxLoadListPost(_page);
        })
      },
      child: SingleChildScrollView(
      child: Column(children:
         [
            PaddingTop(),
            ViewFormPost(),
            Column(
            mainAxisAlignment: MainAxisAlignment.start,
              children : [
                for (Post postItem in _listPost) ViewPost(postItem),
              ]
            ),
            if (loadingPage)  SizedBox(
              width: 50, height: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 203, 205, 214),
                  strokeWidth: 2.0,
                ),
              ),
            ),
         ]
      ,)
      ),
    );
  }
   Future<void> ajaxLoadListPost(int page) async {
       _listPost += await _postBloc.ajaxLoadListPost(page, () {}, (msg) {
          MessageDialog.showMessageDialog(context, 'Trang chủ', msg);
        });
      setState(() {
        _listPost;
        loadingPage= false;
    });
  }
  @override
  bool get wantKeepAlive => true;
}