import 'package:call_service/auth/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MessageRepository {
  final collection = FirebaseFirestore.instance.collection('Messages');

  void addMessage(MessageModel messageModel) async {
    await collection.add(messageModel.toJson());
  }

}
