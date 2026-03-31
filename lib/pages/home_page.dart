import 'package:flutter/material.dart';
import 'package:flutter_application/common/funny_colors.dart';
import 'package:flutter_application/pages/placeholder_page.dart';
import 'package:flutter_application/pages/video_page.dart';
import 'package:flutter_application/pages/profile_page.dart';
import 'package:flutter_application/pages/message_page.dart';
import 'friend_page.dart';

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
    const PlaceholderPage(text: '拍摄'),
    const MessagePage(),
    const ProfilePage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FunnyColors.black,
      extendBodyBehindAppBar: true,
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

  Widget _buildBottomNavigationBar() {
    return Container(
      color: FunnyColors.darkgrey,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.home, '首页', 0),
              _buildNavItem(Icons.people_outline, '朋友', 1),
              _buildNavItem(Icons.add_circle_outline, '', 2, isCenter: true),
              _buildNavItem(Icons.notifications_outlined, '消息', 3),
              _buildNavItem(Icons.person_outline, '我', 4),
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
        _pageController.jumpToPage(index); //
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
