import 'package:flutter/material.dart';
import 'pages/home_page.dart';

// アプリ全体のテーマと最初の画面を設定するエントリーポイント。
// アプリ起動時に Flutter が最初に呼び出す関数。

void main() {
  // FlutterEngine 初期化を完了してから MyApp を起動する。
  runApp(const MyApp());
}

// アプリルートウィジェット。MaterialApp を返すだけのシンプルなクラス。
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // タスクスイッチャーに表示されるアプリ名
      title: 'MyTicktok',
      // インク・スイッチ・ダイアログ等はダークテーマを基本にする
      theme: ThemeData.dark(),
      // 最初に表示する画面はホーム画面（ナビゲーションを含むルート）
      home: const HomePage(),
    );
  }
}