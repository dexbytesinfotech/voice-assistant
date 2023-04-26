import 'dart:convert';

import 'package:voice_assistant/src/util/shared_pref.dart';

///Common function class
class PackageUtil {
  static List<String> addedString = [];

  /// Add converted text
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

  /// Get voice text list data
  get getVoiceTextList => addedString;
}

PackageUtil packageUtil = PackageUtil();
