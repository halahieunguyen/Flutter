import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mxh/src/resources/home.dart';
import 'package:mxh/src/resources/login.dart';
import 'package:mxh/extension/http.dart' as httpMXH;
import 'package:mxh/blocs/LoginBloc.dart';
import 'package:mxh/validators/validate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingApp extends StatefulWidget {
  const LoadingApp({Key? key}) : super(key: key);

  @override
  State<LoadingApp> createState() => _LoadingAppState();
}

class _LoadingAppState extends State<LoadingApp> {
  @override initState() {
    super.initState();
    checkUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Container(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          color: Colors.white,
            child:
              Center(
                child: Container(
                  child: FlutterLogo(),
                  width:70,
                  height: 70,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xfff0f0f0)
                  )
                ),
              ),
        )
      );
  }

  Future<void> checkUser() async {
    print('------------------------------------');
    var response = await httpMXH.get('userInfo', {});
    if (response.ok) {
       final prefs = await SharedPreferences.getInstance();
      prefs.setString('userInfo', response.body);
      print(response.statusCode);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Main()));
    } else {
      print(response.statusCode);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    };
  }
}