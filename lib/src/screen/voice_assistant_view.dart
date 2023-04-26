part of voice_assistant;

enum ListenStatus { non, listening, notListening, done }

enum ActionType { search, store, multiOption }

/// Mic main widget.
/// User will get current converted text [listenTextCompleteCallBack]
/// User will open direct mic by enable/disable [micClicked]
/// Change View configuration [micIcon], [micNoneIcon], [saveIcon], [saveIcon],
/// [loaderColor], [waveColor], [waveDoneColor], [micBgColorColor]
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
  final Color? waveColor;
  final Color? waveDoneColor;
  final Color? micBgColorColor;
  final ActionType clickedActionType;
  final bool micClicked;
  final int listenEndTimeInSecond;

  const VoiceToTextView({
    Key? key,
    required this.listenTextStreamCallBack,
    required this.listenTextCompleteCallBack,
    this.listenStatus = ListenStatus.non,
    this.isDoingBackgroundProcess = false,
    this.micClicked = false,
    this.listenStatusCallBack,
    this.clickedActionType = ActionType.search,
    this.loaderColor = Colors.white,
    this.micIcon,
    this.micNoneIcon,
    this.listenEndTimeInSecond = 5,
    this.saveIcon,
    this.waveColor = Colors.red,
    this.waveDoneColor = Colors.green,
    this.micBgColorColor = Colors.green,
  }) : super(key: key);

  @override
  State<VoiceToTextView> createState() => _VoiceToTextViewState(
      listenStatus: listenStatus,
      micClicked: micClicked,
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
  bool micClicked;

  _VoiceToTextViewState(
      {this.listenStatus = ListenStatus.non,
      this.micClicked = false,
      this.isDoingBackgroundProcess = false}) {
    if (micClicked) {
      Timer(const Duration(milliseconds: 5), () {
        try {
          _voiceListenerBottomSheet(
              context: context, actionTypeValue: widget.clickedActionType);
        } catch (e) {
          // print(e);
        }
      });
    }
  }

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

  @override
  void initState() {
    super.initState();
    speech = speechToText.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (widget.clickedActionType == ActionType.multiOption) {
            //Multi option for search and save
            _optionBottomSheet(context, (ActionType clickedActionType) {
              _voiceListenerBottomSheet(
                  context: context, actionTypeValue: clickedActionType);
            });
          } else {
            ///Direct search
            _voiceListenerBottomSheet(
                context: context, actionTypeValue: widget.clickedActionType);
          }
        },
        child:
            widget.micIcon != null ? widget.micIcon! : const Icon(Icons.mic));
  }

  ///Card decoration
  BoxDecoration boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(cardRadius),
          topRight: Radius.circular(cardRadius)),
    );
  }

  /// Option bottomSheet
  void _optionBottomSheet(context, Function(ActionType) selectedItemCallBack) {
    getText(String title) => Padding(
        padding: const EdgeInsets.only(top: 7, bottom: 7),
        child: Container(
          color: Colors.transparent,
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
          return Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: boxDecoration(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        Navigator.of(bc).pop();
                        selectedItemCallBack.call(ActionType.search);
                      },
                      child: getText('Search')),
                  const SizedBox(
                    height: 5,
                    child: Center(
                      child: Divider(
                        height: 0.5,
                        color: Colors.grey,
                      ),
                    ),
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

  /// Voice Listener BottomSheet
  void _voiceListenerBottomSheet(
      {context, ActionType actionTypeValue = ActionType.search}) {
    showModalBottomSheet(
        isScrollControlled: actionTypeValue == ActionType.store ? true : false,
        context: context,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        builder: (BuildContext bc) {
          return BottomSheetView(
              waveColor: widget.waveColor,
              listenEndTimeInSecond: widget.listenEndTimeInSecond,
              waveDoneColor: widget.waveDoneColor,
              micBgColorColor: widget.micBgColorColor,
              loaderColor: widget.loaderColor,
              micIcon: widget.micIcon,
              micNoneIcon: widget.micNoneIcon,
              saveIcon: widget.saveIcon,
              actionType: actionTypeValue,
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
