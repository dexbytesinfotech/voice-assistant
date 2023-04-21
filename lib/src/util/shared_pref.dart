import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static SharedPreferences? prefs;

  clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
    } catch (e) {
      // debugPrint("$e");
    }
  }

  Future<bool> saveStr(keys, values) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = keys;
      final value = values;
      prefs.setString(key, value);
      print('saved $key $value');
      return true;
    } catch (e) {
      // debugPrint("$e");
      return false;
    }
  }

  Future<String> readStr(keys) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = keys;
      print('read key: $keys');
      final value = prefs.getString(key) ?? "";
      print('read value: $keys $value');
      return value;
    } catch (e) {
      print("$e");
      return "";
    }
  }

  /*Get stored local form from device */
  Future<String>? getFormDataLocal() async {
    String? formData = "";
    try {
      prefs ??= await _prefs;
      formData = prefs!.getString("form_data_local") ?? "";
    } catch (e) {
      print(e);
      formData = "";
    }
    return formData;
  }

  /*Store form data local device*/
  Future<String>? storeFormDataLocal(String formJson) async {
    String? formData = "";
    try {
      prefs ??= await _prefs;
      bool? formDataStored =
          await prefs!.setString("form_data_local", formJson);
      formData = formDataStored ? formJson : "";
    } catch (e) {
      print(e);
      formData = "";
    }
    return formData;
  }
}

LocalStorage localStorage = LocalStorage();
