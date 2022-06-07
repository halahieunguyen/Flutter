import 'dart:convert';

import 'package:mxh/validators/validate.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mxh/config.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mxh/extension/http.dart' as httpMXH;
class RegisterBloc {
  StreamController _emailController = new StreamController();
  StreamController _passwordController = new StreamController();
  StreamController _firstNameController = new StreamController();
  StreamController _lastNameController = new StreamController();
  // StreamController _genderController = new StreamController();
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _firstNameController.close();
    // _genderController.close();
  }
  Stream get emailStream => _emailController.stream;
  Stream get passwordStream => _passwordController.stream;
  Stream get firstNameStream => _firstNameController.stream;
  Stream get lastNameStream => _lastNameController.stream;
  // Stream get genderNameStream => _genderController.stream;
  bool isValid(String email, String password, String first, String last) {
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

    if (!Validator.isRequired(first)) {
      _firstNameController.sink.addError("Vui lòng nhập Họ");
      isValid = false;
    } else if (!Validator.isMaxLengthPass(first)) {
      _firstNameController.sink.addError("Họ phải ít hơn 30 kí tự");
      isValid = false;
    } else {
      _firstNameController.sink.add("");
    }

    if (!Validator.isRequired(last)) {
      _lastNameController.sink.addError("Vui lòng nhập Tên");
      isValid = false;
    } else if (!Validator.isMaxLengthPass(last)) {
      _lastNameController.sink.addError("Tên phải ít hơn 30 kí tự");
      isValid = false;
    } else {
      _lastNameController.sink.add("");
    }
    return isValid;
  }


  Future<void> register(Map<String, dynamic> options, Function onSuccess, Function(String) onError) async {
    print('----------------------------------');
    var response = await httpMXH.post('register', options);

    if (response.ok) {
      var data = json.decode(response.body);
      if (data['status'] == 'success') {
        onSuccess();
      } else {
        print(response.body);
        if (data['errors'].containsKey('email_or_phone'))  _emailController.sink.addError(data['errors']['email_or_phone'][0]);
        if (data['errors'].containsKey('password'))  _passwordController.sink.addError(data['errors']['password'][0]);
        if (data['errors'].containsKey('first_name'))  _firstNameController.sink.addError(data['errors']['first_name'][0]);
        if (data['errors'].containsKey('last_name'))  _lastNameController.sink.addError(data['errors']['last_name'][0]);
        if (data['errors'].containsKey('loser')) {
          onError(data['errors']['loser'][0]);
        } else {
        };
      }
    } else {
      onError("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }
}
