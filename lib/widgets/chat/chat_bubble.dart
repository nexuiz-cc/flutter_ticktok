import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/mock_messages.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage chat;
  final String contactAvatarUrl;
  final Color contactAvatarColor;
  final Color bubbleBgOther;
  final Color bubbleTextOther;

  const ChatBubble({
    super.key,
    required this.chat,
    required this.contactAvatarUrl,
    required this.contactAvatarColor,
    required this.bubbleBgOther,
    required this.bubbleTextOther,
  });

  Widget _fallbackAvatar(double size) {
    return Container(
      width: size,
      height: size,
      color: contactAvatarColor,
      child: const Icon(Icons.person, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (chat.isSystem) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Text(
            chat.content,
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final isMe = chat.isMe;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            SizedBox(
              width: 36,
              height: 36,
              child: ClipOval(
                child: contactAvatarUrl.isNotEmpty
                    ? Image.network(
                        contactAvatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _fallbackAvatar(36),
                      )
                    : _fallbackAvatar(36),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 260),
              padding: chat.imagePath != null
                  ? EdgeInsets.zero
                  : const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: chat.imagePath != null
                    ? Colors.transparent
                    : (isMe ? Colors.blue : bubbleBgOther),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 18),
                ),
              ),
              child: chat.imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: Radius.circular(isMe ? 18 : 4),
                        bottomRight: Radius.circular(isMe ? 4 : 18),
                      ),
                      child: Image.file(
                        File(chat.imagePath!),
                        fit: BoxFit.cover,
                        width: 200,
                      ),
                    )
                  : Text(
                      chat.content,
                      style: TextStyle(
                        color: isMe ? Colors.white : bubbleTextOther,
                        fontSize: 15,
                      ),
                    ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Center(
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
