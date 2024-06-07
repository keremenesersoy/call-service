import 'package:call_service/auth/models/call_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CallRepository {
  final collection = FirebaseFirestore.instance.collection('Calls');

  void addNumber(CallModel callModel) async {
    await collection.add(callModel.toJson());
  }

}
