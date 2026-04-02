import 'package:flutter/material.dart';
import '../../common/funny_colors.dart';
import '../../data/mock_messages.dart';
import '../../pages/chat_detail_page.dart';

class MessageListItem extends StatelessWidget {
  final MessageItem msg;
  final Color textColor;
  final bool isDark;

  const MessageListItem({
    super.key,
    required this.msg,
    required this.textColor,
    required this.isDark,
  });

  Widget _fallbackAvatar() {
    return Container(
      width: 52,
      height: 52,
      color: msg.avatarColor,
      child: const Icon(Icons.person, color: Colors.white, size: 28),
    );
  }

  Widget _buildAvatar() {
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
                errorBuilder: (_, _, _) => _fallbackAvatar(),
              )
            : _fallbackAvatar(),
      ),
    );
  }

  Widget _buildLastMessage(Color subColor) {
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

  @override
  Widget build(BuildContext context) {
    final subTextColor = isDark ? Colors.grey[400]! : Colors.grey;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ChatDetailPage(message: msg)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Stack(
              children: [
                _buildAvatar(),
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
                      Expanded(child: _buildLastMessage(subTextColor)),
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
}
