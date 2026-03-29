// lib/pages/video_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application/data/mock_videos.dart';
import 'package:flutter_application/widgets/video_item.dart';
import 'package:flutter_application/widgets/video_actions.dart';
import 'package:flutter_application/models/video_state.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final Map<String, VideoState> _videoStates = {};

  @override
  void initState() {
    super.initState();
    // 初始化视频状态
    for (var video in mockVideos) {
      _videoStates[video.id] = VideoState(
        isLiked: false,
        likeCount: video.likeCount,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentVideo = mockVideos[_currentIndex];
    final currentState = _videoStates[currentVideo.id]!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 视频列表
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: mockVideos.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final video = mockVideos[index];
              final state = _videoStates[video.id]!;
              return VideoItem(
                video: video,
                isPaused: index != _currentIndex,
                isLiked: state.isLiked,
                currentLikeCount: state.likeCount,
                onDoubleTap: () => _handleDoubleTap(video.id),
              );
            },
          ),

          // 固定在屏幕右侧的按钮
          Positioned(
            right: 16,
            top: MediaQuery.of(context).size.height * 0.39,
            child: VideoActions(
              likeCount: currentState.likeCount,
              isLiked: currentState.isLiked,
              onLike: () => _toggleLike(currentVideo.id),
              onComment: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('评论功能开发中')),
                );
              },
              onCollect: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('收藏成功')),
                );
              },
              onShare: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('分享功能开发中')),
                );
              },
              onMusic: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('音乐功能开发中')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleDoubleTap(String videoId) {
    _toggleLike(videoId);
  }

  void _toggleLike(String videoId) {
    setState(() {
      final state = _videoStates[videoId]!;
      state.isLiked = !state.isLiked;
      if (state.isLiked) {
        state.likeCount++;
      } else {
        state.likeCount--;
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}