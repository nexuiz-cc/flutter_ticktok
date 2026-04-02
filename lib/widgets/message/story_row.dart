import 'package:flutter/material.dart';
import '../../common/funny_colors.dart';
import '../../data/mock_messages.dart';

// メッセージ画面上部の横スクロールストーリー一覧を描画する。
// 最初のアイテムは「デイリー」（ストーリー追加ボタン）、その後フォロワーのストーリー。
// 未読ストーリーは赤色ボーダーで泳起する。

/// ストーリー一覧を横並びに表示するウィジェット。
class StoryRow extends StatelessWidget {
  /// ダークテーマかどうか（アイコン・ボーダー色の切り替え）
  final bool isDark;

  const StoryRow({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final storyTextColor = isDark ? Colors.white70 : Colors.black87;
    final storyBorderColor =
        isDark ? const Color(0xFF444444) : const Color(0xFFEEEEEE);
    final storyFallbackBg =
        isDark ? const Color(0xFF333333) : const Color(0xFFEEEEEE);
    final storyIconColor = isDark ? Colors.grey[400]! : Colors.grey;

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: mockStories.length,
        itemBuilder: (context, index) {
          final story = mockStories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: story.hasNewStory
                            ? Border.all(color: FunnyColors.red, width: 2)
                            : Border.all(color: storyBorderColor, width: 1),
                      ),
                      child: ClipOval(
                        child: story.isSettings
                            ? Container(
                                color: storyFallbackBg,
                                child: Icon(
                                  Icons.settings,
                                  color: storyIconColor,
                                  size: 28,
                                ),
                              )
                            : story.avatarUrl.isNotEmpty
                            ? Image.network(
                                story.avatarUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  color: storyFallbackBg,
                                  child: Icon(
                                    Icons.person,
                                    color: storyIconColor,
                                    size: 28,
                                  ),
                                ),
                              )
                            : Container(
                                color: storyFallbackBg,
                                child: Icon(
                                  Icons.person,
                                  color: storyIconColor,
                                  size: 28,
                                ),
                              ),
                      ),
                    ),
                    if (story.isAddStory)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: FunnyColors.red,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  isDark ? const Color(0xFF1A1A1A) : Colors.white,
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 11,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  story.name,
                  style: TextStyle(fontSize: 12, color: storyTextColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
