import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oasis/models/model.dart';
import 'package:oasis/providers/theme_notifier.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User user = User(
    id:1,
    email: 'ideademisdedos@gmail.com',
    username: 'ssim',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('마이 페이지')),
      body: Center(
        child: ListView(
          children: [
            _buildProfileHeader(user),
            _buildMenuList(context),
            Consumer<ThemeNotifier>(
              builder: (context, themeNotifier, child) {
                return Card( // TextButtonSwitches 대신 Card를 직접 사용 (코드 간결화)
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: IntrinsicWidth(
                      child: Row(
                        children: <Widget>[
                          const Expanded(child: Text('Dark Mode')),
                          const SizedBox(width: 4),
                          Switch(
                            value: themeNotifier.isDarkMode,
                            onChanged: (value) {
                              themeNotifier.toggleTheme(value);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildProfileHeader(User? user) {
  return Column(
    children: <Widget>[
      const CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage('https://i.pravatar.cc/150'), // Placeholder image
        backgroundColor: Colors.transparent,
      ),
      const SizedBox(height: 10),
      Text(
        user?.username ?? '게스트',
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        user?.email ?? '로그인 필요',
        style: const TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    ],
  );
}

Widget _buildMenuList(BuildContext context) {
  return Column(
    children: [
      ListTile(
        leading: const Icon(Icons.edit_outlined),
        title: const Text('프로필 수정'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navigate to edit profile screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('프로필 수정 기능은 아직 구현되지 않았습니다.')),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.article_outlined),
        title: const Text('내 게시글'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navigate to user's posts screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('내 게시글 기능은 아직 구현되지 않았습니다.')),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.favorite_border),
        title: const Text('찜한 게시글'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navigate to liked posts screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('찜한 게시글 기능은 아직 구현되지 않았습니다.')),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.settings_outlined),
        title: const Text('설정'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navigate to settings screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('설정 기능은 아직 구현되지 않았습니다.')),
          );
        },
      ),
      const Divider(),
      ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text('로그아웃', style: TextStyle(color: Colors.red)),
        onTap: () {
          // 로그아웃 후 로그인 화면으로 이동
          // Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          context.go('/');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('로그아웃 되었습니다.')),
          );
        },
      ),
    ],
  );
}
