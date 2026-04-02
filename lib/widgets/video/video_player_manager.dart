import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:flutter_application/common/funny_colors.dart';
import '../../models/video_model.dart';

// video_player と Chewie の初期化と再生状態を管理するミックスイン。
// 全画面時に独自 UI（輝度スライダー・再生・進捗バー）を表示するルートページビルダーを内包する。
// 実機では ScreenBrightness、シミュレーターでは黒オーバーレイで輝度をシミュレートする。

/// VideoPlayerController と ChewieController のライフサイクルを担当するミックスイン。
mixin VideoPlayerManager<T extends StatefulWidget> on State<T> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  // true のとき動画を再生する（isPaused=falseのときに設定）
  bool _desiredPlay = false;
  // 輝度 ValueNotifier：全画面 Route 内の UI がリアルタイムに更新される
  final ValueNotifier<double> _brightnessNotifier = ValueNotifier(0.5);
  double _dragStartY = 0;
  double _dragStartBrightness = 0.5;
  // 実機=true（システム輝度を調整）、シミュレーター=false（オーバーレイで代替）
  bool _supportsRealBrightness = false;
  // モデルから取得した表示アスペクト比（null = 縦画面全体）
  double? _displayAspectRatio;

  /// VideoPlayerController を直接参照する場合に使用（正規化済みの哨な）
  VideoPlayerController get videoController => _videoController;
  /// ChewieController。初期化完了前は null。
  ChewieController? get chewieController => _chewieController;
  /// 動画の初期化完了待機中かどうか
  bool get isLoading => _isLoading;
  /// 初期化中にエラーが発生したかどうか
  bool get hasError => _hasError;
  /// エラー発生時のメッセージ
  String get errorMessage => _errorMessage;

  void _onBrightnessDragStart(DragStartDetails d) {
    _dragStartY = d.globalPosition.dy;
    _dragStartBrightness = _brightnessNotifier.value;
  }

  Future<void> _onBrightnessDragUpdate(DragUpdateDetails d) async {
    final delta = (_dragStartY - d.globalPosition.dy) / 300.0;
    final next = (_dragStartBrightness + delta).clamp(0.0, 1.0);
    if (_supportsRealBrightness) {
      try {
        await ScreenBrightness().setScreenBrightness(next);
      } catch (_) {
        if (mounted) setState(() => _supportsRealBrightness = false);
      }
    }
    // ValueNotifier は Route を越えてリアルタイムに UI を更新する
    _brightnessNotifier.value = next;
  }

  Widget _buildBrightnessButton() {
    return GestureDetector(
      onVerticalDragStart: _onBrightnessDragStart,
      onVerticalDragUpdate: _onBrightnessDragUpdate,
      child: ValueListenableBuilder<double>(
        valueListenable: _brightnessNotifier,
        builder: (_, value, _) {
          final pct = (value * 100).round();
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wb_sunny_outlined, color: FunnyColors.white, size: 24),
              const SizedBox(height: 4),
              Text(
                '$pct%',
                style: const TextStyle(
                  color: FunnyColors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFullscreenSideButton({
    required IconData icon,
    required VoidCallback? onPressed,
    double size = 26,
  }) {
    return IconButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: Icon(icon, color: FunnyColors.white, size: size),
    );
  }

  Widget _buildFullscreenBottomBar() {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: _videoController,
      builder: (context, value, _) {
        final position = value.position;
        final duration = value.duration.inMilliseconds > 0
            ? value.duration
            : const Duration(seconds: 1);

        String format(Duration input) {
          final minutes = (input.inSeconds ~/ 60).toString().padLeft(2, '0');
          final seconds = (input.inSeconds % 60).toString().padLeft(2, '0');
          return '$minutes:$seconds';
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${format(position)} / ${format(duration)}',
              style: const TextStyle(
                color: FunnyColors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: SizedBox(
                height: 4,
                child: VideoProgressIndicator(
                  _videoController,
                  allowScrubbing: true,
                  padding: EdgeInsets.zero,
                  colors: VideoProgressColors(
                    playedColor: FunnyColors.white,
                    bufferedColor: FunnyColors.white.withValues(alpha: 0.3),
                    backgroundColor: FunnyColors.white.withValues(alpha: 0.18),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 外部から動画初期化を呼び出す入口。
  void initVideoPlayer(VideoModel video, bool isPaused) {
    _initVideoPlayer(video, isPaused);
  }

  // 動画コントローラと Chewie を生成して再生準備を整える。
  Future<void> _initVideoPlayer(VideoModel video, bool isPaused) async {
    try {
      _desiredPlay = !isPaused;
      _displayAspectRatio = video.displayAspectRatio;
      _isLoading = true;
      _hasError = false;
      // 実機かどうか判定（例外が出たら模擬器として扱う）
      try {
        _brightnessNotifier.value = await ScreenBrightness().current.timeout(
          const Duration(seconds: 2),
        );
        _dragStartBrightness = _brightnessNotifier.value;
        _supportsRealBrightness = true;
      } catch (_) {
        _brightnessNotifier.value = 0.5;
        _supportsRealBrightness = false;
      }
      if (mounted) setState(() {});

      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(video.videoUrl),
      );

      final initialization = _videoController.initialize();
      await initialization.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('動画の読み込みがタイムアウトしました');
        },
      );

      if (!mounted) return;

      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: _desiredPlay,
        looping: true,
        showControls: false,
        aspectRatio: _videoController.value.aspectRatio > 0
            ? _videoController.value.aspectRatio
            : 16.0 / 9.0,
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFFFF6B9D),
          handleColor: Colors.red,
          backgroundColor: const Color(0xFF666666),
          bufferedColor: const Color(0xFF666666),
        ),
        deviceOrientationsOnEnterFullScreen: const [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
        deviceOrientationsAfterFullScreen: const [DeviceOrientation.portraitUp],
        routePageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              ChewieControllerProvider controllerProvider,
            ) {
              return Scaffold(
                backgroundColor: Colors.black,
                resizeToAvoidBottomInset: false,
                body: SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final sw = constraints.maxWidth;
                      final sh = constraints.maxHeight;
                      final va = _displayAspectRatio
                          ?? (_videoController.value.aspectRatio > 0
                              ? _videoController.value.aspectRatio
                              : 9.0 / 16.0);
                      final renderedVw = (sh * va).clamp(0.0, sw);
                      // 黒帯幅（最低 48 px を確保してボタンが収まるように）
                      final bar = ((sw - renderedVw) / 2).clamp(48.0, sw / 2);

                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          Positioned.fill(child: controllerProvider),
                          // 輝度オーバーレイ：シミュレーター代替用（実機は alpha=0）
                          Positioned.fill(
                            child: IgnorePointer(
                              child: ValueListenableBuilder<double>(
                                valueListenable: _brightnessNotifier,
                                builder: (_, value, _) => ColoredBox(
                                  color: Colors.black.withValues(
                                    alpha: _supportsRealBrightness
                                        ? 0.0
                                        : (1.0 - value),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // ── 左パネル（幅 = bar、黒帯の上に乗せる） ──
                          Positioned(
                            left: -5,
                            top: 0,
                            bottom: 0,
                            width: bar,
                            child: Stack(
                              children: [
                                // 全画面終了ボタン：左上
                                Positioned(
                                  top: 32,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: _buildFullscreenSideButton(
                                      icon: Icons.arrow_back_ios_new_rounded,
                                      onPressed: () =>
                                          _chewieController?.exitFullScreen(),
                                      size: 24,
                                    ),
                                  ),
                                ),
                                // 輝度：縦方向中央（上下スワイプで輝度調整）
                                Positioned.fill(
                                  child: Center(
                                    child: _buildBrightnessButton(),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ── 中央：再生 / 一時停止 ──
                          Positioned.fill(
                            child: Center(
                              child: ValueListenableBuilder<VideoPlayerValue>(
                                valueListenable: _videoController,
                                builder: (context, value, _) {
                                  return _buildFullscreenSideButton(
                                    icon: value.isPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    onPressed: () {
                                      if (value.isPlaying) {
                                        _videoController.pause();
                                      } else {
                                        _videoController.play();
                                      }
                                      if (mounted) setState(() {});
                                    },
                                    size: value.isPlaying ? 60 : 68,
                                  );
                                },
                              ),
                            ),
                          ),

                          // ── 右パネル（幅 = bar、黒帯の上に乗せる） ──
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            width: bar,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildFullscreenSideButton(
                                  icon: Icons.lock_open_rounded,
                                  onPressed: () {},
                                  size: 24,
                                ),
                                const SizedBox(height: 32),
                                _buildFullscreenSideButton(
                                  icon: Icons.volume_up_rounded,
                                  onPressed: () {},
                                  size: 24,
                                ),
                              ],
                            ),
                          ),

                          // ── 下部：プログレスバー（動画幅内） ──
                          Positioned(
                            left: bar + 8,
                            right: bar + 8,
                            bottom: 12,
                            child: _buildFullscreenBottomBar(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
      );

      _isLoading = false;
      if (mounted) setState(() {});
    } on TimeoutException {
      _hasError = true;
      _errorMessage = '動画の読み込みがタイムアウトしました。通信状況を確認してください';
      _isLoading = false;
      if (mounted) setState(() {});
    } catch (e) {
      _hasError = true;
      _errorMessage = '動画の読み込みに失敗しました: ${e.toString()}';
      _isLoading = false;
      if (mounted) setState(() {});
    }
  }

  // 表示中かどうかに応じて再生・停止を切り替える。
  void updateVideoPlayback(bool isPaused) {
    _desiredPlay = !isPaused;
    if (_videoController.value.isInitialized) {
      if (isPaused) {
        _videoController.pause();
      } else {
        _videoController.play();
      }
    }
  }

  // 動画ソースが変わったときにコントローラを作り直す。
  void updateVideoSource(VideoModel newVideo) {
    _videoController.dispose();
    _chewieController?.dispose();
    _initVideoPlayer(newVideo, false);
  }

  // エラー表示から同じ動画の再読み込みを試す。
  void retryLoadVideo() {
    _hasError = false;
    _errorMessage = '';
    _initVideoPlayer((context as dynamic).widget.video, false);
  }

  // 再生関連コントローラを破棄する。
  void disposeVideoPlayer() {
    _brightnessNotifier.dispose();
    _videoController.dispose();
    _chewieController?.dispose();
  }
}
