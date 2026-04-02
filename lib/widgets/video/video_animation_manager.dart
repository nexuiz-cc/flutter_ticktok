import 'package:flutter/material.dart';

// いいね演出用アニメーション状態を再利用するミックスイン。
// ダブルタップで赤ハートが大きくなりながらフェードアウトする演出。
// SingleTickerProviderStateMixin を使う親 State から初期化する必要がある。

/// いいねハートエフェクトのアニメーションを担当するミックスイン。
mixin VideoAnimationManager<T extends StatefulWidget> on State<T> {
  late AnimationController _animationController;
  // ハートアイコンを 0.5x から 2x に拡大するアニメーション
  late Animation<double> _scaleAnimation;
  // 1.0 から 0.0 へフェードアウトするアニメーション
  late Animation<double> _opacityAnimation;
  // true の間だけハートアイコンを表示する
  bool _showLikeAnimation = false;

  AnimationController get animationController => _animationController;
  /// true のときハートアイコンを画面に表示する
  bool get showLikeAnimation => _showLikeAnimation;

  // いいね演出で使う拡大とフェードのアニメーションを初期化する。
  void initAnimations(TickerProvider vsync) {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: vsync,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
  }

  // ハート演出を一度だけ再生し、完了後に表示を戻す。
  void playLikeAnimation() {
    if (_showLikeAnimation) return;

    setState(() {
      _showLikeAnimation = true;
    });

    _animationController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _showLikeAnimation = false;
          });
        }
      });
    });
  }

  Animation<double> get scaleAnimation => _scaleAnimation;
  Animation<double> get opacityAnimation => _opacityAnimation;

  // アニメーションコントローラを破棄する。
  void disposeAnimations() {
    _animationController.dispose();
  }
}
