import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:oasis/services/chat_service.dart';
import 'package:oasis/utils/dio_client.dart';

// enum chatState {loading, connecting, connected, error}

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  final List<String> _msgs = [];
  List<String> get msgs => _msgs;
  StreamSubscription? _subscription;
  void initialize(String roomId) async {
    if(_subscription != null) return;

    try {
      final response = _chatService.getMessages(roomId);
      final List<dynamic> historyMsgs = jsonDecode(response['messages']);
      _msgs.clear();
      _msgs.addAll(historyMsgs.map((msg) => msg['content']));
      notifyListeners();
    } catch (err) {
      print('과거 채팅 기록 불러오기 에러: $err');
    }

    _subscription = _chatService.stompFrames.listen((frame) {
      if (frame.command == 'MESSAGE' && frame.body != null) {
        final chatMsg = jsonDecode(frame.body!);
        _msgs.add(chatMsg['content']);
        notifyListeners();
      }
    });

    _chatService.connect('ws://10.0.2.2:3039');
  }

  void sendMsg(String topic, int sender, String content) {
    _chatService.sendMessage(topic, sender, content);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<String> createChat(int postId, int authorId, int userId) async {
    final res = await _chatService.enterChat(postId, authorId, userId);
      notifyListeners();
    return res;
  }

}