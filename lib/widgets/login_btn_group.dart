
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginBtnGroup extends StatefulWidget {
  const LoginBtnGroup({super.key});

  @override
  State<LoginBtnGroup> createState() => _LoginBtnGroupState();
}

class _LoginBtnGroupState extends State<LoginBtnGroup> {
  late final ScrollController scrollController;
  static const Widget verticalSpacer = SizedBox(height: 16);

  void _login() {
    print('로그인 버튼 클릭됨!'); // 로그 명확화
    // 여기에 구글, 네이버, 카카오 로그인 로직 추가
  }

  void _loginEmail() {
    // MaterialApp에 routes를 정의했으므로 pushNamed 사용 권장
    // Navigator.pushNamed(context, '/login_email');
    // Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginEmail()));
    context.push('/login_email');
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
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: btnColumn,
    );
  }
}