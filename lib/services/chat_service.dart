import 'dart:async';
import 'dart:convert';

import 'package:oasis/models/stomp_model.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatService {

  WebSocketChannel? _channel;

  final StreamController<StompFrame> _stompFrameController = StreamController<StompFrame>.broadcast();
  Stream<StompFrame> get stompFrames => _stompFrameController.stream;

  void connect(String url) {
    try {
      _channel = IOWebSocketChannel.connect(url);
      print('WebSocket connecting to $url');

      _channel!.stream.listen(
        (data) {
          print('WebSocket receiving data: $data');
          final StompFrame frame = toStompFrame(data);
          _stompFrameController.add(frame);
        },
        onDone: () {
          print('WebSocket: Connection closed.');
          // Implement reconnect logic here if needed
        },
        onError: (err) {
          print('WebSocket: Error - $err');
          // Error handling
        }
      );
      sendStompFrame(StompFrame(
        command: 'CONNECT',
        headers: {'accept-version': '1.2'},
      ));
    } catch(err) {
      print('WebSocket: Could not connect - $err');
    }
  }

  void subscribeToTopic(String topic) {
    sendStompFrame(StompFrame(
      command: 'SUBSCRIBE',
      headers: {
        'id': 'sub-${topic.replaceAll('/', '')}',
        'destination': topic,
      },
    ));
    print('STOMP: Subscribed to $topic');
  }

  void sendMessage(String topic, String sender, String content) {
    final body = jsonEncode({
      'sender': sender,
      'content': content,
    });

    sendStompFrame(StompFrame(
      command: 'SEND',
      headers: {
        'destination': topic,
        'content-type': 'application/json',
      },
      body: body,
    ));
    print('STOMP: Sent message to $topic');
  }

  void sendStompFrame(StompFrame frame) {
    if (_channel?.closeCode != null) {
      print('WebSocket: Channel is not open. Cannot send message.');
      return;
    }
    _channel!.sink.add(frame.toStompString());
  }
}
