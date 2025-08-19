
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oasis/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginBtnGroup extends StatefulWidget {
  const LoginBtnGroup({super.key});

  @override
  State<LoginBtnGroup> createState() => _LoginBtnGroupState();
}

class _LoginBtnGroupState extends State<LoginBtnGroup> {
  late final ScrollController scrollController;
  static const Widget verticalSpacer = SizedBox(height: 16);


  void _loginEmail() {
    context.push('/login_email');
  }

  void _signup() {
    context.push('/signup_email');
  }

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    void _login() async {
      print('로그인 버튼 클릭됨!'); // 로그 명확화
      // 여기에 구글, 네이버, 카카오 로그인 로직 추가
      final res = await authProvider.login(email: 'admin@oasis.com', password: 'qwertyui');
      if (res) {
        context.go('/main');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('로그인 실패'))
        );
      }
    }
    final List<Widget> btnColumn = <Widget>[
      verticalSpacer,
      TextButton(onPressed: _login, child: const Text('구글로 로그인')),
      verticalSpacer,
      TextButton(onPressed: _login, child: const Text('네이버로 로그인')),
      verticalSpacer,
      TextButton(onPressed: _login, child: const Text('카카오로 로그인')),
      verticalSpacer,
      TextButton(onPressed: _loginEmail, child: const Text('이메일로 로그인')),
      verticalSpacer,
      verticalSpacer,
      TextButton(onPressed: _signup, child: const Text('회원가입')),
      verticalSpacer,
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: btnColumn,
    );
  }
}