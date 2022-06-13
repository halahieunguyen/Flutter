import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mxh/blocs/UserBloc.dart';
import 'package:mxh/model/Relationship.dart';
import 'package:mxh/model/user.dart';
import 'package:mxh/extension/http.dart' as httpMXH;
import 'package:mxh/src/resources/dialog/MessageDialog.dart';
import 'package:mxh/src/resources/user/itemListUser.dart';
import '../dialog/flashMessage.dart';
import '../ui/paddingTop.dart';


class PageListSuggestionsFriend extends StatefulWidget {
  PageListSuggestionsFriend({Key? key}) : super(key: key) {
  }
   @override
  State<PageListSuggestionsFriend> createState() => _PageListSuggestionsFriendState();
}
class _PageListSuggestionsFriendState extends State<PageListSuggestionsFriend> {
  UserBloc _userBloc = new UserBloc();
  List<User> _listUser = <User>[];
  _PageListSuggestionsFriendState() {
  }
  int _page = 1;
  late User _user;
  @override
  void initState() {
    super.initState();
    ajaxLoadlistFriendSuggestions(_page);
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
                          for (User userItem in _listUser) ItemListUser(userItem),
                        ]
                      )
                    ),
                  ],
              ),
            )]
          )
        )
        )
      )
      );
  }
  Future<void> ajaxLoadlistFriendSuggestions(int page) async {
       _listUser += await _userBloc.ajaxGetList(page, () {}, (msg) {
            MessageDialog.showMessageDialog(context, 'Bạn bè', msg);
          },
          type: "listFriendSuggestions",
        );
      setState(() {
        _listUser;
    },
    );
  }
}

