import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mxh/model/post.dart';

class ViewFormPost extends StatefulWidget {
  @override
  State<ViewFormPost> createState() => _ViewFormPostState();
}

class _ViewFormPostState extends State<ViewFormPost> {
  @override
  void initState() {

  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
    child: Column(children: [
      Text('Form đang bài')
    ],)
    );
  }
}