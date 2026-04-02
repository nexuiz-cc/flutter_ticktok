import 'package:flutter/material.dart';

// いいね状態と表示件数の同期を担当するミックスイン。

mixin VideoStateManager<T extends StatefulWidget> on State<T> {
  bool _isLiked = false;
  int _currentLikeCount = 0;

  bool get isLiked => _isLiked;
  int get currentLikeCount => _currentLikeCount;

  // 初期のいいね状態と件数を内部状態へ取り込む。
  void initStateValues(bool initialIsLiked, int initialLikeCount) {
    _isLiked = initialIsLiked;
    _currentLikeCount = initialLikeCount;
  }

  // 親から渡された最新状態で内部表示を同期する。
  void updateLikeState(bool newIsLiked, int newLikeCount) {
    _isLiked = newIsLiked;
    _currentLikeCount = newLikeCount;
  }

  // ダブルタップ時は即座にいいね済み表示へ切り替える。
  void handleDoubleTapLike() {
    setState(() {
      _isLiked = true;
      _currentLikeCount++;
    });
  }
}
