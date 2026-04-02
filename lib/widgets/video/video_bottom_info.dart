import 'package:flutter/material.dart';
import '../../common/funny_colors.dart';

// 動画下部の投稿者名・説明・ハッシュタグを表示する。
// video_item.dart の Stack 層面最下部に Positioned で配置される。
// showComments=true のときは非表示となる。

/// 動画下部の投稿者情報・コンテンツ記述ウィジェット。
class VideoBottomInfo extends StatelessWidget {
  /// 投稿者名（先頭に @ を付けて表示）
  final String authorName;
  /// 動画説明文
  final String description;
  /// おすすめ件数（現在はレイアウトにのみ使用）
  final int recommendCount;
  /// ハッシュタグ一覧
  final List<String> keywords;
  const VideoBottomInfo({
    super.key,
    required this.authorName,
    required this.description,
    required this.recommendCount,
    required this.keywords,
  });

  @override
  // 投稿者名、ハッシュタグ、説明文を下部に重ねて表示する。
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

        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
              decoration: BoxDecoration(
                color: FunnyColors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
