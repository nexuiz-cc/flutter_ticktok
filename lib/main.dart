import 'package:flutter/material.dart';
import 'pages/home_page.dart';

// アプリ全体のテーマと最初の画面を設定するエントリーポイント。

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyTicktok',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}