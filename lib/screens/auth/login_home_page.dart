
import 'package:flutter/material.dart';
import 'package:oasis/widgets/login_btn_group.dart';

class LoginHomePage extends StatelessWidget {
  const LoginHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView( // 키보드 등 UI 오버플로우 방지
          padding: const EdgeInsets.all(16),
          child: LoginBtnGroup(),
        ),
      ),
    );
  }
}