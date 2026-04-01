import 'package:flutter/material.dart';

// いいね演出用アニメーション状態を再利用するミックスイン。

mixin VideoAnimationManager<T extends StatefulWidget> on State<T> {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _showLikeAnimation = false;

  AnimationController get animationController => _animationController;
  bool get showLikeAnimation => _showLikeAnimation;

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

  void disposeAnimations() {
    _animationController.dispose();
  }
}