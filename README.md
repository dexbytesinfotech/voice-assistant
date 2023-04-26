# voice-assistant

A library that exposes device specific speech recognition capability.

This plugin contains a set of classes that make it easy to use the voice recognition
capabilities of the underlying platform in Flutter. It supports Android, iOS. The
target use cases for this library are commands and short phrases, not continuous spoken
conversion or always on listening.

|               | Android   | iOS    |
| :-------------| :---------| :------|
| **Support**   | SDK 21+   | 10.0+  |

## voice-assistant Implementation Guide
#### Add below permission in iOS info.plist. 
    <key>NSMicrophoneUsageDescription</key>
    <string>This example listens for speech on the device microphone on your request.</string>
    <key>NSSpeechRecognitionUsageDescription</key>
    <string>This example recognizes words as you speak them and displays them. </string>

#### Add below permission in android AndroidManifest.xml
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.INTERNET"/>

## Features

Use this plugin in your Flutter app to:

* Convert speech to text and search.
* Convert speech to text and store text in local storage.

## Getting started

This plugin relies on the flutter core.

## Usage

To use the plugin you just need to add voice_assistant: ^1.0.0+4 into your pubspec.yaml file and run
pub get.

#### Add following into your package's pubspec.yaml (and run an implicit dart pub get):

voice_assistant: ^1.0.0+4

[comment]: <> (## Multi Step Form UI Sample)

[comment]: <> (![alt text]&#40;https://github.com/dexbytes/dynamic_multi_step_form/blob/master/lib/ui_image/multi_step_form.png?raw=true&#41;)

[comment]: <> (Credit for sample UI: )

## Example

     import 'dart:convert';
     import 'package:example/http_service.dart';
     import 'package:voice_assistant/voice_assistant.dart';

     void main() { runApp(const MyApp()); }

     class MyApp extends StatelessWidget { const MyApp({super.key});
     // This widget is the root of your application. @override Widget build(BuildContext context) {
     return MaterialApp(
     title: 'Voice Assistant', theme: ThemeData(
     primarySwatch: Colors.blue,
     ), home: const MyAppPage(title: 'Voice Assistant'),
     ); } }

     class MyAppPage extends StatefulWidget { const MyAppPage({super.key, required this.title});
     final String title;

     @override State<MyAppPage> createState() => _MyAppPageState(); }
     class _MyAppPageState extends State<MyAppPage> { String textStringValue = ""; List<dynamic>
     searchedData = []; bool isSearching = false;

     @override Widget build(BuildContext context) { return Scaffold(
     appBar: AppBar(
     backgroundColor: Colors.white, iconTheme: const IconThemeData(
     color: Colors.black, //change your color here
     ), title:
     Text(widget.title, style: const TextStyle(color: Colors.black)), centerTitle: true, elevation: 2.5,
     actions: [
     InkWell(
     onTap: () { Navigator.push(
     context, MaterialPageRoute(
     builder: (context) => const VoiceTextListView()),); }, 
     child: Container(
     margin: const EdgeInsets.only(right: 10), child: const Icon(Icons.list_alt,)))
      ],), body: Center(
     // Center is a layout widget. It takes a single child and positions it // in the middle of the
     parent. child: Column(
     mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
     SizedBox(
     height: 300, child: Align(
     alignment: Alignment.bottomCenter, child: VoiceToTextView(
     micClicked: true, isDoingBackgroundProcess: isSearching, listenTextStreamCallBack: (String? value)
     {}, listenTextCompleteCallBack:
     (String? value, ActionType actionTypeValue) async { if (value!.isNotEmpty && actionTypeValue ==
     ActionType.search) { setState(() { isSearching = true; }); Map<String, dynamic> requestData = {
     'keyword': value,
     'search_type': 'varieties',
     'latitude': 22.750741,
     'longitude': 75.89564 }; String jsonStringResponse = await httpService.getPosts(requestData); Map<
     String, dynamic> responseData = json.decode(jsonStringResponse); if (responseData.isNotEmpty &&
     responseData['success'] && responseData['data'].isNotEmpty) { //setState(() { searchedData =
     responseData['data']; // }); 
     }
     setState(() {
     isSearching = false; }); 
     }
     else {} },),)),
     Expanded(
     child: Column(
     children: [
     ListView.builder(
     shrinkWrap: true, itemCount: searchedData.length, itemBuilder: (BuildContext context, int index) {
     return Padding(
     padding: const EdgeInsets.only(
     left: 10, right: 10, top: 10, bottom: 10), child: Row(
     children: [
     const Icon(Icons.lens, size: 10,), const SizedBox(width: 10,), 
     Expanded(
     child: Text(searchedData[index]['title'], style: const TextStyle(fontSize: 18),))
     ],),); })
     ],))
     ],),)); } }

## Changelog

All notable changes to this project will be documented in [this file](./CHANGELOG.md).

## Issues

To report your issues, submit them directly in
the [Issues](https://github.com/dexbytesinfotech/voice-assistant/issues) section.

## License

[this file](./LICENSE).
