import 'package:flutter/material.dart';

// 二重タップ処理の連続発火を抑えるミックスイン。

mixin VideoGestureManager<T extends StatefulWidget> on State<T> {
  bool _isDoubleTapHandled = false;

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