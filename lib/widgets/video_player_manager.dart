// 视频播放管理逻辑
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../models/video_model.dart';

mixin VideoPlayerManager<T extends StatefulWidget> on State<T> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _desiredPlay = false; // 记录期望的播放状态

  VideoPlayerController get videoController => _videoController;
  ChewieController? get chewieController => _chewieController;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  void initVideoPlayer(VideoModel video, bool isPaused) {
    _initVideoPlayer(video, isPaused);
  }

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
          throw TimeoutException('视频加载超时');
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
      );

      _isLoading = false;
      if (mounted) setState(() {});
    } on TimeoutException {
      _hasError = true;
      _errorMessage = '视频加载超时，请检查网络';
      _isLoading = false;
      if (mounted) setState(() {});
    } catch (e) {
      _hasError = true;
      _errorMessage = '视频加载失败: ${e.toString()}';
      _isLoading = false;
      if (mounted) setState(() {});
    }
  }

  void updateVideoPlayback(bool isPaused) {
    _desiredPlay = !isPaused;
    if (_videoController.value.isInitialized) {
      if (isPaused) {
        _videoController.pause();
      } else {
        _videoController.play();
      }
    }
    // 若尚未初始化完成，_desiredPlay 会在初始化结束时通过 autoPlay 生效
  }

  void updateVideoSource(VideoModel newVideo) {
    _videoController.dispose();
    _chewieController?.dispose();
    _initVideoPlayer(newVideo, false);
  }

  void retryLoadVideo() {
    _hasError = false;
    _errorMessage = '';
    _initVideoPlayer((context as dynamic).widget.video, false);
  }

  void disposeVideoPlayer() {
    _videoController.dispose();
    _chewieController?.dispose();
  }
}