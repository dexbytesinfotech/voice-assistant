import 'dart:convert';

import 'package:voice_assistant/src/util/shared_pref.dart';

class PackageUtil {
  static List<String> addedString = [];

  /// Add coverted text
  set addVoiceText(String value) {
    addedString.add(value);
    String encodedData = json.encode(addedString);
    localStorage.saveStr("item_list", encodedData);
  }

  /// Add Text in to the list from local storage
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
