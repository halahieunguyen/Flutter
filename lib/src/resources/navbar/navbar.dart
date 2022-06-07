import 'package:flutter/material.dart';
import 'package:mxh/src/resources/dialog/LoadingDialog.dart';
import 'package:mxh/src/resources/dialog/MessageDialog.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key, this.changePage}) : super(key: key);

  final changePage;
  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int selectedIndex = 0;
   @override initState() {
    super.initState();
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