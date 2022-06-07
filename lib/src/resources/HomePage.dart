import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:mxh/src/resources/post/formPost.dart';
import 'package:mxh/src/resources/post/timeline.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  with AutomaticKeepAliveClientMixin<HomePage> {
  ViewFormPost _X =new ViewFormPost();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
    child: Column(children:
       [
          ViewFormPost(),
          ViewTimeLine()
       ]
    ,)
    );
  }
  @override
  bool get wantKeepAlive => true;
}