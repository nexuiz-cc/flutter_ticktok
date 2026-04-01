import 'package:flutter/material.dart';
import '../common/funny_colors.dart';
import '../data/mock_messages.dart';
import 'chat_detail_page.dart';

// ストーリー行とメッセージ一覧を表示する画面。

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
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
            _buildTopBar(context, textColor),
            _buildStoryRow(context, isDark),
            Divider(height: 1, color: dividerColor),
            Expanded(
              child: ListView.builder(
                itemCount: mockMessages.length,
                itemBuilder: (context, index) {
                  return _buildMessageItem(
                    context,
                    mockMessages[index],
                    textColor,
                    isDark,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildStoryRow(BuildContext context, bool isDark) {
    final storyTextColor = isDark ? Colors.white70 : Colors.black87;
    final storyBorderColor = isDark
        ? const Color(0xFF444444)
        : const Color(0xFFEEEEEE);
    final storyFallbackBg = isDark
        ? const Color(0xFF333333)
        : const Color(0xFFEEEEEE);
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
                              color: isDark
                                  ? const Color(0xFF1A1A1A)
                                  : Colors.white,
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

  Widget _buildMessageItem(
    BuildContext context,
    MessageItem msg,
    Color textColor,
    bool isDark,
  ) {
    final subTextColor = isDark ? Colors.grey[400]! : Colors.grey;

    return InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => ChatDetailPage(message: msg)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Stack(
              children: [
                _buildAvatar(msg),
                if (msg.isLive)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 16,
                      decoration: const BoxDecoration(
                        color: FunnyColors.red,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'ライブ中',
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          msg.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (msg.isMuted)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            Icons.notifications_off_outlined,
                            size: 13,
                            color: subTextColor,
                          ),
                        ),
                      Text(
                        msg.time,
                        style: TextStyle(fontSize: 12, color: subTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(child: _buildLastMessage(msg, subTextColor)),
                      if (msg.hasUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: FunnyColors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(MessageItem msg) {
    if (msg.isInteraction) {
      return Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: msg.avatarColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.forum_rounded, color: Colors.white, size: 26),
      );
    }
    return SizedBox(
      width: 52,
      height: 52,
      child: ClipOval(
        child: msg.avatarUrl.isNotEmpty
            ? Image.network(
                msg.avatarUrl,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _fallbackAvatar(msg),
              )
            : _fallbackAvatar(msg),
      ),
    );
  }

  Widget _fallbackAvatar(MessageItem msg) {
    return Container(
      width: 52,
      height: 52,
      color: msg.avatarColor,
      child: const Icon(Icons.person, color: Colors.white, size: 28),
    );
  }

  Widget _buildLastMessage(MessageItem msg, Color subColor) {
    if (msg.isMentioned) {
      final parts = msg.lastMessage.split(']');
      final tag = parts.isNotEmpty ? '${parts[0]}]' : '';
      final rest = parts.length > 1 ? parts[1] : '';
      return RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          children: [
            TextSpan(
              text: tag,
              style: const TextStyle(color: FunnyColors.red, fontSize: 13),
            ),
            TextSpan(
              text: rest,
              style: TextStyle(color: subColor, fontSize: 13),
            ),
          ],
        ),
      );
    }
    return Text(
      msg.lastMessage,
      style: TextStyle(color: subColor, fontSize: 13),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
