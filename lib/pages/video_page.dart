import 'package:flutter/material.dart';
import 'package:flutter_application/common/funny_colors.dart';
import 'package:flutter_application/common/video_search.dart';
import 'package:flutter_application/data/mock_videos.dart';
import 'package:flutter_application/models/video_model.dart';
import 'package:flutter_application/widgets/video/video_item.dart';
import 'package:flutter_application/widgets/video/video_actions.dart';
import 'package:flutter_application/widgets/comment/comment_bottom_sheet.dart';
import 'package:flutter_application/models/video_state.dart';
import 'package:flutter_application/pages/video_search_page.dart';

// 縦スワイプの動画フィードと検索結果反映を管理する画面。

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final Map<String, VideoState> _videoStates = {};
  bool _showingComments = false;
  bool _commentsFullscreen = false;
  late final List<VideoModel> _allVideos;
  late List<VideoModel> _visibleVideos;
  String _activeQuery = '';

  @override
  // 動画一覧と各動画のUI状態を初期化する。
  void initState() {
    super.initState();
    _allVideos = List<VideoModel>.from(mockVideos);
    _visibleVideos = List<VideoModel>.from(_allVideos);
    for (var video in _allVideos) {
      _videoStates[video.id] = VideoState(
        isLiked: false,
        likeCount: video.likeCount,
      );
    }
  }

  @override
  // 動画本体、右側アクション、コメントシートを重ねて表示する。
  Widget build(BuildContext context) {
    if (_visibleVideos.isEmpty) {
      return _buildEmptySearchState();
    }

    final currentVideo = _visibleVideos[_currentIndex % _visibleVideos.length];
    final currentState = _videoStates[currentVideo.id]!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 縦スワイプで切り替わる動画フィード。
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: null, // 無限スクロール
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                _showingComments = false;
                _commentsFullscreen = false;
              });
            },
            itemBuilder: (context, index) {
              final actualIndex = index % _visibleVideos.length;
              final video = _visibleVideos[actualIndex];
              final state = _videoStates[video.id]!;
              return VideoItem(
                video: video,
                isPaused: index != _currentIndex,
                isLiked: state.isLiked,
                currentLikeCount: state.likeCount,
                onDoubleTap: () => _handleDoubleTap(video.id),
                onSearchTap: _openSearch,
                showComments: _showingComments && index == _currentIndex,
              );
            },
          ),

          if (!_showingComments)
            // 現在の動画に対する右側アクション群。
            Positioned(
              right: 16,
              bottom: 24,
              child: VideoActions(
                likeCount: currentState.likeCount,
                isLiked: currentState.isLiked,
                authorName: currentVideo.authorName,
                authorAvatar: currentVideo.authorAvatar,
                onLike: () => _toggleLike(currentVideo.id),
                onComment: () => setState(() => _showingComments = true),
                onCollect: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('開発中')));
                },
                onShare: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('開発中')));
                },
                onMusic: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('開発中')));
                },
              ),
            ),

          if (_showingComments)
            // 動画上に重ねるコメントボトムシート。
            Positioned(
              top: _commentsFullscreen
                  ? MediaQuery.of(context).padding.top
                  : () {
                      final size = MediaQuery.of(context).size;
                      final statusBarHeight = MediaQuery.of(
                        context,
                      ).padding.top;
                      final tabsHeight = statusBarHeight + 64.0;
                      final videoPreviewHeight = size.height * 0.35;
                      return tabsHeight + videoPreviewHeight - 170;
                    }(),
              left: 0,
              right: 0,
              bottom: 0,
              child: CommentBottomSheet(
                video: currentVideo,
                onClose: () => setState(() {
                  _showingComments = false;
                  _commentsFullscreen = false;
                }),
                onFullscreen: () =>
                    setState(() => _commentsFullscreen = !_commentsFullscreen),
              ),
            ),
        ],
      ),
    );
  }

  // ダブルタップ時に現在の動画のいいね状態を更新する。
  void _handleDoubleTap(String videoId) {
    _toggleLike(videoId);
  }

  // いいね状態と表示件数をトグルする。
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

  // 検索画面を開いて、戻り値のクエリを反映する。
  Future<void> _openSearch() async {
    final query = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) =>
            VideoSearchPage(videos: _allVideos, initialQuery: _activeQuery),
      ),
    );

    if (!mounted || query == null) {
      return;
    }

    _applySearch(query);
  }

  // クエリに応じて表示対象を絞り込み、表示位置を先頭に戻す。
  void _applySearch(String query) {
    final normalizedQuery = query.trim();
    final filteredVideos = filterVideosByQuery(_allVideos, normalizedQuery);

    setState(() {
      _activeQuery = normalizedQuery;
      _visibleVideos = filteredVideos;
      _currentIndex = 0;
      _showingComments = false;
      _commentsFullscreen = false;
    });

    if (_pageController.hasClients && filteredVideos.isNotEmpty) {
      _pageController.jumpToPage(0);
    }
  }

  // 検索結果が空になったときの案内画面を描画する。
  Widget _buildEmptySearchState() {
    return Scaffold(
      backgroundColor: FunnyColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 再検索用の検索ボタン。
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: _openSearch,
                  icon: const Icon(Icons.search, color: FunnyColors.white),
                  tooltip: '検索',
                ),
              ),
              const Spacer(),
              // 結果なしメッセージ。
              const Text(
                '該当する内容が見つかりません',
                style: TextStyle(
                  color: FunnyColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _activeQuery.isEmpty
                    ? '表示できる動画がありません。'
                    : '「$_activeQuery」に一致するキーワードや説明がありません。',
                style: const TextStyle(
                  color: FunnyColors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              // 再検索と全件表示への導線。
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _openSearch,
                  style: FilledButton.styleFrom(
                    backgroundColor: FunnyColors.white,
                    foregroundColor: FunnyColors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.search),
                  label: const Text('再検索'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _applySearch(''),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: FunnyColors.white,
                    side: const BorderSide(color: FunnyColors.white70),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('検索をクリアして全件表示'),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // フィード破棄時にページコントローラを解放する。
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
