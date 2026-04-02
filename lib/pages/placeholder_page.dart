import 'package:flutter/material.dart';

// 未実装機能用の汎用プレースホルダー画面。
// [text] に機能名を渡すと、中央にその文字を表示する。
// 将来の展開機能（撮影画面等）の代わりとして使用する。

class PlaceholderPage extends StatelessWidget {
  final String text;

  const PlaceholderPage({super.key, this.text = '機能開発中'});

  @override
  // 未実装機能向けの共通プレースホルダーを描画する。
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
    
