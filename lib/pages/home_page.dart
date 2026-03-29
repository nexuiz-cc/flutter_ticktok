import 'package:flutter/material.dart';
import 'package:flutter_application/pages/placeholder_page.dart';
import 'package:flutter_application/pages/video_page.dart';
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
    const PlaceholderPage(text: '我'),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
      ),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: IconButton(
          icon: Icon(icon, color: Colors.black, size: 30),
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
          Icon(icon, color: isActive ? Colors.white : Colors.grey, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
