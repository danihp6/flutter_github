import 'package:flutter/material.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/main_page.dart';

class UserInfo extends InheritedWidget{
  final User user;
  const UserInfo({this.user,Widget child}) : super(child:child);

  @override
  bool updateShouldNotify(UserInfo oldWidget) {
    return oldWidget.user != user;
  }

  static UserInfo of(BuildContext context) =>
  context.dependOnInheritedWidgetOfExactType<UserInfo>();
}