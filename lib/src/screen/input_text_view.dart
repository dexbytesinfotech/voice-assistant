part of voice_assistant;

class InputTextView extends StatefulWidget {
  final String inputValue;
  final Function(String)? currentTextCallBack;

  const InputTextView(
      {Key? key, this.inputValue = "", this.currentTextCallBack})
      : super(key: key);

  @override
  State<InputTextView> createState() => _InputTextViewState();
}

class _InputTextViewState extends State<InputTextView> {
  bool isEnable = false;
  String inputValue = "";
  final controller = TextEditingController();

  _InputTextViewState();

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    controller.addListener(_printLatestValue);
    localStorage
        .readStr('item_list')
        .then((value) => packageUtil.addDataFromLocalStore = value);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.clear();
    controller.dispose();
  }

  @override
  void didUpdateWidget(covariant InputTextView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {
      inputValue = widget.inputValue;
      controller.text = inputValue;
      controller.selection =
          TextSelection.collapsed(offset: controller.text.length);
      if (inputValue.isNotEmpty) {
        isEnable = true;
      } else {
        isEnable = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextField(
        maxLines: 2,
        minLines: 1,
        controller: controller,
        enabled: isEnable,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Enter a search term',
            suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    controller.text = "";
                    isEnable = false;
                  });
                },
                child: const Icon(Icons.close))),
      ),
    );
  }

  void _printLatestValue() {
    // setState(() {
    inputValue = controller.text;
    if (inputValue.isNotEmpty) {
      isEnable = true;
    } else {
      isEnable = false;
    }
    // });
    widget.currentTextCallBack?.call(inputValue);
  }
}
