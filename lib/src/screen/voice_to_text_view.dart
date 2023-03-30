part of voice_to_text;

enum ListenStatus { non, listening, notListening, done }

enum ActionType { search, store }

class VoiceToTextView extends StatefulWidget {
  final Function(String?) listenTextStreamCallBack;
  final Function(String?, ActionType) listenTextCompleteCallBack;
  final Function(ListenStatus)? listenStatusCallBack;
  final ListenStatus? listenStatus;
  final bool? isDoingBackgroundProcess;
  final Widget? micIcon;
  final Widget? micNoneIcon;
  final Widget? saveIcon;
  final Color? loaderColor;

  const VoiceToTextView(
      {Key? key,
      required this.listenTextStreamCallBack,
      required this.listenTextCompleteCallBack,
      this.listenStatus = ListenStatus.non,
      this.isDoingBackgroundProcess = false,
      this.listenStatusCallBack,
      this.loaderColor = Colors.white,
      this.micIcon,
      this.micNoneIcon,
      this.saveIcon,
      })
      : super(key: key);

  @override
  State<VoiceToTextView> createState() => _VoiceToTextViewState(
      listenStatus: listenStatus,
      isDoingBackgroundProcess: isDoingBackgroundProcess!);
}

class _VoiceToTextViewState extends State<VoiceToTextView> {
  late speechToText.SpeechToText speech;
  bool isListen = false;
  double confidence = 1.0;
  ListenStatus? listenStatus;
  String textStringValue = "";
  ActionType actionType = ActionType.search;
  bool isDoingBackgroundProcess;
  double cardRadius = 20.0;
  _VoiceToTextViewState(
      {this.listenStatus = ListenStatus.non,
      this.isDoingBackgroundProcess = false});

  final Map<String, HighlightedWord> highlightWords = {
    "flutter": HighlightedWord(
        textStyle: const TextStyle(
            color: Colors.redAccent, fontWeight: FontWeight.bold)),
    "developer": HighlightedWord(
        textStyle: const TextStyle(
            color: Colors.redAccent, fontWeight: FontWeight.bold)),
  };

  @override
  void didUpdateWidget(covariant VoiceToTextView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (isDoingBackgroundProcess != widget.isDoingBackgroundProcess) {
      setState(() {
        isDoingBackgroundProcess = widget.isDoingBackgroundProcess!;
      });
    }
  }

  void listen() async {
    //Display pop to take input from user for search type
    if (!isListen && listenStatus == ListenStatus.non) {
      voiceToTextListen(actionType);
      /*showMyDialog((ActionType clickedActionType) async {
        voiceToTextListen(clickedActionType);
      });*/
    } else if (!isListen && (listenStatus == ListenStatus.done)) {
      textStreamDone();
    } else {
      setState(() {
        isListen = false;
        listenStatus == ListenStatus.done;
      });
      speech.stop();
    }
  }

  //voice to text
  voiceToTextListen(ActionType clickedActionType) async {
    bool avail = await speech.initialize();
    if (avail) {
      setState(() {
        isListen = true;
      });
      speech.statusListener = (value) {
        if (mounted) {
          String statusValue = value.toLowerCase();
          if (statusValue == "listening") {
            setState(() {
              listenStatus = ListenStatus.listening;
            });
            widget.listenStatusCallBack?.call(ListenStatus.listening);
          } else if (statusValue == "notlistening") {
            setState(() {
              listenStatus = ListenStatus.notListening;
              isListen = false;
            });
            widget.listenStatusCallBack?.call(ListenStatus.notListening);
          } else if (statusValue == "done") {
            setState(() {
              actionType = clickedActionType;
              listenStatus = ListenStatus.done;
              isListen = false;
            });

            widget.listenStatusCallBack?.call(ListenStatus.done);
          } else {
            setState(() {
              listenStatus = ListenStatus.non;
              isListen = false;
            });
            widget.listenStatusCallBack?.call(ListenStatus.non);
          }
        }
      };

      speech.listen(onResult: (value) {
        setState(() {
          textStringValue = value.recognizedWords;
          if (value.hasConfidenceRating && value.confidence > 0) {
            confidence = value.confidence;
          } else {}
        });
        widget.listenTextStreamCallBack.call(textStringValue);
      });
    }
  }

  textStreamDone() {
    String textStringValueTemp = textStringValue;
    setState(() {
      listenStatus = ListenStatus.non;
      if (textStringValue.isNotEmpty) {
        //Store value in case
        if (actionType == ActionType.store) {
          packageUtil.addVoiceText = textStringValue;
        }
        textStringValue = "";
      }
    });
    widget.listenTextCompleteCallBack.call(textStringValueTemp, actionType);
  }

  @override
  void initState() {
    super.initState();
    speech = speechToText.SpeechToText();
  }

  Widget getIcon(
      {bool isListen = false, ListenStatus listenStatus = ListenStatus.non}) {
    if (isDoingBackgroundProcess) {
      return Center(
          child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                strokeWidth: 0.8,
                color: widget.loaderColor,
              )));
    } else if (isListen && (listenStatus == ListenStatus.listening)) {
      return widget.micIcon!=null?widget.micIcon!:const Icon(Icons.mic);
    } else if (!isListen && (listenStatus == ListenStatus.non)) {
      return widget.micNoneIcon!=null?widget.micNoneIcon!:const Icon(Icons.mic_none);
    } else if (!isListen &&
        textStringValue.isEmpty &&
        listenStatus == ListenStatus.done) {
      return widget.micNoneIcon!=null?widget.micNoneIcon!:const Icon(Icons.mic_none);
    } else if (!isListen &&
        textStringValue.isNotEmpty &&
        listenStatus == ListenStatus.done) {
      if(actionType == ActionType.search){
        return const Icon(Icons.search_rounded);
      }
      else {
        return widget.saveIcon!=null?widget.saveIcon!: const Icon(Icons.save);
      }
    }
    return widget.micNoneIcon!=null?widget.micNoneIcon!:const Icon(Icons.mic_none);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          //Multi option for search and save
          _optionBottomSheet(context,(ActionType clickedActionType){
            _voiceListenerBottomSheet(context:context,actionTypeValue: clickedActionType);
          });
          //Direct search
        // _voiceListenerBottomSheet(context:context);
        },
        child: SizedBox(height: 50, width: 50, child: widget.micIcon!=null?widget.micIcon! : const Icon(Icons.mic)));
  }
  //Card decoration
  BoxDecoration boxDecoration (){
    return BoxDecoration(
      color: Colors.white,
      // border: Border.all(width: 10,color: Colors.red[300],),
      borderRadius: BorderRadius.only(topLeft: Radius.circular(cardRadius),topRight: Radius.circular(cardRadius)),
    );
  }
  void _optionBottomSheet(context,Function(ActionType) selectedItemCallBack) {
    getText(String title) => Padding(
        padding: const EdgeInsets.only(top: 7, bottom: 7),
        child: Container(color: Colors.transparent,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              // const Icon(Icons.radio_button_off),
              const SizedBox(
                width: 5,
              ),
              Text(title)
            ],
          ),
        ));

    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return
            Container(padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),decoration: boxDecoration(),
                child:
            Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                  onTap: () {
                    Navigator.of(bc).pop();
                    selectedItemCallBack.call(ActionType.search);
                  },
                  child: getText('Search')),
              const Divider(
                height: 0.5,
                color: Colors.grey,
              ),
              InkWell(
                  onTap: () {
                    Navigator.of(bc).pop();
                    selectedItemCallBack.call(ActionType.store);
                  },
                  child: getText('Save')),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(bc).pop();
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, right: 5, left: 5),
                        child: Text('Cancel'),
                      )),
                ],
              )
            ],
          ));
        });
  }

  void _voiceListenerBottomSheet({context,ActionType actionTypeValue = ActionType.search}) {
    showModalBottomSheet(isScrollControlled:actionTypeValue == ActionType.store?true:false,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return BottomSheetView(loaderColor:widget.loaderColor,
              micIcon:widget.micIcon,
              micNoneIcon:widget.micNoneIcon,
              saveIcon:widget.saveIcon,actionType: actionTypeValue,
              listenTextCompleteCallBack:
                  (String? value, ActionType actionTypeValue) {
                widget.listenTextCompleteCallBack.call(value, actionTypeValue);
                Navigator.pop(bc);
              },
              listenTextStreamCallBack: widget.listenTextStreamCallBack,
              listenStatus: widget.listenStatus,
              isDoingBackgroundProcess: widget.isDoingBackgroundProcess,
              listenStatusCallBack: widget.listenStatusCallBack,
              closeCallBack: () {
                Navigator.pop(bc);
              });
        });
  }
}
