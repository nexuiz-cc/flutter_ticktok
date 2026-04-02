import 'package:flutter/material.dart';
import 'package:flutter_application/common/funny_colors.dart';
import 'package:flutter_application/pages/placeholder_page.dart';
import 'package:flutter_application/pages/video_page.dart';
import 'package:flutter_application/pages/profile_page.dart';
import 'package:flutter_application/pages/message_page.dart';
import 'friend_page.dart';

// 下部ナビゲーションと各主要ページを束ねるルート画面。
// 左から: ホーム(動画), 友達, 撮影, メッセージ, マイプロフィールの5タブ構成。

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  // 各タブに対応するページ内容。タブ順とPageViewのインデックスを対応させる。
  final List<Widget> _pages = [
    const VideoPage(),         // index 0: ホーム（動画フィード）
    const FriendPage(),        // index 1: 友達
    const PlaceholderPage(text: '撮影'),  // index 2: 撮影（未実装）
    const MessagePage(),       // index 3: メッセージ
    const ProfilePage(),       // index 4: マイプロフィール
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
      // 左右スワイプでタブ遷移できる。
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
        child: SizedBox(
          height: 56,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _buildNavItem(Icons.home, 'ホーム', 0)),
              Expanded(child: _buildNavItem(Icons.people_outline, '友達', 1)),
              Expanded(
                child: _buildNavItem(Icons.add_circle_outline, '', 2,
                    isCenter: true),
              ),
              Expanded(
                  child: _buildNavItem(
                      Icons.notifications_outlined, 'メッセージ', 3)),
              Expanded(child: _buildNavItem(Icons.person_outline, 'マイ', 4)),
            ],
          ),
        ),
      ),
    );
  }

  // 個々のナビゲーションアイテムを構築する。
  // [isCenter] のときはプラスボタンUI、それ以外はアイコン+ラベルテキスト。
  Widget _buildNavItem(
    IconData icon,
    String label,
    int index, {
    bool isCenter = false,
  }) {
    // 現在のタブに応じて見た目を切り替える。
    final isActive = _currentPage == index;

    if (isCenter) {
      // 中央の撮影ボタン・将来的に撮影画面へ遷移する予定。
      return GestureDetector(
        onTap: () {},
        child: Center(
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
        ),
      );
    }

    // タップで PageView をアニメーションなしで即時遷移する。
    return GestureDetector(
      onTap: () {
        _pageController.jumpToPage(index);
      },
      child: Center(
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
