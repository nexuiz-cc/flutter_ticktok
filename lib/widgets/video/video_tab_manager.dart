import 'package:flutter/material.dart';

// 動画画面上部タブの選択と並び替えを管理するミックスイン。
// タブはドラッグで並び替え可能（ReorderableListView使用）。
// _VideoItemState にミックスインされる。

/// タブ一覧と異動タザ痛（_selectedTab）を保持するミックスイン。
mixin VideoTabManager<T extends StatefulWidget> on State<T> {
  late List<String> _tabs;
  late int _selectedTab;

  /// 現在のタブ一覧（並び替えが反映される）
  List<String> get tabs => _tabs;
  /// 現在選択中のタブインデックス
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
