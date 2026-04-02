import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/mock_messages.dart';

// 1つのメッセージ(チャットバブル)を表示するウィジェット。
// isSystem=true → 日時テキストを中央表示するシステムメッセージ。
// isMe=true   → 青バブルを右寄せで表示する自分の発言。
// isMe=false  → グレーバブルをアバター付きで左寄せ。
// imagePath がある場合は画像バブルを表示する。

/// チャット履歴の 1メッセージバブルウィジェット。
class ChatBubble extends StatelessWidget {
  /// メッセージデータ
  final ChatMessage chat;
  /// 相手のアバター画像 URL（空文字ならフォールバック）
  final String contactAvatarUrl;
  /// アバターフォールバック時の背景色
  final Color contactAvatarColor;
  /// 相手バブルの背景色（テーマにより変わる）
  final Color bubbleBgOther;
  /// 相手バブルの文字色
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
