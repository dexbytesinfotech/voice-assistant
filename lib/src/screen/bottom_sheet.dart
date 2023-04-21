part of voice_assistant;

class BottomSheetView extends StatefulWidget {
  final Function(String?) listenTextStreamCallBack;
  final Function(String?, ActionType) listenTextCompleteCallBack;
  final Function(ListenStatus)? listenStatusCallBack;
  final VoidCallback? closeCallBack;
  final ListenStatus? listenStatus;
  final bool? isDoingBackgroundProcess;
  final ActionType? actionType;
  final Widget? micIcon;
  final Widget? micNoneIcon;
  final Widget? saveIcon;
  final Color? loaderColor;
  final Color? waveColor;
  final Color? waveDoneColor;
  final Color? micBgColorColor;
  final int listenEndTimeInSecond;

  const BottomSheetView({
    Key? key,
    required this.listenTextStreamCallBack,
    required this.listenTextCompleteCallBack,
    this.listenStatus = ListenStatus.non,
    this.isDoingBackgroundProcess = false,
    this.actionType = ActionType.search,
    this.closeCallBack,
    this.listenStatusCallBack,
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
  State<BottomSheetView> createState() {
    return _BottomSheetViewState(
        listenStatus: listenStatus,
        isDoingBackgroundProcess: isDoingBackgroundProcess!,
        actionType: actionType!,
        listenEndTimeInSecond: listenEndTimeInSecond);
  }
}

class _BottomSheetViewState extends State<BottomSheetView> {
  late speechToText.SpeechToText speech;
  bool isListen = false;
  double confidence = 1.0;
  ListenStatus? listenStatus;
  String textStringValue = "";
  ActionType actionType = ActionType.search;
  bool isDoingBackgroundProcess;
  bool isError = false;
  bool doneCalled = false;
  String topErrorMessage = "Sorry! Didn't hear that";
  String topSecondMessage = "Try saying restaurant name or a dish";
  String bottomMessage = "Tap the microphone to try again";
  double cardRadius = 20.0;
  Timer? listenTimer;
  int listenEndTimeInSecond;

  _BottomSheetViewState(
      {this.listenEndTimeInSecond = 5,
      this.listenStatus = ListenStatus.non,
      this.isDoingBackgroundProcess = false,
      this.actionType = ActionType.search}) {
    Timer(const Duration(milliseconds: 5), () {
      listen();
    });
  }

  @override
  void didUpdateWidget(covariant BottomSheetView oldWidget) {
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
    } else if (!isListen && (listenStatus == ListenStatus.done)) {
      textSaveClicked();
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
    bool avail = await speech.initialize(
        finalTimeout: const Duration(milliseconds: 500));
    if (avail) {
      setState(() {
        isListen = true;
        doneCalled = false;
        isError = false;
      });
      listenTimer = Timer(Duration(seconds: listenEndTimeInSecond), () {
        listenTimer!.cancel();
        speech.stop();
      });
      speech.errorListener = (value) {};
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
            });
            widget.listenStatusCallBack?.call(ListenStatus.notListening);
          } else if (statusValue == "done" && !doneCalled) {
            setState(() {
              doneCalled = true;
              actionType = clickedActionType;
              listenStatus = ListenStatus.done;
            });
            widget.listenStatusCallBack?.call(ListenStatus.done);
            textStreamDone();
          } else {
            if (!doneCalled) {
              setState(() {
                listenStatus = ListenStatus.non;
                isListen = false;
              });
              widget.listenStatusCallBack?.call(ListenStatus.non);
            }
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

  textSaveClicked() {
    String textStringValueTemp = textStringValue;
    packageUtil.addVoiceText = textStringValueTemp;
    setState(() {
      listenStatus = ListenStatus.non;
      textStringValue = "";
      isListen = false;
    });
    widget.listenTextCompleteCallBack.call(textStringValueTemp, actionType);
  }

  textStreamDone() {
    String textStringValueTemp = textStringValue;
    if (mounted) {
      setState(() {
        listenStatus = ListenStatus.non;
        //If voice not detect any voice to txt
        if (textStringValueTemp.isEmpty) {
          isError = true;
          isListen = false;
        }
      });
    }
    //Call Done function if get voice text
    if (textStringValueTemp.isNotEmpty) {
      if (actionType == ActionType.store) {
        if (mounted) {
          setState(() {
            listenStatus = ListenStatus.done;
            // textStringValue = "";
            isListen = false;
          });
        }
      } else if (actionType == ActionType.search) {
        Timer(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              textStringValue = "";
              isListen = false;
            });
            widget.listenTextCompleteCallBack
                .call(textStringValueTemp, actionType);
          }
        });
      }
    }
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
      return widget.micIcon != null ? widget.micIcon! : const Icon(Icons.mic);
    } else if (!isListen && (listenStatus == ListenStatus.non)) {
      return widget.micNoneIcon != null
          ? widget.micNoneIcon!
          : const Icon(Icons.mic_none);
    } else if (!isListen &&
        textStringValue.isEmpty &&
        listenStatus == ListenStatus.done) {
      return widget.micNoneIcon != null
          ? widget.micNoneIcon!
          : const Icon(Icons.mic_none);
    } else if (!isListen &&
        textStringValue.isNotEmpty &&
        listenStatus == ListenStatus.done) {
      if (actionType == ActionType.search) {
        return const Icon(Icons.search_rounded);
      } else {
        return widget.saveIcon != null
            ? widget.saveIcon!
            : const Icon(Icons.save);
      }
    }
    return widget.micNoneIcon != null
        ? widget.micNoneIcon!
        : const Icon(Icons.mic_none);
  }

  Widget topMessageView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          textStringValue.isNotEmpty
              ? textStringValue
              : (isListen ? "Listening.." : ""),
          maxLines: 1,
        ),
        actionType == ActionType.store && textStringValue.isNotEmpty
            ? SizedBox(
                width: MediaQuery.of(context).size.width / 1.25,
                child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: InputTextView(
                      inputValue: textStringValue,
                      currentTextCallBack: (value) {
                        textStringValue = value;
                        widget.listenTextStreamCallBack.call(textStringValue);
                        if (textStringValue.isNotEmpty) {
                        } else {
                          if (listenStatus == ListenStatus.done) {
                            listenStatus = ListenStatus.non;
                            isListen = false;
                            try {
                              setState(() {});
                            } catch (e) {
                              // print(e);
                            }
                          }
                          // isEnable = false;
                        }
                      },
                    )),
              )
            : const SizedBox()
      ],
    );
  }

  Widget topErrorMessageView() {
    return Column(
      children: [
        Text(topErrorMessage,
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15)),
        const SizedBox(
          height: 5,
        ),
        Text(topSecondMessage,
            style: const TextStyle(
                color: Colors.black54, fontWeight: FontWeight.normal))
      ],
    );
  }

  Widget bottomErrorMessageView() {
    return Column(
      children: [
        Text(bottomMessage,
            style: const TextStyle(
                color: Colors.black87, fontWeight: FontWeight.normal))
      ],
    );
  }

  //Card decoration
  BoxDecoration boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      // border: Border.all(width: 10,color: Colors.red[300],),
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(cardRadius),
          topRight: Radius.circular(cardRadius)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.grey.shade500,
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () {
                widget.closeCallBack?.call();
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: boxDecoration(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      isError
                          ? const SizedBox(
                              height: 0,
                            )
                          : topMessageView(),
                      !isError
                          ? const SizedBox(
                              height: 0,
                            )
                          : topErrorMessageView(),
                      AvatarGlow(
                        animate: isListen,
                        glowColor: textStringValue.isNotEmpty
                            ? widget.waveDoneColor!
                            : widget.waveColor!,
                        endRadius: 65.0,
                        duration: const Duration(milliseconds: 2000),
                        repeatPauseDuration: const Duration(milliseconds: 100),
                        repeat: true,
                        child: FloatingActionButton(
                          backgroundColor: widget.micBgColorColor,
                          child: getIcon(
                              isListen: isListen, listenStatus: listenStatus!),
                          onPressed: () {
                            if (!isDoingBackgroundProcess) {
                              listen();
                            }
                          },
                        ),
                      ),
                      !isError
                          ? (textStringValue.isEmpty && !isListen
                              ? bottomErrorMessageView()
                              : const SizedBox(
                                  height: 0,
                                ))
                          : bottomErrorMessageView()
                    ],
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
