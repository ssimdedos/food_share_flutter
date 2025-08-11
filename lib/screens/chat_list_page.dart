import 'dart:io';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late final TextEditingController _textEditingController;
  late final WebSocketChannel channel;
  late final List<Text> chats;
  final _scrollController = ScrollController();
  @override
  void initState() {
    _textEditingController = TextEditingController();
    chats = [];
    channel = WebSocketChannel.connect(
      Uri.parse('ws://10.0.2.2:3039'),
    );
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    channel.sink.close();
    chats.clear();
    super.dispose();
  }

  void _onSend() {
    channel.sink.add(_textEditingController.text);
    _textEditingController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채팅 목록'),
      ),
      body: Center(
        child: SizedBox(
          height: 500,
          child: Column(
            children: [
              StreamBuilder(
                stream: channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    chats.add(Text(snapshot.data));
                  }
                  return Expanded(child: ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                    final message = chats[chats.length - 1 - index ];
                    return ListTile(
                      title: message,
                    );
                  }));
                },
              ),
              TextField(controller: _textEditingController,),
              TextButton(onPressed: _onSend, child: const Text('전송')),
            ],
          ),
        ),
      )
    );
  }
}