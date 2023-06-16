// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

class MessageModel {
  String? senderId;
  String? receiverId;
  String? text;
  String? date;

  MessageModel({
    this.senderId,
    this.receiverId,
    this.text,
    this.date,
  });

  MessageModel.fromJson(Map<String, dynamic> message) {
    senderId = message['senderId'];
    receiverId = message['receiverId'];
    text = message['text'];
    date = message['date'];
  }

  Map<String, dynamic> toMap() => {
        'senderId': senderId,
        'receiverId': receiverId,
        'text': text,
        'date': date,
      };
}
