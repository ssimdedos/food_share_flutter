// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
  sender: json['sender'] as String,
  content: json['content'] as String,
  destination: json['destination'] as String,
  timestamp: (json['timestamp'] as num?)?.toInt(),
  messageId: json['messageId'] as String?,
);

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'sender': instance.sender,
      'content': instance.content,
      'destination': instance.destination,
      'timestamp': instance.timestamp,
      'messageId': instance.messageId,
    };
