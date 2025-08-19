import 'package:json_annotation/json_annotation.dart';

part 'chat_message.g.dart';

@JsonSerializable()
class ChatMessage {
  final String sender;
  final String content;
  final String destination;
  final int? timestamp;
  final String? messageId;

  ChatMessage({
    required this.sender,
    required this.content,
    required this.destination,
    this.timestamp,
    this.messageId,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}