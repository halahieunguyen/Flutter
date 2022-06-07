import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({Key? key}) : super(key: key);

  @override
  State<FriendPage> createState() => _FriendPageState();
}
class _FriendPageState extends State<FriendPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Friend Page")
    );
  }
}