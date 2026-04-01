import 'package:flutter/material.dart';
import 'package:flutter_application/common/funny_colors.dart';
import 'package:flutter_application/pages/placeholder_page.dart';
import 'package:flutter_application/pages/video_page.dart';
import 'package:flutter_application/pages/profile_page.dart';
import 'package:flutter_application/pages/message_page.dart';
import 'friend_page.dart';

// 下部ナビゲーションと各主要ページを束ねるルート画面。

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<Widget> _pages = [
    const VideoPage(),
    const FriendPage(),
    const PlaceholderPage(text: '撮影'),
    const MessagePage(),
    const ProfilePage(),
  ];

  @override
  // ページコントローラを破棄してタブ遷移の状態を解放する。
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  // PageView と下部ナビゲーションを組み合わせてルート画面を描画する。
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FunnyColors.black,
      extendBodyBehindAppBar: true,
      // メインコンテンツのページ切り替え領域。
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // 下部の主要タブをまとめて表示するナビゲーションバー。
  Widget _buildBottomNavigationBar() {
    return Container(
      color: FunnyColors.darkgrey,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.home, 'ホーム', 0),
              _buildNavItem(Icons.people_outline, '友達', 1),
              _buildNavItem(Icons.add_circle_outline, '', 2, isCenter: true),
              _buildNavItem(Icons.notifications_outlined, 'メッセージ', 3),
              _buildNavItem(Icons.person_outline, 'マイ', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index, {
    bool isCenter = false,
  }) {
    // 現在のタブに応じて見た目を切り替える。
    final isActive = _currentPage == index;

    if (isCenter) {
      return GestureDetector(
        onTap: () {},
        child: Container(
          width: 50,
          height: 34,
          decoration: BoxDecoration(
            color: FunnyColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: FunnyColors.white, width: 1.5),
          ),
          child: const Center(
            child: Icon(Icons.add, color: FunnyColors.black, size: 26),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        _pageController.jumpToPage(index);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? FunnyColors.white : FunnyColors.grey,
            fontSize: 14,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
