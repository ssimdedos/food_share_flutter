import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginEmail extends StatelessWidget {
  const LoginEmail({super.key});

  @override
  Widget build(BuildContext context) {
    void onLogin() {
      context.go('/main');
      // Navigator.pushNamed(context, '/main');
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const IndexView()),
      // );
    }
    
    final List<Widget> _loginBox = [
      TextField(
        keyboardType: TextInputType.emailAddress,
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
      appBar: AppBar(title: const Text('이메일 로그인')),
      body: Center( // Center로 감싸서 폼을 중앙에 배치
        child: SingleChildScrollView( // 키보드 등 UI 오버플로우 방지
          child: Container(
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.all(20.0),
            // alignment: Alignment.center, // Column에서 mainAxisAlignment를 사용하므로 여기서는 필요 없음
            decoration: BoxDecoration( // Material 위젯 추가로 인한 color 이동
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