import 'package:flutter/material.dart';
import 'package:flutter_application/common/video_search.dart';
import 'package:flutter_application/models/video_model.dart';

// キーワード入力と結果一覧を表示する検索画面。

class VideoSearchPage extends StatefulWidget {
  final List<VideoModel> videos;
  final String initialQuery;

  const VideoSearchPage({
    super.key,
    required this.videos,
    this.initialQuery = '',
  });

  @override
  State<VideoSearchPage> createState() => _VideoSearchPageState();
}

class _VideoSearchPageState extends State<VideoSearchPage> {
  late final TextEditingController _searchController;
  late final List<String> _suggestedKeywords;
  String _query = '';

  List<VideoModel> get _filteredVideos =>
      filterVideosByQuery(widget.videos, _query);

  @override
  // 初期クエリと候補キーワード一覧を準備する。
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery)
      ..addListener(_handleQueryChanged);
    _query = widget.initialQuery;
    _suggestedKeywords = widget.videos
        .expand((video) => video.keywords)
        .map((keyword) => keyword.trim())
        .where((keyword) => keyword.isNotEmpty)
        .toSet()
        .take(8)
        .toList();
  }

  @override
  // 検索入力の購読を解除してコントローラを破棄する。
  void dispose() {
    _searchController
      ..removeListener(_handleQueryChanged)
      ..dispose();
    super.dispose();
  }

  // 入力欄の変化をそのままフィルタ条件へ反映する。
  void _handleQueryChanged() {
    setState(() {
      _query = _searchController.text;
    });
  }

  // 現在のクエリを親画面へ返して検索結果を確定する。
  void _submitSearch([String? value]) {
    Navigator.of(context).pop((value ?? _searchController.text).trim());
  }

  // 候補キーワードを入力欄へ即時反映する。
  void _useKeyword(String keyword) {
    _searchController.value = TextEditingValue(
      text: keyword,
      selection: TextSelection.collapsed(offset: keyword.length),
    );
  }

  @override
  // 検索入力、候補、結果グリッドをまとめて描画する。
  Widget build(BuildContext context) {
    final filteredVideos = _filteredVideos;
    final trimmedQuery = _query.trim();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 72,
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        title: SizedBox(
          height: 42,
          child: TextField(
            controller: _searchController,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onSubmitted: _submitSearch,
            decoration: InputDecoration(
              hintText: 'キーワードまたは説明を検索',
              filled: true,
              fillColor: const Color(0xFFF3F4F6),
              contentPadding: EdgeInsets.zero,
              prefixIcon: const Icon(Icons.search, color: Colors.black54),
              suffixIcon: trimmedQuery.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () => _searchController.clear(),
                      icon: const Icon(Icons.close, size: 18),
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => _submitSearch(), child: const Text('検索')),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 検索状態に応じたタイトル表示。
              Text(
                trimmedQuery.isEmpty
                    ? 'キーワードと説明で検索できます'
                    : '${filteredVideos.length} 件の内容が見つかりました',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                trimmedQuery.isEmpty
                    ? '検索語を入力すると、現在の動画一覧をその結果で絞り込みます。'
                    : '下のボタンを押すと、この結果で現在の動画一覧を置き換えます。',
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 16),
              if (trimmedQuery.isEmpty) ...[
                // よく使う検索キーワード一覧。
                const Text(
                  'おすすめのキーワード',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _suggestedKeywords
                      .map(
                        (keyword) => ActionChip(
                          label: Text(keyword),
                          onPressed: () => _useKeyword(keyword),
                        ),
                      )
                      .toList(),
                ),
              ] else ...[
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(0, 0.06),
                        end: Offset.zero,
                      ).animate(animation);

                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: filteredVideos.isEmpty
                        ? const _SearchEmptyState(key: ValueKey('empty-state'))
                        : GridView.builder(
                            // 2列カードで検索結果を表示する。
                            key: ValueKey(
                              'results-${trimmedQuery.toLowerCase()}-${filteredVideos.length}',
                            ),
                            padding: const EdgeInsets.only(top: 4, bottom: 4),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 14,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 0.68,
                                ),
                            itemCount: filteredVideos.length,
                            itemBuilder: (context, index) {
                              final video = filteredVideos[index];
                              return _AnimatedSearchResultCard(
                                key: ValueKey(
                                  'card-${video.id}-${trimmedQuery.toLowerCase()}',
                                ),
                                video: video,
                                index: index,
                              );
                            },
                          ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _submitSearch(),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    trimmedQuery.isEmpty
                        ? 'すべての動画を表示'
                        : '${filteredVideos.length} 件の結果を表示',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchEmptyState extends StatelessWidget {
  const _SearchEmptyState({super.key});

  @override
  // 該当結果がない場合の案内表示。
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 44, color: Colors.black26),
          SizedBox(height: 12),
          Text(
            '該当する内容が見つかりません',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6),
          Text(
            '別のキーワードや説明の一部で試してください。',
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _AnimatedSearchResultCard extends StatelessWidget {
  final VideoModel video;
  final int index;

  const _AnimatedSearchResultCard({
    super.key,
    required this.video,
    required this.index,
  });

  @override
  // カードごとに少しずつ遅延させて出現アニメーションを付ける。
  Widget build(BuildContext context) {
    final animationDuration = Duration(milliseconds: 220 + (index % 6) * 50);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: animationDuration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 18),
            child: child,
          ),
        );
      },
      child: _SearchResultCard(video: video),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final VideoModel video;

  const _SearchResultCard({required this.video});

  @override
  // サムネイルと説明文を持つ検索結果カード。
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    child: Image.network(
                      video.coverUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFECEFF3), Color(0xFFD8DDE6)],
                            ),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFDEE3EA), Color(0xFFC6CDD8)],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: Colors.black38,
                              size: 28,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      video.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
            child: Text(
              video.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
                height: 1.35,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
