import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  late SharedPreferences prefs;
  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  getSharedPref(key, type) async {
    await init();
    if (type == String) {
      return prefs.getString(key) ?? "null";
    } else if (type == bool) {
      return prefs.getBool(key) ?? false;
    }
  }

  setSharedPref(key, value, type) async {
    await init();
    if (type == String) {
      prefs.setString(key, value);
    } else if (type == bool) {
      prefs.setBool(key, value);
    }
  }

  clearSharedPref() async {
    await init();
    prefs.clear();
  }

  removeSharedPref(key) async {
    await init();
    prefs.remove(key);
  }

  getAllKeys() async {
    await init();
   return prefs.getKeys();
  }
}
