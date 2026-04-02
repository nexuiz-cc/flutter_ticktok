import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_application/common/funny_colors.dart';
import '../models/video_model.dart';

// video_player と Chewie の初期化と再生状態を管理するミックスイン。

mixin VideoPlayerManager<T extends StatefulWidget> on State<T> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _desiredPlay = false;

  VideoPlayerController get videoController => _videoController;
  ChewieController? get chewieController => _chewieController;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  // 外部から動画初期化を呼び出す入口。
  void initVideoPlayer(VideoModel video, bool isPaused) {
    _initVideoPlayer(video, isPaused);
  }

  // 動画コントローラと Chewie を生成して再生準備を整える。
  Future<void> _initVideoPlayer(VideoModel video, bool isPaused) async {
    try {
      _desiredPlay = !isPaused;
      _isLoading = true;
      _hasError = false;
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
        aspectRatio: _videoController.value.aspectRatio,
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
        routePageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              ChewieControllerProvider controllerProvider,
            ) {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                body: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      color: Colors.black,
                      child: controllerProvider,
                    ),
                    SafeArea(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.35),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: FunnyColors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {
                                _chewieController?.exitFullScreen();
                              },
                              icon: const Icon(
                                Icons.chevron_left,
                                color: FunnyColors.white,
                              ),
                              tooltip: '退出全屏',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
    _videoController.dispose();
    _chewieController?.dispose();
  }
}
