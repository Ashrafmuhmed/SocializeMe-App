
import 'package:cloud_firestore/cloud_firestore.dart';

class Messagemodel {
  final String content, senderId;
  final Timestamp  time;
  bool isRead;
  Messagemodel(
      {required this.content,
      required this.senderId,
      required this.time,
      required this.isRead});
  factory Messagemodel.fromJson(Map<String, dynamic> json) {
  return Messagemodel(
    isRead: json['isRead'] ?? false, // Use a default value for isRead if missing
    content: json['message'] ?? '',  // Default to an empty string if message is missing
    senderId: json['senderId'] ?? '', // Provide a default value if senderId is missing
    time: json['timestamp'] ?? Timestamp.now(),  // The processed timestamp value
  );
  }
}
