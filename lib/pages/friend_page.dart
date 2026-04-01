import 'package:flutter/material.dart';
import '../common/funny_colors.dart';

// 友達タブの簡易プレースホルダー画面。

class FriendPage extends StatelessWidget {
  const FriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FunnyColors.black,
      appBar: AppBar(
        backgroundColor: FunnyColors.black,
        title: const Text('友達', style: TextStyle(color: FunnyColors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          '友達ページ',
          style: TextStyle(color: FunnyColors.white, fontSize: 24),
        ),
      ),
    );
  }
}
