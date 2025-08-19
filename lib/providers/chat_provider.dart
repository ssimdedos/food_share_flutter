import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oasis/services/chat_service.dart';

// enum chatState {loading, connecting, connected, error}

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  final List<String> _msgs = [];
  List<String> get msgs => _msgs;
  StreamSubscription? _subscription;
  void initialize() {
    if(_subscription != null) return;

    _subscription = _chatService.stompFrames.listen((frame) {
      if (frame.command == 'MESSAGE' && frame.body != null) {
        final chatMsg = jsonDecode(frame.body!);
        _msgs.add(chatMsg['content']);
        notifyListeners();
      }
    });

    _chatService.connect('ws://10.0.2.2:3039');
  }

  void sendMsg(String topic, String sender, String content) {
    _chatService.sendMessage(topic, sender, content);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

}