import 'dart:io';
import 'package:call_service/auth/models/call_model.dart';
import 'package:call_service/repository/call_repository.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';

class CallDetect extends StatefulWidget {
  const CallDetect({super.key});

  @override
  State<CallDetect> createState() => _CallDetectState();
}

class _CallDetectState extends State<CallDetect> {
  PhoneState status = PhoneState.nothing();
  bool granted = false;

  Future<bool> requestPermission() async {
    var status = await Permission.phone.request();

    return switch (status) {
      PermissionStatus.denied ||
      PermissionStatus.restricted ||
      PermissionStatus.limited ||
      PermissionStatus.permanentlyDenied =>
        false,
      PermissionStatus.provisional || PermissionStatus.granted => true,
    };
  }

  @override
  void initState() {
    super.initState();
    setStream();
  }

  Future<String> isNumberInContacts(String phoneNumber) async {
    Iterable<Contact> contacts = await ContactsService.getContacts();
    for (var contact in contacts) {
      for (var phone in contact.phones ?? []) {
        if (phone.value.replaceAll(RegExp(r'\D'), '') ==
            phoneNumber.replaceAll(RegExp(r'\D'), '')) {
          return contact.displayName.toString();
        }
      }
    }
    return "";
  }

  void setStream() {
    PhoneState.stream.listen((event) async {
      setState(() {
        status = event;
      });
      String temp = status.number ?? "";
      isNumberInContacts(temp).then((value) {
      if (temp.isNotEmpty && status.status == PhoneStateStatus.CALL_INCOMING) {
        CallModel callModel = CallModel(number: value.isNotEmpty ? value : temp);
        CallRepository callRepository = CallRepository();
        callRepository.addNumber(callModel);
      }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (Platform.isAndroid)
              MaterialButton(
                onPressed: !granted
                    ? () async {
                        bool temp = await requestPermission();
                        setState(() {
                          granted = temp;
                          if (granted) {
                            setStream();
                          }
                        });
                      }
                    : null,
                child: const Text('Request permission of Phone'),
              ),
            const Text(
              'Status of call',
              style: TextStyle(fontSize: 24),
            ),
            if (status.status == PhoneStateStatus.CALL_INCOMING ||
                status.status == PhoneStateStatus.CALL_STARTED)
              Text(
                'Number: ${status.number}',
                style: const TextStyle(fontSize: 24),
              ),
            Icon(
              getIcons(),
              color: getColor(),
              size: 80,
            )
          ],
        ),
      ),
    );
  }

  IconData getIcons() {
    return switch (status.status) {
      PhoneStateStatus.NOTHING => Icons.clear,
      PhoneStateStatus.CALL_INCOMING => Icons.add_call,
      PhoneStateStatus.CALL_STARTED => Icons.call,
      PhoneStateStatus.CALL_ENDED => Icons.call_end,
    };
  }

  Color getColor() {
    return switch (status.status) {
      PhoneStateStatus.NOTHING || PhoneStateStatus.CALL_ENDED => Colors.red,
      PhoneStateStatus.CALL_INCOMING => Colors.green,
      PhoneStateStatus.CALL_STARTED => Colors.orange,
    };
  }
}
