import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mxh/blocs/GroupBloc.dart';
import 'package:mxh/model/Relationship.dart';
import 'package:mxh/model/group.dart';
import 'package:mxh/extension/http.dart' as httpMXH;
import 'package:mxh/src/resources/dialog/MessageDialog.dart';
import 'package:mxh/src/resources/group/Group.dart';
import '../../../model/group.dart';
import '../dialog/flashMessage.dart';


class ItemListGroup extends StatefulWidget {
  ItemListGroup(Group group,{Key? key}) : super(key: key) {
   this._group = group;
  }
  late Group _group;
   @override
  State<ItemListGroup> createState() => _ItemListGroupState(_group);
}
class _ItemListGroupState extends State<ItemListGroup> {
  bool _ajaxLockBtnYes = false;
  bool _ajaxLockBtnNo = false;
  GroupBloc _groupBloc = new GroupBloc();

   _ItemListGroupState(Group group) {
    this._group = group;
  }
  late Group _group;
  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    Widget getCover() {
      return (_group.getCover != "")
      ? Image.network(
        httpMXH.hostImg + _group.getCover,
        width: 96,
        height:96,
        fit:BoxFit.fill
      )
      : Image.asset('assets/images/nullAvatar.png',
      width: 96,
        height:96,
        fit:BoxFit.fill);
    }
    void gotoGroup(Group _group) {
      print(10000);
        Navigator.push(context, MaterialPageRoute(builder: (context) => GroupView(_group)));
    }
    return Card(
      child: InkWell(
        onTap:()  => gotoGroup(_group),
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: getCover(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(_group.getName, overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
                        Text("Ngày tạo: " + DateFormat('dd-MM-yyyy').format(_group.getCreatedAt), overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),),
                        Text("Giới thiệu: " + (_group.getIntro ?? ""), overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),),
                    ],
                  ),
                ),
              ),
            ]
          )
        ),
      ),
    );
  }

}

