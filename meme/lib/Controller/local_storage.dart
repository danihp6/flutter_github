import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  SharedPreferences _prefs;

  Future initStorage() async {
    _prefs = await SharedPreferences.getInstance();
  }

  List<String> get recentUsers => _prefs.containsKey('recentUsers')
      ? _prefs.getStringList('recentUsers')
      : <String>[];

  set recentUsers(List<String> recentUsers) =>
      _prefs.setStringList('recentUsers', recentUsers);

  List<String> get recentTags => _prefs.containsKey('recentTags')
      ? _prefs.getStringList('recentTags')
      : <String>[];

  set recentTags(List<String> recentTags) =>
      _prefs.setStringList('recentTags', recentTags);

  List<String> get recentPostLists => _prefs.containsKey('recentPostLists')
      ? _prefs.getStringList('recentPostLists')
      : <String>[];

  set recentPostLists(List<String> recentPostLists) =>
      _prefs.setStringList('recentPostLists', recentPostLists);

    List<String> get templates => _prefs.containsKey('templates')
      ? _prefs.getStringList('templates')
      : <String>[];

  set templates(List<String> templates) =>
      _prefs.setStringList('templates', templates);
}

LocalStorage storage = new LocalStorage();
