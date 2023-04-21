part of voice_assistant;

class VoiceTextListView extends StatefulWidget {
  const VoiceTextListView({Key? key}) : super(key: key);

  @override
  State<VoiceTextListView> createState() => _VoiceTextListViewState();
}

class _VoiceTextListViewState extends State<VoiceTextListView> {
  List<String> dataList = [];
  bool isRevers = false;
  _VoiceTextListViewState() {
    dataList = packageUtil.getVoiceTextList;
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          centerTitle: true,
          title: const Text(
            'Notes',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 2.5,
          actions: [
            InkWell(
                onTap: () {
                  setState(() {
                    // isRevers = !isRevers;
                    dataList = dataList.reversed.toList();
                    // dataList = dataList.reversed;
                  });
                },
                child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: const Icon(
                      Icons.import_export_sharp,
                    )))
          ]),
      body: Container(
        color: Colors.white,
        child: Center(
          child: dataList.isNotEmpty
              ? ListView.builder(
                  reverse: isRevers,
                  itemCount: dataList.length,
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
                            dataList[index],
                            style: const TextStyle(fontSize: 18),
                          ))
                        ],
                      ),
                    );
                  })
              : const Placeholder(),
        ),
      ),
    );
  }
}
