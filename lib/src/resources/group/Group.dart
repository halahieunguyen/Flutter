import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:mxh/src/resources/dialog/MessageDialog.dart';
import 'package:mxh/src/resources/post/post.dart';
import 'package:mxh/src/resources/ui/paddingTop.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:mxh/src/resources/post/formPost.dart';

import '../../../blocs/GroupBloc.dart';
import '../../../blocs/PostBloc.dart';
import 'package:mxh/extension/http.dart' as httpMXH;
import '../../../model/group.dart';
import '../../../model/member.dart';
import '../../../model/post.dart';
import '../dialog/LoadingDialog.dart';


class GroupView extends StatefulWidget {
  GroupView(Group group, {Key? key}) : super(key: key) {
    _group = group;
  }
  late Group _group;
  @override
  State<GroupView> createState() => _GroupViewState(_group);
}

class _GroupViewState extends State<GroupView>  with AutomaticKeepAliveClientMixin<GroupView> {
  _GroupViewState(Group group) {
    _group = group;
  }
  late Group _group;
  Member? _member;

  final key = GlobalKey<AnimatedListState>();
  int _page = 1;
  bool loadingPage = false;
  late PostBloc _postBloc;
  late GroupBloc _groupBloc;
  List<Post> _listPost = <Post>[];
  @override
  void initState() {
    _postBloc = new PostBloc.groupId(_group.getId);
    _groupBloc = new GroupBloc();
    getMember();
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

  Widget GroupButtonComponent() {
    switch (_member?.getStatus) {
      case 1:
        return Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              RaisedButton(
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                onPressed: () {},
                child: Text(
                  "Rời nhóm",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    )
                )
              ),
            ],
          )
        );
        // break;
      case 2:
        return Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              RaisedButton(
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                onPressed: () {},
                child: Text(
                  "Hủy yêu cầu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    )
                )
              ),
            ],
          )
        );
      default:
        return Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              RaisedButton(
                color: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                onPressed: () {},
                child: Text(
                  "Tham gia",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    )
                )
              ),
            ],
          )
        );
    }

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body:  LazyLoadScrollView(
      onEndOfPage: () => {
        setState(() {
          ajaxLoadListPost();
        })
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
              PaddingTop(),
              Stack(
                children: [
                  Image.network(
                    httpMXH.hostImg + _group.getCover,
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    fit:BoxFit.fill
                  ),
                  Positioned.fill(
                    top: -160,
                    child:
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, size: 35, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop(this);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_group.getName, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    Text(_group.getIntro ?? "", overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12)),
                  ],
                ),
              ),
              GroupButtonComponent(),
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
      ),
      )
    );

  }
  Future<void> getMember() async {
    _member = await _groupBloc.getMember(_group.getId,
      () {},
      (msg) {
        MessageDialog.showMessageDialog(context, 'Bạn bè', msg);
      });
    setState(() {
      _member;
      });

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