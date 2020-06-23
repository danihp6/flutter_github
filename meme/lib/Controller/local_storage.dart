// import 'dart:convert';

// import 'package:meme/Models/Notification.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LocalStorage {
//   SharedPreferences prefs;

//   Future initStorage() async {
//     prefs = await SharedPreferences.getInstance();
//   }

//   get notifications =>prefs.containsKey('notifications')? prefs
//       .getStringList('notifications')
//       .map((notification) => Notification.fromMap(jsonDecode(notification))).toList():<Notification>[];

//   set notifications(List<Notification> notifications) => prefs.setStringList(
//       'notifications',
//       notifications.map((notification) => jsonEncode(notification.toMap())).toList());
// }

// LocalStorage storage = new LocalStorage();