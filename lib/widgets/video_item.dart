import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application/common/funny_colors.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../models/video_model.dart';

class VideoItem extends StatefulWidget {
  final VideoModel video;
  final bool isPaused;
  final bool isLiked;
  final int currentLikeCount;
  final VoidCallback? onDoubleTap;
  
  const VideoItem({
    super.key,
    required this.video,
    this.isPaused = false,
    this.isLiked = false,
    this.currentLikeCount = 0,
    this.onDoubleTap, 
  });

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> with SingleTickerProviderStateMixin {
  // 可拖拽Tab标签
  List<String> _tabs = [
    '经验', '精选', '热点', '同城', '关注', '直播', '商城', '推荐'
  ];
  int _selectedTab = 0;
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isLiked = false;
  bool _showLikeAnimation = false;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  int _currentLikeCount = 0;
  bool _isDoubleTapHandled = false; // 标记双击是否已处理

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _currentLikeCount = widget.currentLikeCount;
    _initAnimations();
    _initVideoPlayer();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
  }

  Future<void> _initVideoPlayer() async {
    try {
      _isLoading = true;
      _hasError = false;
      if (mounted) setState(() {});

      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.video.videoUrl),
      );

      // 设置超时
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
        autoPlay: !widget.isPaused,
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
          playedColor: FunnyColors.watermelonRed,
          handleColor: Colors.red,
          backgroundColor: FunnyColors.grey,
          bufferedColor: FunnyColors.grey,
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

  void _handleDoubleTap() {
    if (_isDoubleTapHandled) return; // 防止重复处理
    
    _isDoubleTapHandled = true;
    
    // 触发动画
    _showLikeAnimation = true;
    _animationController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _showLikeAnimation = false;
            _isDoubleTapHandled = false;
          });
        }
      });
    });
    
    // 立即更新本地状态，提供即时反馈
    setState(() {
      _isLiked = true; // 双击总是点赞
      _currentLikeCount++; // 增加点赞数
    });
    
    // 调用父组件的回调
    if (widget.onDoubleTap != null) {
      widget.onDoubleTap!(); // 这会触发父组件更新状态
    }
  }

  void _retryLoadVideo() {
    _hasError = false;
    _errorMessage = '';
    _initVideoPlayer();
  }

  @override
  void didUpdateWidget(covariant VideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // 暂停/播放状态变化
    if (oldWidget.isPaused != widget.isPaused && _videoController.value.isInitialized) {
      if (widget.isPaused) {
        _videoController.pause();
      } else {
        _videoController.play();
      }
    }
    
    // 点赞状态同步
    if (oldWidget.isLiked != widget.isLiked) {
      _isLiked = widget.isLiked;
    }
    
    // 点赞数同步
    if (oldWidget.currentLikeCount != widget.currentLikeCount) {
      _currentLikeCount = widget.currentLikeCount;
    }
    
    // 视频源变化
    if (oldWidget.video.videoUrl != widget.video.videoUrl) {
      _videoController.dispose();
      _chewieController?.dispose();
      _initVideoPlayer();
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      if (_hasError) {
    return _ErrorView(errorMessage: _errorMessage, onRetry: _retryLoadVideo);
  }

  if (_isLoading || _chewieController == null) {
    return const _LoadingView();
  }

  return GestureDetector(
    onDoubleTap: _handleDoubleTap,
    child: Scaffold(
      backgroundColor: FunnyColors.black,
      body: Column(
        children: [
          // 顶部 tabs 行，紧贴屏幕顶部
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8),
            color: FunnyColors.black,
            height: 48 + MediaQuery.of(context).padding.top + 8,
            child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Icon(Icons.menu, color: FunnyColors.white, size: 28),
                  ),
                  Expanded(
                    child: ReorderableListView.builder(
                      scrollDirection: Axis.horizontal,
                      buildDefaultDragHandles: true,
                      padding: EdgeInsets.zero,
                      itemCount: _tabs.length,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) newIndex--;
                          final item = _tabs.removeAt(oldIndex);
                          _tabs.insert(newIndex, item);
                          if (_selectedTab == oldIndex) {
                            _selectedTab = newIndex;
                          } else if (_selectedTab == newIndex) {
                            _selectedTab = oldIndex;
                          }
                        });
                      },
                      itemBuilder: (context, index) {
                        final selected = index == _selectedTab;
                        return Padding(
                          key: ValueKey(_tabs[index]),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedTab = index;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                color: FunnyColors.black,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                _tabs[index],
                                style: TextStyle(
                                  color: selected ? FunnyColors.white : FunnyColors.grey,
                                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
            ),
          ),

          // 内容区（视频或占位）+ 浮动层
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 视频或开发中占位
                _selectedTab == 0
                    ? Chewie(controller: _chewieController!)
                    : const Center(
                        child: Text(
                          '开发中',
                          style: TextStyle(
                            color: FunnyColors.unicornWhite,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                // 全屏按钮（仅经验tab显示）
                if (_selectedTab == 0)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 200,
                    child: Center(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: FunnyColors.ironGrey,
                          foregroundColor: FunnyColors.white,
                          side: const BorderSide(color: FunnyColors.grey, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                        ),
                        icon: const Icon(Icons.fullscreen, color: FunnyColors.white),
                        label: const Text('全屏观看', style: TextStyle(color: FunnyColors.white, fontSize: 12.0)),
                        onPressed: () {
                          _chewieController?.enterFullScreen();
                        },
                      ),
                    ),
                  ),

                // 双击爱心动画
                if (_showLikeAnimation)
                  Positioned.fill(
                    child: Center(
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: const Icon(
                            Icons.favorite,
                            color: FunnyColors.red,
                            size: 100,
                          ),
                        ),
                      ),
                    ),
                  ),

                // 底部信息区（仅经验tab显示）
                if (_selectedTab == 0)
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: _VideoBottomInfo(
                      authorName: widget.video.authorName,
                      description: widget.video.description,
                      recommendCount: widget.video.recommendCount,
                      keywords: widget.video.keywords,
                    ),
                  ),
              ],        // Stack children
            ),          // Stack
          ),            // Expanded
        ],              // Column children
      ),                // Column
    ),                  // Scaffold
  );                    // GestureDetector
  }

}

// 顶部标题
class _VideoTitle extends StatelessWidget {
  final String title;
  const _VideoTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.yellow,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            blurRadius: 4.0,
            color: Colors.black,
            offset: Offset(2.0, 2.0),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

// 底部信息区
class _VideoBottomInfo extends StatelessWidget {
  final String authorName;
  final String description;
  final int recommendCount;
  final List<String> keywords;
  const _VideoBottomInfo({
    required this.authorName,
    required this.description,
    required this.recommendCount,
    required this.keywords,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '@$authorName',
          style: const TextStyle(color: FunnyColors.unicornWhite, fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (keywords.isNotEmpty)
          Text(
            keywords.map((k) => '#$k').join(' '),
            style: const TextStyle(color: FunnyColors.skyBlue, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        Text(
          description,
          style: const TextStyle(color: FunnyColors.unicornWhite, fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: FunnyColors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// 加载视图
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: FunnyColors.pandaBlack,
      body: Center(child: CircularProgressIndicator(color: FunnyColors.unicornWhite)),
    );
  }
}

// 错误视图
class _ErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;
  const _ErrorView({required this.errorMessage, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FunnyColors.pandaBlack,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: FunnyColors.unicornWhite, size: 60),
            const SizedBox(height: 20),
            const Text(
              '视频加载失败',
              style: TextStyle(color: FunnyColors.unicornWhite, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              errorMessage,
              style: const TextStyle(color: FunnyColors.ghostGrey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: FunnyColors.tomatoSauce,
                foregroundColor: FunnyColors.unicornWhite,
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
              ),
              child: const Text('重新加载'),
            ),
          ],
        ),
      ),
    );
  }
}