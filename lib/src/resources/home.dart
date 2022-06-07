import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mxh/src/resources/navbar/navbar.dart';
import 'package:mxh/src/resources/HomePage.dart';
import 'package:mxh/src/resources/GroupPage.dart';
import 'package:mxh/src/resources/FriendPage.dart';

class Main extends StatefulWidget {
Main({Key? key}) : super(key: key);
  @override
  State<Main> createState() => _MainState();
}
class _MainState extends State<Main> {
  PageController? _pageController;

  List<Widget>? _pageList;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
      _pageList =  [
      HomePage(),
      FriendPage(),
      GroupPage(),
      FriendPage()
    ];
     _pageController = PageController(initialPage: _selectedIndex ?? 0);
  }
  @override
  void dispose() {
    _pageController?.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PageView(
          controller: _pageController,
          //The following parameter is just to prevent
          //the user from swiping to the next page.
          physics: NeverScrollableScrollPhysics(),
          children: _pageList ?? <Widget>[],
        ),
        bottomNavigationBar:Navbar(changePage: (int val) => changePage(val))
      )
    );
  }

  void changePage(int val) {
    setState(() {
      _selectedIndex = val;
        _pageController?.jumpToPage(val);
    });
  }

  Future<void> reset()  async {
        final prefs = await SharedPreferences.getInstance();
        prefs.clear();

  }
}