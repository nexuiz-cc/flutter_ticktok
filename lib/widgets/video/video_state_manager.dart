import 'package:flutter/material.dart';

// いいね状態と表示件数の同期を担当するミックスイン。
// VideoPage から渡される isLiked/likeCount と、画面内の表示を分離する。
// ダブルタップ時は親に通知する前に即座に表示を値上げする最適化。

/// いいね表示数と状態を維持するミックスイン。
mixin VideoStateManager<T extends StatefulWidget> on State<T> {
  bool _isLiked = false;
  int _currentLikeCount = 0;

  /// 現在のいいね状態
  bool get isLiked => _isLiked;
  /// 画面に表示するいいね件数
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
