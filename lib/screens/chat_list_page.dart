import 'package:flutter/material.dart';
import 'package:oasis/providers/chat_provider.dart';
import 'package:provider/provider.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final _scrollController = ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false).initialize();
    });
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _onSend() {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.sendMsg('topic/chat-room-1', 'admin', _textEditingController.text);
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
            children: <Widget>[
              Expanded(
                child: Consumer<ChatProvider>(
                  builder: (context, provider, child) {
                    // Auto-scroll to the bottom when a new message is received
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_scrollController.hasClients) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    });

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: provider.msgs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(provider.msgs[index]),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          hintText: 'Enter your message...',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _onSend,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}