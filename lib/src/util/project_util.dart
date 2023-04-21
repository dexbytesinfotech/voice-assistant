import 'dart:convert';

import 'package:voice_assistant/src/util/shared_pref.dart';

class PackageUtil {
  static List<String> addedString = [];

  set addVoiceText(String value) {
    addedString.add(value);
    String encodedData = json.encode(addedString);
    localStorage.saveStr("item_list", encodedData);
  }

  set addDataFromLocalStore(String value) {
    if (value.isNotEmpty) {
      List<String> addedStringTemp = json.decode(value).cast<String>();
      addedString.addAll(addedStringTemp);
    }
  }

  get getVoiceTextList => addedString;

  String getText(String dateFormat, DateTime dateTime) {
    return "";
  }
}

PackageUtil packageUtil = PackageUtil();
