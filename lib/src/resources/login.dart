import 'package:flutter/material.dart';
import 'package:mxh/src/resources/dialog/LoadingDialog.dart';
import 'package:mxh/src/resources/dialog/MessageDialog.dart';
import 'package:mxh/src/resources/home.dart';
import 'package:mxh/src/resources/register.dart';
import 'package:mxh/blocs/LoginBloc.dart';
import 'package:mxh/validators/validate.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isHidePass = true;
  LoginBloc loginBloc = new LoginBloc();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  @override dispose() {
    loginBloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Container(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          color: Colors.white,
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
              StreamBuilder(
                stream: loginBloc.emailStream,
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
                    stream: loginBloc.passwordStream,
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
                  // StreamBuilder(
                  //   stream: loginBloc.loginFailStream,
                  //   builder: (context, snapshot) {
                  //     Future.delayed(Duration.zero,(){
                  //       if (snapshot.hasError) {
                  //         showDialog(
                  //           context: context,
                  //           builder: (context) => AlertDialog(
                  //             title: const Text("Lỗi"),
                  //             content: Text(snapshot.error.toString()),
                  //             actions: [
                  //               TextButton(
                  //                 child: const Text("Đóng"),
                  //                 onPressed: () {
                  //                   Navigator.of(context).pop();
                  //                 }
                  //               )
                  //             ]
                  //           )
                  //         );
                  //       }
                  //     });
                  //     return SizedBox.shrink();
                  //   }
                  // ),
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
                      "ĐĂNG NHẬP",
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                  },
                  child: Text(
                    "Tạo tài khoản mới",
                    style: TextStyle(
                      color: Colors.green,
                    )
                  ),
                ),
              )
            ],)
        )
      );
  }
  void login () async {
    if (loginBloc.isValid(_emailController.text, _passController.text)) {
      LoadingDialog.showLoadingDialog(context, 'Loading.....');
      loginBloc.login(
        _emailController.text,
        _passController.text,
        () {
          LoadingDialog.hideLoadingDialog(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => Main()));
        },
        (msg) {
          LoadingDialog.hideLoadingDialog(context);
          MessageDialog.showMessageDialog(context, 'Đăng nhập', msg);
        }
      );
    }
  }
}