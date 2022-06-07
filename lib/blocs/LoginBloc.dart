import 'dart:convert';

import 'package:mxh/validators/validate.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mxh/config.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mxh/extension/http.dart' as httpMXH;
class LoginBloc {
  StreamController _emailController = new StreamController();
  StreamController _passwordController = new StreamController();
  void dispose() {
    _emailController.close();
    _passwordController.close();
  }
  Stream get emailStream => _emailController.stream;
  Stream get passwordStream => _passwordController.stream;
  bool isValid(String email, String password) {
    bool isValid = true;
    if (!Validator.isEmail(email)) {
      _emailController.sink.addError("Vui lòng nhập Email");
      isValid = false;
    } else {
      _emailController.sink.add("");
    }
    if (!Validator.isRequired(password)) {
      _passwordController.sink.addError("Vui lòng nhập mật khẩu");
      isValid = false;
    } else if ((!Validator.isMinLengthPass(password)) || (!Validator.isMaxLengthPass(password))) {
      _passwordController.sink.addError("Mật khẩu phải trong khoảng 6 - 30 kí tự");
      isValid = false;
    } else {
      _passwordController.sink.add("");
    }
    return isValid;
  }


  Future<void> login(String email, String password, Function onSuccess, Function(String) onError) async {
    var options = {
      'email_or_phone': email,
      'password': password
    };
    var response = await httpMXH.post('login', options);
    if (response.ok) {
      var data = json.decode(response.body);
      if (data['status'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('access_token', data['access_token']);
        onSuccess();
      } else {
        if (data['errors'].containsKey('email_or_phone'))  _emailController.sink.addError(data['errors']['email_or_phone'][0]);
        if (data['errors'].containsKey('password'))  _passwordController.sink.addError(data['errors']['password'][0]);
        if (data['errors'].containsKey('loser')) {
          onError(data['errors']['loser'][0]);
        };
      }
    } else {
      onError("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }
}
