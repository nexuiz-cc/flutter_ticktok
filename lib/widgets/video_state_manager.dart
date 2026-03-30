// 状态管理逻辑
import 'package:flutter/material.dart';

mixin VideoStateManager<T extends StatefulWidget> on State<T> {
  bool _isLiked = false;
  int _currentLikeCount = 0;

  bool get isLiked => _isLiked;
  int get currentLikeCount => _currentLikeCount;

  void initStateValues(bool initialIsLiked, int initialLikeCount) {
    _isLiked = initialIsLiked;
    _currentLikeCount = initialLikeCount;
  }

  void updateLikeState(bool newIsLiked, int newLikeCount) {
    _isLiked = newIsLiked;
    _currentLikeCount = newLikeCount;
  }

  void handleDoubleTapLike() {
    setState(() {
      _isLiked = true;
      _currentLikeCount++;
    });
  }
}