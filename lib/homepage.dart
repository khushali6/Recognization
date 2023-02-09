import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stts;

class HomePage extends StatefulWidget {
  const HomePage({super.key, required String title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _speechToText = stts.SpeechToText();
  bool islistening = false;
  String text = "Press the Mic to Speak";
  void listen() async {
    if (!islistening) {
      bool available = await _speechToText.initialize(
        onStatus: (status) => print("$status"),
        onError: (errorNotification) => print("$errorNotification"),
      );
      if (available) {
        setState(() {
          islistening = true;
        });
        _speechToText.listen(
          onResult: (result) => setState(() {
            text = result.recognizedWords;
          }),
        );
      }
    } else {
      setState(() {
        islistening = false;
      });
      _speechToText.stop();
    }
  }

  @override
  void initState() {
    super.initState();
    _speechToText = stts.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Speech To Text",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: islistening,
        repeat: true,
        endRadius: 80,
        glowColor: Colors.purple,
        duration: Duration(milliseconds: 1000),
        child: FloatingActionButton(
          onPressed: () {
            listen();
          },
          child: Icon(islistening ? Icons.mic : Icons.mic_none),
        ),
      ),
    );
  }
}
