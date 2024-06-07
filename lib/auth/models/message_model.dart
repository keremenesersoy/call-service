class MessageModel {
  
  final String number;

  MessageModel({required this.number});

  Map<String, dynamic> toJson() => {"Number": number};

}
