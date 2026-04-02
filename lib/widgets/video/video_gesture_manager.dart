import 'package:flutter/material.dart';

// 二重タップ処理の連続発火を抑えるミックスイン。
// Flutter の GestureDetector はダブルタップを短時間に複数発火する場合がある。
// フラグで最初の1回だけ処理し、300ms 待機後にリセットする。

/// ダブルタップの連続取得を防ぐミックスイン。
mixin VideoGestureManager<T extends StatefulWidget> on State<T> {
  // 発火済みフラグ（true の間は次のタップを無視）
  bool _isDoubleTapHandled = false;

  // 短時間の連続ダブルタップを1回にまとめて扱う。
  void handleDoubleTap(VoidCallback? onDoubleTapCallback) {
    if (_isDoubleTapHandled) return;

    _isDoubleTapHandled = true;

    if (onDoubleTapCallback != null) {
      onDoubleTapCallback();
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _isDoubleTapHandled = false;
      }
    });
  }
}
