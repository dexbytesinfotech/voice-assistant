import 'dart:convert';
import 'package:voice_to_text/src/util/shared_pref.dart';

class PackageUtil {
  static List<String> addedString = [];
  set addVoiceText (String value){
    addedString.add(value);
    String encodedData = json.encode(addedString);
    localStorage.saveStr("item_list", encodedData);
  }

  set addDataFromLocalStore (String value){
    if(value.isNotEmpty) {
      List<String> addedStringTemp = json.decode(value).cast<String>();
      addedString.addAll(addedStringTemp);
    }
  }

  get getVoiceTextList => addedString;

  String getText(String dateFormat,DateTime dateTime) {
    return "";
    /*try {
      if (dateTime == null) {
            return 'Select Date';
          }
          else {
            if(dateFormat.isNotEmpty){
              return DateFormat(dateFormat).format(dateTime).toString();
            }
            return DateFormat('dd MMMM, yyyy').format(dateTime);
          }
    } catch (e) {
      print(e);
      return 'Select Date';
    }*/
  }
}

PackageUtil packageUtil = PackageUtil();