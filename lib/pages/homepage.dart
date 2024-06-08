import 'package:call_service/pages/call_detect.dart';
import 'package:call_service/pages/message_detect.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // MessageRepository messageRepository = MessageRepository();
  // MessageModel messageModel = MessageModel(number: "05373867407");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          centerTitle: true,
          title: const Text('Call Service'),
        ),
        body: PageView(
          children: [
            const CallDetect(),
            SmsReceiverPage(),
          ],
        ));
  }
}
