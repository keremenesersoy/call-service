import 'package:call_service/auth/models/message_model.dart';
import 'package:call_service/repository/message_repository.dart';
import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'package:permission_handler/permission_handler.dart';

class SmsReceiverPage extends StatefulWidget {
  const SmsReceiverPage({super.key});

  @override
  _SmsReceiverPageState createState() => _SmsReceiverPageState();
}

class _SmsReceiverPageState extends State<SmsReceiverPage> {
  String _sms = "Henüz SMS yok";
  final Telephony telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  void _requestPermission() async {
    var status = await Permission.sms.status;
    if (!status.isGranted) {
      await Permission.sms.request();
    }
    _startListening();
  }

  void _startListening() {
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        setState(() {
          _sms = message.body ?? "Boş mesaj";
          if(message.address != null){
            MessageModel messageModel = MessageModel(number: message.address ?? "null");
            MessageRepository messageRepository = MessageRepository();
            messageRepository.addMessage(messageModel);
          }
        });
      },
      listenInBackground: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SMS Receiver"),
      ),
      body: Center(
        child: Text(_sms),
      ),
    );
  }
}
