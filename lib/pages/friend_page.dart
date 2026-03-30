import 'package:flutter/material.dart';
import '../common/funny_colors.dart';

class FriendPage extends StatelessWidget {
  const FriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FunnyColors.black,
      appBar: AppBar(
        backgroundColor: FunnyColors.black,
        title: const Text(
          '朋友',
          style: TextStyle(color: FunnyColors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          '朋友页面',
          style: TextStyle(color: FunnyColors.white, fontSize: 24),
        ),
      ),
    );
  }
}