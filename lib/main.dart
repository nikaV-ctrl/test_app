import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final GlobalKey _containerKey = GlobalKey();

  final TextEditingController containerHeightController =
      TextEditingController();
  final TextEditingController textController = TextEditingController();

  double minContainerHeight = 60;
  double containerHeight = 60;
  bool changeToImage = false;
  String text = "Test long";

  String imageUrl =
      "https://flutterawesome.com/content/images/2021/06/offset_10.png";

  @override
  void initState() {
    super.initState();
    if (containerHeightController.text.isEmpty) {
      containerHeightController.text = containerHeight.toString();
    }
    if (textController.text.isEmpty) textController.text = text;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateContainerHeight();
    });
  }

  @override
  void dispose() {
    containerHeightController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                field(
                  title: "Высота контейнера:",
                  controller: containerHeightController,
                  hint: "",
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 16),
                field(
                  title: "Текст:",
                  controller: textController,
                  hint: "",
                ),
                const SizedBox(height: 16),
                button(),
                const SizedBox(height: 16),
                circleOrImage(),
                const SizedBox(height: 32),
                container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget field({
    required String title,
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
        ),
        const SizedBox(height: 3),
        SizedBox(
          height: 60,
          child: Center(
            child: TextFormField(
              controller: controller,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: hint,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              textAlignVertical: TextAlignVertical.center,
              keyboardType: keyboardType,
            ),
          ),
        ),
      ],
    );
  }

  Widget circleOrImage() {
    return Center(
      child: InkWell(
        onTap: () {
          setState(() => changeToImage = !changeToImage);
        },
        child: Text(
          changeToImage ? "Отобразить красный круг" : "Отобразить фото",
          style: const TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

  Widget button() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          backgroundColor: const Color.fromRGBO(254, 0, 0, 100),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
          ),
        ),
        onPressed: () {
          onPressed.call();
        },
        child: const Text('Изменить параметры контейнера'),
      ),
    );
  }

  Widget container() {
    double screenWidth = MediaQuery.of(context).size.width - 32;
    return Container(
      color: const Color.fromRGBO(217, 217, 217, 100),
      constraints: BoxConstraints(minHeight: containerHeight),
      width: double.infinity,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (screenWidth / 4) + 16,
            ).copyWith(left: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                key: _containerKey,
                text,
              ),
            ),
          ),
          Positioned(
            top: -20,
            bottom: -20,
            right: -screenWidth / 8,
            child: SizedBox(
              width: screenWidth / 4,
              height: containerHeight * 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: ClipOval(
                  child: changeToImage
                      ? SizedBox(
                          width: screenWidth / 4,
                          height: containerHeight * 2,
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      : Container(
                          width: screenWidth / 4,
                          height: containerHeight * 2,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(254, 0, 0, 100),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onPressed() {
    setState(() {
      text = textController.text;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateContainerHeight();
      });
    });
  }

  void _updateContainerHeight() {
    double newHeight =
        double.tryParse(containerHeightController.text) ?? minContainerHeight;

    final RenderBox renderBox =
        _containerKey.currentContext?.findRenderObject() as RenderBox;
    double renderHeight = renderBox.size.height;

    setState(() {
      if (newHeight >= minContainerHeight &&
          newHeight < renderHeight) {
        containerHeight = renderHeight;
      } else if (newHeight >= minContainerHeight &&
          newHeight > renderHeight) {
        containerHeight = newHeight;
      } else if (newHeight < minContainerHeight) {
        containerHeight = renderHeight >= minContainerHeight
            ? renderHeight
            : minContainerHeight;
      } else {
        containerHeight = newHeight;
      }
      containerHeightController.text = containerHeight.toString();
    });
  }
}
