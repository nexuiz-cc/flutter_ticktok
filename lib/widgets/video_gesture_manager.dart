// 手势管理逻辑
import 'package:flutter/material.dart';

mixin VideoGestureManager<T extends StatefulWidget> on State<T> {
  bool _isDoubleTapHandled = false;

  void handleDoubleTap(VoidCallback? onDoubleTapCallback) {
    if (_isDoubleTapHandled) return;

    _isDoubleTapHandled = true;

    // 触发动画（需要在具体的 state 中调用）
    // 这里不直接调用，由使用方负责

    // 调用父组件的回调
    if (onDoubleTapCallback != null) {
      onDoubleTapCallback();
    }

    // 重置标记
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _isDoubleTapHandled = false;
      }
    });
  }
}