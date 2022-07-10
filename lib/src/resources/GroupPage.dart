import 'package:flutter/material.dart';
import 'package:mxh/blocs/UserBloc.dart';
import 'package:mxh/model/user.dart';
import 'package:mxh/src/resources/dialog/MessageDialog.dart';
import 'package:mxh/src/resources/group/itemListGroup.dart';
import 'package:mxh/src/resources/group/pageListGroup.dart';
import 'package:mxh/src/resources/ui/paddingTop.dart';
import 'package:mxh/src/resources/user/PageListSuggestionsFriend.dart';
import 'package:mxh/src/resources/user/itemListUser.dart';
import 'package:mxh/src/resources/user/pageListFriend.dart';
import 'package:mxh/src/resources/user/pageListRequestFriended.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:mxh/src/resources/post/formPost.dart';

import '../../blocs/GroupBloc.dart';
import '../../model/group.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key}) : super(key: key);
  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage>  with AutomaticKeepAliveClientMixin<GroupPage> {
  GroupBloc _groupBloc = new GroupBloc();
  List<Group> _listGroupByUser = <Group>[];
  List<Group> _listGroupSuggestions= <Group>[];
  int loading = 0;
  @override
  void initState() {
    super.initState();
    ajaxLoadListGroup();
    ajaxLoadListSugget();
  }
  List<Map<String, dynamic>> optionFriends = [
    {
      'title' :'Tạo mới',
      'page' : PageListFriend()
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
     child: Container(
      color:Colors.white,
       child:
       (loading < 2) ?
       Center()
       :
       Column(
        children: [
          PaddingTop(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
               [
                  Container(
                    color:Colors.white,
                    child: Column(
                      children: [
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Nhóm',textAlign: TextAlign.left,style: TextStyle(fontSize: 24, fontWeight:FontWeight.bold,)),
                        )),
                        Row(
                          children: [
                            for (Map<String, dynamic> item in optionFriends)
                            Container(
                              margin: EdgeInsets.only(right: 5.0),
                              child: RaisedButton(
                                color: Color.fromARGB(184, 198, 203, 198),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(25))
                                ),
                                onPressed:() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => item['page']));
                                },
                                child: Text(item['title'].toString())
                              ),
                            ),
                          ]
                        ),
                      ]
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration:BoxDecoration(
                      border: Border(top:
                       BorderSide( //
                        color: Color.fromARGB(255, 179, 163, 163),
                        width: 0.5,
                      ))
                    ),
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text('Nhóm bạn tham gia',textAlign: TextAlign.left,style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold,)),
                  ),
                  Column(
                    children: [
                      for (Group group in _listGroupByUser) ItemListGroup(group),
                    ]
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      color: Color.fromARGB(184, 241, 243, 241),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      onPressed:() {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PageListGroup('get_list_group')));
                      },
                      child: Text("Xem tất cả")
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration:BoxDecoration(
                      border: Border(top:
                       BorderSide( //
                        color: Color.fromARGB(255, 179, 163, 163),
                        width: 0.5,
                      ))
                    ),
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text('Nhóm bạn có thể biết',textAlign: TextAlign.left,style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold,)),
                  ),
                  Column(
                    children: [
                      for (Group group in _listGroupSuggestions) ItemListGroup(group),
                    ]
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      color: Color.fromARGB(184, 241, 243, 241),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      onPressed:() {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PageListGroup('get_list_group_goi_y')));
                      },
                      child: Text("Xem tất cả")
                    ),
                  )
               ]
            ,),
          ),
        ],
    ),
     )
    );
  }
  @override
  bool get wantKeepAlive => true;
  Future<void> ajaxLoadListGroup() async {
       _listGroupByUser += await _groupBloc.ajaxGetList(1, () {}, (msg) {
            MessageDialog.showMessageDialog(context, 'Nhóm', msg);
          },
          type: "get_list_group",
        );
      setState(() {
        loading++;
        _listGroupByUser;
    },
    );
  }
  Future<void> ajaxLoadListSugget() async {
       _listGroupSuggestions += await _groupBloc.ajaxGetList(1, () {}, (msg) {
            MessageDialog.showMessageDialog(context, 'Nhóm', msg);
          },
          type: "get_list_group_goi_y",
        );
      setState(() {
        _listGroupSuggestions;
        loading++;
    },
    );
  }
}