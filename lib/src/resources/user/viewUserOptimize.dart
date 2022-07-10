import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mxh/model/user.dart';
import 'package:mxh/extension/http.dart' as httpMXH;

class ViewUserOptimize extends StatelessWidget {
   ViewUserOptimize(User user,{ Key? key, DateTime? time}) : super(key: key) {
    this._user = user;
    if (time != null) {
      this._dateTime = time;
    }
  }
  late User _user;
  late DateTime _dateTime;
  @override
  Widget build(BuildContext context) {
    Widget getAvatar() {
      return (_user.getAvatar != null)
      ? Image.network(
        httpMXH.hostImg + _user.getAvatar,
        fit: BoxFit.fill,
      )
      : Image.asset('assets/images/nullAvatar.png');
    }
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 50, 5),
      width: 300,
      height: 50,
      child: InkWell(
        child:Row(
          children: [

            Container(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                child: getAvatar(),
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(_user.getFullname, overflow: TextOverflow.ellipsis),
                  ),
                  if (_dateTime!= null) Expanded(
                    child: Text(DateFormat('dd-MM-yyyy').format(_dateTime), overflow: TextOverflow.ellipsis,textAlign: TextAlign.left,),
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0)
            ),
          ]
        ),
        onTap: () {

        }
      )
    );
  }
}

