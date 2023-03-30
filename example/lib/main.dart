import 'dart:convert';

import 'package:example/http_service.dart';
import 'package:flutter/material.dart';
import 'package:voice_to_text/voice_to_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice To Text',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Voice to Text'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
String textStringValue = "";
List<dynamic> searchedData =[];
bool isSearching = false;


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,iconTheme: const IconThemeData(
        color: Colors.black, //change your color here
      ),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title,style: const TextStyle(color: Colors.black)),
        centerTitle: true,elevation: 2.5,actions:  [InkWell(onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VoiceTextListView()),
        );
      },child: Container(margin: const EdgeInsets.only(right: 10),child: const Icon(Icons.list_alt,)))],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // const SizedBox(height: 15,),
            /*Text(
              textStringValue,
              style: Theme.of(context).textTheme.headlineMedium,
            ),*/


            SizedBox(height: 300,child: Align(alignment: Alignment.bottomCenter,child:

            VoiceToTextView(micClicked: true,isDoingBackgroundProcess: isSearching,listenTextStreamCallBack: (String? value) {
             // setState(() {
               // textStringValue = value!;
              //});
              print("");
            },
              listenTextCompleteCallBack: (String? value,ActionType actionTypeValue) async {
              if(value!.isNotEmpty && actionTypeValue == ActionType.search){
                print("Search  $value");
                //selectValue==0?"varieties":"restaurants";
                setState(() {
                  isSearching = true;
                });
                Map<String,dynamic> requestData = {'keyword':value,'search_type':'varieties','latitude':22.750741,'longitude':75.89564};
                String jsonStringResponse = await httpService.getPosts(requestData);
                Map<String,dynamic> responseData = json.decode(jsonStringResponse);
                if(responseData.isNotEmpty && responseData['success'] && responseData['data'].isNotEmpty){
                  //setState(() {
                    searchedData = responseData['data'];
                //  });
                }
                setState(() {
                  isSearching = false;
                });
                print("Search  $jsonStringResponse");
              }
              else
              {
               print("Save $value");
              }
            },),)),
           Expanded(child:  Column(children: [ListView.builder(shrinkWrap: true,
               itemCount: searchedData.length,
               itemBuilder: (BuildContext context, int index) {
                 return Padding(
                   padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                   child: Row(children: [const Icon(Icons.lens,size: 10,),const SizedBox(width: 10,),Expanded(child: Text(searchedData[index]['title'],style: const TextStyle(fontSize: 18),))],),
                 );
               })],))
          ],
        ),
      )
    );
  }
}
