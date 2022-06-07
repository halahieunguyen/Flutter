import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mxh/src/resources/dialog/LoadingDialog.dart';
import 'package:mxh/src/resources/dialog/MessageDialog.dart';
import 'package:mxh/src/resources/home.dart';
import 'package:mxh/src/resources/login.dart';
import 'package:mxh/blocs/RegisterBloc.dart';
import 'package:mxh/validators/validate.dart';
import 'package:intl/intl.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isHidePass = true;
  RegisterBloc registerBloc = new RegisterBloc();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();
  bool _gender = true;
  TextEditingController _passController = new TextEditingController();
  @override dispose() {
    registerBloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Container(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          color: Colors.white,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: Text(
                      "KMA",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.orange[800]
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        flex: 4,
                        child: Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: StreamBuilder(
                          stream: registerBloc.firstNameStream,
                          builder: (context, snapshot) => TextField(
                            style: TextStyle(fontSize: 16),
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              labelText: "Họ",
                              errorText:  snapshot.hasError ? snapshot.error.toString() : null,
                              labelStyle: TextStyle(
                                color: Color(0xff888888),
                                fontSize: 16
                              )
                            )
                          )
                        ),
                        )
                      ),
                      Flexible(
                        flex: 7,
                        child:StreamBuilder(
                          stream: registerBloc.lastNameStream,
                          builder: (context, snapshot) => TextField(
                            style: TextStyle(fontSize: 16),
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              labelText: "Tên",
                              errorText:  snapshot.hasError ? snapshot.error.toString() : null,
                              labelStyle: TextStyle(
                                color: Color(0xff888888),
                                fontSize: 16
                              )
                            )
                          )
                        ),
                      )
                      // StreamBuilder(
                      //   stream: registerBloc.lastNameStream,
                      //   builder: (context, snapshot) => TextField(
                      //     style: TextStyle(fontSize: 16),
                      //     controller: _firstNameController,
                      //     decoration: InputDecoration(
                      //       labelText: "Tên",
                      //       errorText:  snapshot.hasError ? snapshot.error.toString() : null,
                      //       labelStyle: TextStyle(
                      //         color: Color(0xff888888),
                      //         fontSize: 16
                      //       )
                      //     )
                      //   )
                      // )
                    ]
                  ),
                    TextField(
                      controller: _dateController, //editing controller of this TextField
                      decoration: InputDecoration(
                        labelText: "Ngày sinh" //label text of field
                      ),
                      readOnly: true,  //set it true, so that user will not able to edit text
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2019, 1),
                          lastDate: DateTime(2021,12),
                          builder: (context,picker){
                            return Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: ColorScheme.dark(
                                primary: Colors.deepPurple,
                                onPrimary: Colors.white,
                                surface: Colors.pink,
                                onSurface: Colors.yellow,
                              ),
                              dialogBackgroundColor:Colors.green[900],
                            ),
                            child: picker!,);
                          })
                          .then((selectedDate) {
                            //TODO: handle selected date
                            if(selectedDate!=null){
                              _dateController.text = selectedDate.toString();
                            }
                          }
                        );
                      }
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          flex: 2,
                          child: Text("Giới tính:", style: TextStyle(fontSize: 16))
                        ),
                        Flexible(
                          flex: 4,
                          child:ListTile(
                            title: const Text('Nam'),
                            leading: SizedBox(
                              width: 20,
                              height: 20,
                              child: Radio(
                                value: true,
                                groupValue: _gender,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = true;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          child:ListTile(
                            title: const Text('Nữ'),
                            leading: SizedBox(
                              width: 20,
                              height: 20,
                              child: Radio(
                                value: false,
                                groupValue: _gender,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = false;
                                  });
                                },
                              ),
                            ),
                          ),
                        )
                      ]
                  ),
                    ),
                  // StreamBuilder(
                  //   stream: registerBloc.genderNameStream,
                  //   builder: (context, snapshot) => Text(
                  //     snapshot.hasError ? snapshot.error.toString() : "",
                  //     style: TextStyle(color: Colors.red)
                  //   )
                  // ),
                  StreamBuilder(
                    stream: registerBloc.emailStream,
                    builder: (context, snapshot) => TextField(
                      style: TextStyle(fontSize: 16),
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        errorText:  snapshot.hasError ? snapshot.error.toString() : null,
                        labelStyle: TextStyle(
                          color: Color(0xff888888),
                          fontSize: 16
                        )
                      )
                    )
                  ),
                  Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: <Widget>[
                      StreamBuilder(
                        stream: registerBloc.passwordStream,
                        builder: (context, snapshot) => TextField(
                          style: TextStyle(fontSize: 16),
                          controller: _passController,
                          obscureText: _isHidePass,
                          decoration: InputDecoration(
                            labelText: "Mật khẩu",
                            errorText:  snapshot.hasError ? snapshot.error.toString() : null,
                            labelStyle: TextStyle(
                              color: Color(0xff888888),
                              fontSize: 16
                            )
                          )
                        )
                      ),
                      GestureDetector(
                        onTap: () => {
                          setState(() {
                            _isHidePass = !_isHidePass;
                          })
                        },
                        child: Text(
                          _isHidePass ? "Hiển thị" : "Ẩn",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                      )
                    ]
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: RaisedButton(
                        color: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        onPressed: login,
                        child: Text(
                          "ĐĂNG KÍ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            )
                        )
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                      child: Text(
                        "Bạn đã có tài khoản?",
                        style: TextStyle(
                          color: Colors.green,
                        )
                      ),
                    ),
                  )
                ],),
            ),
          )
        )
      );
  }
  void login () async {
    if (registerBloc.isValid(_emailController.text, _passController.text, _firstNameController.text, _lastNameController.text)) {
      LoadingDialog.showLoadingDialog(context, 'Loading.....');
      registerBloc.register({
          'email_or_phone': _emailController.text,
          'password': _passController.text,
          'password_confirmation': _passController.text,
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'gender': _gender ? '1' : '2',
          'bird_day': '2000-07-12',
        },
        () {
          LoadingDialog.hideLoadingDialog(context);
          MessageDialog.showMessageDialog(context, 'Đăng kí', "Đăng kí thành công", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
          }
          );
        },
        (msg) {
          LoadingDialog.hideLoadingDialog(context);
          MessageDialog.showMessageDialog(context, 'Đăng kí', msg);
        }
      );
    }
  }
}