import 'package:flutter/material.dart';
import 'package:mxh/blocs/UserBloc.dart';
import 'package:mxh/model/user.dart';
import 'package:mxh/src/resources/dialog/MessageDialog.dart';
import 'package:mxh/src/resources/ui/paddingTop.dart';
import 'package:mxh/src/resources/user/PageListSuggestionsFriend.dart';
import 'package:mxh/src/resources/user/itemListUser.dart';
import 'package:mxh/src/resources/user/pageListFriend.dart';
import 'package:mxh/src/resources/user/pageListRequestFriended.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:mxh/src/resources/post/formPost.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({Key? key}) : super(key: key);
  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage>  with AutomaticKeepAliveClientMixin<FriendPage> {
  UserBloc _userBloc = new UserBloc();
  List<User> _listUserRequested = <User>[];
  List<User> _listFriendSuggestions= <User>[];
  int loading = 0;
  @override
  void initState() {
    super.initState();
    ajaxLoadListRequestFriended();
    ajaxLoadListSugget();
  }
  List<Map<String, dynamic>> optionFriends = [
    {
      'title' :'Bạn bè',
      'page' : PageListFriend()
    },
    {
      'title' :'Gợi ý',
      'page' : PageListSuggestionsFriend()
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
                          child: Text('Bạn bè',textAlign: TextAlign.left,style: TextStyle(fontSize: 24, fontWeight:FontWeight.bold,)),
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
                    child: Text('Lời mời kết bạn',textAlign: TextAlign.left,style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold,)),
                  ),
                  Column(
                    children: [
                      for (User userItem in _listUserRequested) ItemListUser(userItem),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PageListRequestFriended()));
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
                    child: Text('Những người bạn có thể biết',textAlign: TextAlign.left,style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold,)),
                  ),
                  Column(
                    children: [
                      for (User userItem in _listFriendSuggestions) ItemListUser(userItem),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PageListSuggestionsFriend()));
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
  Future<void> ajaxLoadListRequestFriended() async {
       _listUserRequested += await _userBloc.ajaxGetList(1, () {}, (msg) {
            MessageDialog.showMessageDialog(context, 'Bạn bè', msg);
          },
          type: "listRequestFriended",
        );
      setState(() {
        loading++;
        _listUserRequested;
    },
    );
  }
  Future<void> ajaxLoadListSugget() async {
       _listFriendSuggestions += await _userBloc.ajaxGetList(1, () {}, (msg) {
            MessageDialog.showMessageDialog(context, 'Bạn bè', msg);
          },
          type: "listFriendSuggestions",
        );
      setState(() {
        _listFriendSuggestions;
        loading++;
    },
    );
  }
}