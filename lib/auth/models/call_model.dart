class CallModel {
  
  final String number;

  CallModel({required this.number});

  Map<String, dynamic> toJson() => {"Number": number};

}