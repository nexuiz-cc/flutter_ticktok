import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_application/common/funny_colors.dart';
import 'package:chewie/chewie.dart';
import '../models/video_model.dart';
import 'video_bottom_info.dart';
import 'video_loading_error.dart';
import 'video_tab_manager.dart';
import 'video_player_manager.dart';
import 'video_animation_manager.dart';
import 'video_gesture_manager.dart';
import 'video_state_manager.dart';

// 1本の動画セルに再生・情報・操作UIをまとめる。

class VideoItem extends StatefulWidget {
  final VideoModel video;
  final bool isPaused;
  final bool isLiked;
  final int currentLikeCount;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onSearchTap;
  final bool showComments;

  const VideoItem({
    super.key,
    required this.video,
    this.isPaused = false,
    this.isLiked = false,
    this.currentLikeCount = 0,
    this.onDoubleTap,
    this.onSearchTap,
    this.showComments = false,
  });

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem>
    with
        SingleTickerProviderStateMixin,
        VideoTabManager<VideoItem>,
        VideoPlayerManager,
        VideoAnimationManager,
        VideoGestureManager,
        VideoStateManager {
  @override
  // タブ、いいね状態、アニメーション、動画再生をまとめて初期化する。
  void initState() {
    super.initState();
    initTabs();
    initStateValues(widget.isLiked, widget.currentLikeCount);
    initAnimations(this);
    initVideoPlayer(widget.video, widget.isPaused);
  }

  @override
  // 外から渡される動画と再生状態の変化を反映する。
  void didUpdateWidget(covariant VideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    updateVideoPlayback(widget.isPaused);
    updateLikeState(widget.isLiked, widget.currentLikeCount);

    if (oldWidget.video.videoUrl != widget.video.videoUrl) {
      updateVideoSource(widget.video);
    }
  }

  @override
  // 動画プレイヤーとアニメーション資源を破棄する。
  void dispose() {
    disposeVideoPlayer();
    disposeAnimations();
    super.dispose();
  }

  @override
  // 動画本体とオーバーレイUIを合成して1セルを描画する。
  Widget build(BuildContext context) {
    if (hasError) {
      return VideoErrorView(
        errorMessage: errorMessage,
        onRetry: retryLoadVideo,
      );
    }

    if (isLoading || chewieController == null) {
      return const VideoLoadingView();
    }

    return GestureDetector(
      onDoubleTap: () {
        handleDoubleTap(widget.onDoubleTap);
        handleDoubleTapLike();
      },
      child: Scaffold(
        backgroundColor: FunnyColors.black,
        extendBodyBehindAppBar: true,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final double screenWidth = constraints.maxWidth;
            final double screenHeight = constraints.maxHeight;
            final double statusBarHeight = MediaQuery.of(context).padding.top;
            final double tabsBottom = statusBarHeight + 8 + 48 + 8;
            final double videoAspectRatio =
                videoController.value.aspectRatio > 0
                ? videoController.value.aspectRatio
                : 16.0 / 9.0;
            final double videoPreviewWidth = screenWidth * 0.6;
            final double videoPreviewHeight = min(
              videoPreviewWidth / videoAspectRatio,
              screenHeight * 0.35,
            );
            final double videoPreviewLeft = screenWidth * 0.2;
            final double videoPreviewTop = tabsBottom;

            return Stack(
              children: [
                // コメント表示中は縮小プレビューに切り替える動画領域。
                if (!widget.showComments)
                  Positioned.fill(
                    child: selectedTab == 0
                        ? Chewie(controller: chewieController!)
                        : const Center(
                            child: Text(
                              '開発中',
                              style: TextStyle(
                                color: FunnyColors.unicornWhite,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  )
                else
                  Positioned(
                    top: videoPreviewTop,
                    left: videoPreviewLeft,
                    width: videoPreviewWidth,
                    height: videoPreviewHeight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          Chewie(controller: chewieController!),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.45),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // 動画を全画面表示へ切り替えるボタン。
                if (selectedTab == 0 && !widget.showComments)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 228,
                    child: Center(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: FunnyColors.ironGrey,
                          foregroundColor: FunnyColors.white,
                          side: const BorderSide(
                            color: FunnyColors.grey,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 0,
                          ),
                        ),
                        icon: const Icon(
                          Icons.fullscreen,
                          color: FunnyColors.white,
                        ),
                        label: const Text(
                          '全画面で見る',
                          style: TextStyle(
                            color: FunnyColors.white,
                            fontSize: 12.0,
                          ),
                        ),
                        onPressed: () {
                          chewieController?.enterFullScreen();
                        },
                      ),
                    ),
                  ),

                // ダブルタップ時のハートアニメーション。
                if (showLikeAnimation)
                  Positioned.fill(
                    child: Center(
                      child: FadeTransition(
                        opacity: opacityAnimation,
                        child: ScaleTransition(
                          scale: scaleAnimation,
                          child: const Icon(
                            Icons.favorite,
                            color: FunnyColors.red,
                            size: 100,
                          ),
                        ),
                      ),
                    ),
                  ),

                // 動画下部の投稿者情報と説明文。
                if (selectedTab == 0 && !widget.showComments)
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: VideoBottomInfo(
                      authorName: widget.video.authorName,
                      description: widget.video.description,
                      recommendCount: widget.video.recommendCount,
                      keywords: widget.video.keywords,
                    ),
                  ),

                // 上部のメニュー、並び替えタブ、検索ボタン。
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 8,
                    ),
                    height: 48 + MediaQuery.of(context).padding.top + 8,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Icon(
                            Icons.menu,
                            color: FunnyColors.white,
                            size: 28,
                          ),
                        ),
                        Expanded(
                          child: ReorderableListView.builder(
                            scrollDirection: Axis.horizontal,
                            buildDefaultDragHandles: true,
                            padding: EdgeInsets.zero,
                            itemCount: tabs.length,
                            onReorder: onTabReorder,
                            itemBuilder: (context, index) {
                              final isSelected = index == selectedTab;
                              return Padding(
                                key: ValueKey(tabs[index]),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 8,
                                ),
                                child: GestureDetector(
                                  onTap: () => onTabTap(index),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      tabs[index],
                                      style: TextStyle(
                                        color: isSelected
                                            ? FunnyColors.white
                                            : FunnyColors.grey,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: IconButton(
                            onPressed: widget.onSearchTap,
                            icon: const Icon(
                              Icons.search,
                              color: FunnyColors.white,
                              size: 24,
                            ),
                            splashRadius: 22,
                            tooltip: '検索',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
