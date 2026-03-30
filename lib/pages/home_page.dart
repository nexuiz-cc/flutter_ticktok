import 'package:flutter/material.dart';
import 'package:flutter_application/common/funny_colors.dart';
import 'package:flutter_application/pages/placeholder_page.dart';
import 'package:flutter_application/pages/video_page.dart';
import 'package:flutter_application/pages/profile_page.dart';
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
    const PlaceholderPage(text: '消息'),
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
      color: Colors.black,
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
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: FunnyColors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: IconButton(
          icon: Icon(icon, color: FunnyColors.black, size: 30),
          onPressed: () {},
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        _pageController.jumpToPage(index); //
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? FunnyColors.white : FunnyColors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? FunnyColors.white : FunnyColors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
