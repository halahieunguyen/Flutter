import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mxh/blocs/UserBloc.dart';
import 'package:mxh/model/Relationship.dart';
import 'package:mxh/model/user.dart';
import 'package:mxh/extension/http.dart' as httpMXH;
import 'package:mxh/src/resources/dialog/MessageDialog.dart';
import '../dialog/flashMessage.dart';


class ItemListUser extends StatefulWidget {
  ItemListUser(User user,{Key? key}) : super(key: key) {
   this._user = user;
  }
  late User _user;
   @override
  State<ItemListUser> createState() => _ItemListUserState(_user);
}
class _ItemListUserState extends State<ItemListUser> {
  bool _ajaxLockBtnYes = false;
  bool _ajaxLockBtnNo = false;
  UserBloc _userBloc = new UserBloc();

   _ItemListUserState(User user) {
    this._user = user;
  }
  late User _user;
  @override
  void initState() {

  }
  int getTypeFriend () {
    Relationship relationship = _user.getRelationship;
    if (relationship != null) {
      if (relationship.getUserId1 != _user.getId) {
        return relationship.getTypeFriend;

      } else {
        switch (relationship.getTypeFriend) {
          case Relationship.noFriend:
            return Relationship.noFriend;
          case Relationship.friend:
            return Relationship.friend;
          case Relationship.requestFriend:
            return Relationship.requestFriended;
          case Relationship.requestFriended:
            return Relationship.requestFriend;
          case Relationship.prevent:
            return Relationship.prevented;
          case Relationship.prevented:
            return Relationship.prevent;
        }
      }
    }
    _user.setRelationship = _user.getId;
    return Relationship.noFriend;
  }
  @override
  Widget build(BuildContext context) {
    Widget getAvatar() {
      return (_user.getAvatar != null)
      ? Image.network(
        httpMXH.hostImg + _user.getAvatar,
        width: 96,
        height:96,
        fit:BoxFit.fill
      )
      : Image.asset('assets/images/nullAvatar.png',
      width: 96,
        height:96,
        fit:BoxFit.fill);
    }
    Widget textNo() {
      if (_ajaxLockBtnNo) {
        return SizedBox(
          width: 25, height: 25,
          child: CircularProgressIndicator(
            color: Colors.black,
            strokeWidth: 2.0,
          ),
        );
      } else {
        switch (getTypeFriend()) {
            case Relationship.noFriend:
              return Text(
                "Xóa",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  )
              );
            case Relationship.requestFriended:
              return Text(
                "Từ chối",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  )
              );
          }
      }
      return Text("");
    }
    Widget textYes() {
      if (_ajaxLockBtnYes) {
        return SizedBox(
          width: 25, height: 25,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.0,
          ),
        );
      } else {
        switch (getTypeFriend()) {
            case Relationship.noFriend:
              return Text(
                "Kết bạn",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  )
              );
            case Relationship.friend:
              return Text(
                "Hủy kết bạn",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  )
              );
            case Relationship.requestFriended:
              return Text(
                "Chấp nhận",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  )
              );
            case Relationship.requestFriend:
              return Text(
                "Huỷ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  )
              );
            case Relationship.prevent:
              return Text(
                "Bỏ chặn",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  )
              );
          }
      }
      return Text("");
    }
    Widget buttonNo() {
      return Container(
        child:RaisedButton(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          onPressed:()  => btnYesClick(),
          child: textNo()
        )
      );
    }
    Widget buttonYes() {
      return Container(
        child:RaisedButton(
          color: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          onPressed:()  => btnYesClick(),
          child: textYes()
        )
      );
    }
    return Card(
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        height: 100,
        child: InkWell(
          child:Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                child: getAvatar(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(_user.getFullname, overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                            buttonYes(),
                            Expanded(child:SizedBox.shrink() ),
                            (<int>[Relationship.requestFriended, Relationship.noFriend].contains(getTypeFriend()))
                            ?
                            buttonNo()
                            :SizedBox.shrink()

                          ],),
                    ],
                  ),
                ),
              ),
            ]
          ),
          onTap: () {

          }
        )
      ),
    );
  }

  Future<void> btnYesClick () async {
    String type = 'acceptFriend';
    bool confirm = true;
      int typeResult = Relationship.friend;
    switch (getTypeFriend()) {
        case Relationship.noFriend:
          type = 'requestFriend';
          typeResult = Relationship.requestFriend;
          break;
        case Relationship.friend:
          type = 'cancelFriend';
          typeResult = Relationship.noFriend;
            confirm =await MessageDialog.confirm(context, title: "Xác nhận", msg: "Bạn có muốn hủy kết bạn " + _user.getLastName + "?");
          break;
        case Relationship.requestFriend:
          type = 'cancelRequestFriend';
          typeResult = Relationship.noFriend;
          break;
        case Relationship.requestFriended:
          type = 'acceptFriend';
          typeResult = Relationship.friend;
          break;
        case Relationship.prevent:
          type = 'cancelPrevent';
          confirm =await MessageDialog.confirm(context, title: "Xác nhận", msg: "Bạn có muốn bỏ chặn " + _user.getLastName + "?");
          typeResult = Relationship.noFriend;
          break;
      }
      if (confirm)
      {
        setState(() {
          _ajaxLockBtnYes = true;
        });
        if (await  _userBloc.ajaxPostRelationship(_user.getId, type, (msg) {
          FlashMessage.showMessageTop(context, msg);
        }, (msg) {
              MessageDialog.showMessageDialog(context, 'Trang chủ', msg);
            })) {
            setState(() {
                  _user.updateTypeFriend = typeResult;

                  _ajaxLockBtnYes = false;
                });
            }
      }
  }
}

