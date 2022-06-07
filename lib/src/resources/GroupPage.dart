import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}
class _GroupPageState extends State<GroupPage>  with AutomaticKeepAliveClientMixin<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Group Page")
    );
  }
   @override
  bool get wantKeepAlive => true;
}