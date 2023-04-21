import 'dart:convert';

import 'package:example/http_service.dart';
import 'package:voice_assistant/voice_assistant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Assistant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Voice Assistant'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String textStringValue = "";
  List<dynamic> searchedData = [];
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title:
              Text(widget.title, style: const TextStyle(color: Colors.black)),
          centerTitle: true,
          elevation: 2.5,
          actions: [
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VoiceTextListView()),
                  );
                },
                child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: const Icon(
                      Icons.list_alt,
                    )))
          ],
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  height: 300,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: VoiceToTextView(
                      micClicked: true,
                      isDoingBackgroundProcess: isSearching,
                      listenTextStreamCallBack: (String? value) {},
                      listenTextCompleteCallBack:
                          (String? value, ActionType actionTypeValue) async {
                        if (value!.isNotEmpty &&
                            actionTypeValue == ActionType.search) {
                          setState(() {
                            isSearching = true;
                          });
                          Map<String, dynamic> requestData = {
                            'keyword': value,
                            'search_type': 'varieties',
                            'latitude': 22.750741,
                            'longitude': 75.89564
                          };
                          String jsonStringResponse =
                              await httpService.getPosts(requestData);
                          Map<String, dynamic> responseData =
                              json.decode(jsonStringResponse);
                          if (responseData.isNotEmpty &&
                              responseData['success'] &&
                              responseData['data'].isNotEmpty) {
                            //setState(() {
                            searchedData = responseData['data'];
                            //  });
                          }
                          setState(() {
                            isSearching = false;
                          });
                        } else {}
                      },
                    ),
                  )),
              Expanded(
                  child: Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchedData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 10),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.lens,
                                size: 10,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Text(
                                searchedData[index]['title'],
                                style: const TextStyle(fontSize: 18),
                              ))
                            ],
                          ),
                        );
                      })
                ],
              ))
            ],
          ),
        ));
  }
}
