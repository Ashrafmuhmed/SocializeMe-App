import 'package:socializeme_app/models/messageModel.dart';
import 'package:socializeme_app/models/userData.dart';

class Chatmodel {
  Userdata user;
  bool newMessages;
  Messagemodel lastMessage;
  Chatmodel(
      {required this.lastMessage,
      required this.newMessages,
      required this.user});
}
