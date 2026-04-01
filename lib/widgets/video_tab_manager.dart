import 'package:flutter/material.dart';

mixin VideoTabManager<T extends StatefulWidget> on State<T> {
  late List<String> _tabs;
  late int _selectedTab;

  List<String> get tabs => _tabs;
  int get selectedTab => _selectedTab;
  set selectedTab(int value) => _selectedTab = value;

  void initTabs() {
    _tabs = ['经验', '精选', '热点', '同城', '关注', '直播', '商城', '推荐'];
    _selectedTab = 0;
  }

  void onTabReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) newIndex--;
      final item = _tabs.removeAt(oldIndex);
      _tabs.insert(newIndex, item);

      if (_selectedTab == oldIndex) {
        _selectedTab = newIndex;
      } else if (_selectedTab == newIndex) {
        _selectedTab = oldIndex;
      }
    });
  }

  void onTabTap(int index) {
    setState(() {
      _selectedTab = index;
    });
  }
}