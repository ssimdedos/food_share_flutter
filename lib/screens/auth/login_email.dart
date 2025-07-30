import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oasis/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginEmail extends StatelessWidget {
  const LoginEmail({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final authProvider = context.read<AuthProvider>();
    void onLogin() async {
      final res = await authProvider.login(email: emailController.text, password: passwordController.text);
      if (res) {
        context.go('/main');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 실패'))
        );
      }
    }
    
    final List<Widget> _loginBox = [
      TextField(
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        decoration: const InputDecoration(
          labelText: '이메일',
          hintText: 'user@example.com',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.email),
        ),
      ),
      const SizedBox(height: 15.0),
      TextField(
        obscureText: true, // 비밀번호 숨김 처리
        controller: passwordController,
        decoration: const InputDecoration(
          labelText: '비밀번호',
          hintText: '비밀번호를 입력하세요',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.lock),
        )
      ),
      const SizedBox(height: 20.0),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onLogin,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical:15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)
            ),
          ),
          child: const Text(
            '로그인',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      )
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('이메일 로그인'),
        leading: IconButton(onPressed: () {
          if(context.canPop()) {
            context.pop();
          } else {
            context.go('/');
          }
        }, icon: const Icon(Icons.navigate_before)),
      ),
      body: Center(
        child: SingleChildScrollView( // 키보드 등 UI 오버플로우 방지
          child: Container(
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _loginBox,
            ),
          ),
        ),
      ),
    );
  }
}