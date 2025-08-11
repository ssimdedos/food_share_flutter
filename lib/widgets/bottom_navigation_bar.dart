import 'package:flutter/material.dart';
import 'package:oasis/models/model.dart';
import 'package:oasis/screens/board_page.dart';
import 'package:oasis/screens/chat_list_page.dart';
import 'package:oasis/screens/post/post_upload_page.dart';
import 'package:oasis/screens/profile_page.dart';

List<NavItem> _navItems = [
  NavItem(
    index: 0,
    activeIcon: Icons.home,
    inactiveIcon: Icons.home_outlined,
    label: '홈',
  ),
  NavItem(
    index: 1,
    activeIcon: Icons.add_box,
    inactiveIcon: Icons.add,
    label: '등록',
  ),
  NavItem(
      index: 2,
      activeIcon: Icons.chat_bubble,
      inactiveIcon: Icons.chat_bubble_outline_outlined,
      label: '채팅'
  ),
  NavItem(
    index: 3,
    activeIcon: Icons.person_2,
    inactiveIcon: Icons.person_4_outlined,
    label: '마이페이지',
  ),
];

class IndexView extends StatefulWidget {
  const IndexView({super.key});

  @override
  State<IndexView> createState() => _IndexViewState();
}

class _IndexViewState extends State<IndexView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _index = 0;

  void tabListener() {
    setState(() {
      _index = _tabController.index;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _navItems.length, vsync: this);
    _tabController.addListener(tabListener);
  }

  @override
  void dispose() {
    _tabController.removeListener(tabListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(), //스와이핑으로 화면 전환 방지
        controller: _tabController,
        children: [
          BoardPage(),
          PostUploadPage(),
          ChatListPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
        unselectedItemColor: Theme.of(context).colorScheme.inversePrimary,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        onTap: (int index) {
          _tabController.animateTo(index);
        },
        currentIndex: _index,
        items: _navItems.map((item) {
          return
            BottomNavigationBarItem(
              icon: Icon(_index == item.index ? item.activeIcon : item.inactiveIcon),
              label: item.label
          );
        }).toList(),
      ),
    );
  }
}