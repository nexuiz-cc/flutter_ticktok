import 'package:flutter/material.dart';

// 未実装機能用の汎用プレースホルダー画面。

class PlaceholderPage extends StatelessWidget {
  final String text;

  const PlaceholderPage({super.key, this.text = '機能開発中'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
