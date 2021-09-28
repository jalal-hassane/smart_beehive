import 'package:flutter/material.dart';

const _tag = 'RegistrationViewModel';

class RegistrationViewModel extends ChangeNotifier {
  late RegistrationHelper helper;

  checkUsernameAvailability(String username,String password){
    if(username=='jalal'){
      helper._failure('Username not available!');
      return;
    }
    registerUser(username, password);
  }

  registerUser(String username,String password){
    helper._success();
  }
}
class RegistrationHelper{
  RegistrationHelper({
    required void Function() success,
    required void Function(String error) failure,
  })  : _success = success,
        _failure = failure;

  final Function() _success;
  final Function(String error) _failure;
}