import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mxh/model/user.dart';
import 'package:mxh/src/resources/dialog/LoadingDialog.dart';
import 'package:mxh/src/resources/dialog/MessageDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mxh/extension/http.dart' as httpMXH;

class Navbar extends StatefulWidget {
  const Navbar({Key? key, this.changePage}) : super(key: key);

  final changePage;
  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int selectedIndex = 0;
  User? _user;

   @override initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
     final prefs = await SharedPreferences.getInstance();
     setState(() {
       this._user =   User.currentUser;
     });
  }
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: this.selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "contacts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "contacts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "contacts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "contacts",
          ),
          BottomNavigationBarItem(
          label: "contacts",
          icon: Container(
            width: 30, height: 30,
            child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15)),
              child:  (_user?.getAvatar != null)
              ? Image.network(
                  httpMXH.hostImg + _user?.getAvatar,
                )
                : Image.asset('assets/images/nullAvatar.png'),
              ),
          ),
          ),
        ],
        onTap: (int index) {
          this.onTapHandler(index);
        },
    );
  }
  void onTapHandler(int index)  {
    this.setState(() {
      this.selectedIndex = index;
      widget.changePage(index);
    });
  }
}