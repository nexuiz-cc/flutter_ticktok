import 'package:flutter/material.dart';
import '../common/funny_colors.dart';
import '../data/mock_messages.dart';
import '../widgets/message/story_row.dart';
import '../widgets/message/message_list_item.dart';

// ストーリー行とメッセージ一覧を表示する画面。

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  // 上部バー、ストーリー、メッセージ一覧で画面を構成する。
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final dividerColor = isDark
        ? const Color(0xFF333333)
        : const Color(0xFFEEEEEE);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // 画面上部のタイトルバー。
            _buildTopBar(context, textColor),
            // 横スクロールのストーリー一覧。
            StoryRow(isDark: isDark),
            Divider(height: 1, color: dividerColor),
            Expanded(
              // 会話一覧。
              child: ListView.builder(
                itemCount: mockMessages.length,
                itemBuilder: (context, index) {
                  return MessageListItem(
                    msg: mockMessages[index],
                    textColor: textColor,
                    isDark: isDark,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // メッセージ画面のヘッダー操作群を描画する。
  Widget _buildTopBar(BuildContext context, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Stack(
            children: [
              Icon(Icons.menu, size: 28, color: textColor),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: FunnyColors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: FunnyColors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.favorite, color: Colors.white, size: 18),
          ),
          Expanded(
            child: Center(
              child: Text(
                'メッセージ',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
          Icon(Icons.search, size: 26, color: textColor),
          const SizedBox(width: 16),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: textColor, width: 1.5),
            ),
            child: Icon(Icons.add, size: 16, color: textColor),
          ),
        ],
      ),
    );
  }

}
