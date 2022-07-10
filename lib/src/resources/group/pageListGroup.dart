import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mxh/blocs/GroupBloc.dart';
import 'package:mxh/model/Relationship.dart';
import 'package:mxh/model/group.dart';
import 'package:mxh/extension/http.dart' as httpMXH;
import 'package:mxh/src/resources/dialog/MessageDialog.dart';
import 'package:mxh/src/resources/group/itemListGroup.dart';
import '../dialog/flashMessage.dart';
import '../ui/paddingTop.dart';


class PageListGroup extends StatefulWidget {
  PageListGroup(String type,{Key? key}) : super(key: key) {
    _type = type;
  }
  String _type = "";
   @override
  State<PageListGroup> createState() => _PageListGroupState(_type);
}
class _PageListGroupState extends State<PageListGroup> {
  _PageListGroupState(String type) {
    _type = type;
  }
  String _type = "";
  GroupBloc _groupBloc = new GroupBloc();
  List<Group> _listGroup = <Group>[];

  int _page = 1;
  late Group _group;
  @override
  void initState() {
    super.initState();
    ajaxLoadListGroup(_page);
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
                          for (Group groupItem in _listGroup) ItemListGroup(groupItem),
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
  Future<void> ajaxLoadListGroup(int page) async {
       _listGroup += await _groupBloc.ajaxGetList(page, () {}, (msg) {
            MessageDialog.showMessageDialog(context, 'Nhóm', msg);
          },
          type: _type,
        );
      setState(() {
        _listGroup;
    },
    );
  }
}

