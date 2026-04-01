import 'package:flutter/material.dart';

// 動画画面上部タブの選択と並び替えを管理するミックスイン。

mixin VideoTabManager<T extends StatefulWidget> on State<T> {
  late List<String> _tabs;
  late int _selectedTab;

  List<String> get tabs => _tabs;
  int get selectedTab => _selectedTab;
  set selectedTab(int value) => _selectedTab = value;

  // 動画画面上部に表示するタブ一覧を初期化する。
  void initTabs() {
    _tabs = ['経験', '厳選', '話題', '近く', 'フォロー', 'ライブ', 'ショップ', 'おすすめ'];
    _selectedTab = 0;
  }

  // ドラッグ並び替え後のタブ順序と選択状態を更新する。
  void onTabReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex--;
      }

      final item = _tabs.removeAt(oldIndex);
      _tabs.insert(newIndex, item);

      if (_selectedTab == oldIndex) {
        _selectedTab = newIndex;
      } else if (_selectedTab == newIndex) {
        _selectedTab = oldIndex;
      }
    });
  }

  // タップされたタブを現在選択中にする。
  void onTabTap(int index) {
    setState(() {
      _selectedTab = index;
    });
  }
}
