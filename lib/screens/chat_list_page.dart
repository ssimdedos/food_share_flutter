import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {

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
            children: <Widget>[

            ],
          ),
        ),
      )
    );
  }
}