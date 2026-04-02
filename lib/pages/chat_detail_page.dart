import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/mock_messages.dart';
import '../widgets/chat/chat_bubble.dart';
import '../widgets/chat/chat_more_panel.dart';

// 個別チャットの会話表示と送信操作を担当する画面。

class ChatDetailPage extends StatefulWidget {
  final MessageItem message;

  const ChatDetailPage({super.key, required this.message});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _picker = ImagePicker();
  List<ChatMessage> _chats = [];
  bool _showMorePanel = false;

  static const _quickEmojis = ['👋', '🙏', '😊', '😂', '❤️', '👍', '🔥', '😍'];



  @override
  // 対象会話の履歴を読み込み、初回表示時に末尾へスクロールする。
  void initState() {
    super.initState();
    _chats = List.from(
      mockChatHistory[widget.message.id] ??
          [
            ChatMessage(
              id: 'sys_init',
              content: '会話を始めましょう！',
              isMe: false,
              isSystem: true,
            ),
          ],
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }


  // 新しいメッセージが見えるようにリスト末尾まで移動する。
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // テキスト入力を送信し、一覧の末尾へ反映する。
  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _chats.add(
        ChatMessage(
          id: 'new_${DateTime.now().millisecondsSinceEpoch}',
          content: text,
          isMe: true,
          time: '',
        ),
      );
      _inputController.clear();
      _showMorePanel = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  // 追加アクションパネルの開閉を切り替える。
  void _toggleMorePanel() {
    setState(() {
      _showMorePanel = !_showMorePanel;
      if (_showMorePanel) {
        _focusNode.unfocus();
      }
    });
  }

  // カメラまたはギャラリーから画像を選んで送信する。
  Future<void> _pickImage(ImageSource source) async {
    setState(() => _showMorePanel = false);
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      if (file == null) return;
      setState(() {
        _chats.add(
          ChatMessage(
            id: 'img_${DateTime.now().millisecondsSinceEpoch}',
            content: '',
            isMe: true,
            imagePath: file.path,
          ),
        );
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('画像の取得に失敗しました: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final bubbleBgOther =
        isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF0F0F0);
    final bubbleTextOther = isDark ? Colors.white : Colors.black87;
    final topBarBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final topBarText = isDark ? Colors.white : Colors.black;
    final topBarSub = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final inputBg =
        isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF5F5F5);
    final inputText = isDark ? Colors.white : Colors.black87;
    final dividerColor =
        isDark ? const Color(0xFF333333) : const Color(0xFFEEEEEE);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // 上部バー
            Container(
              color: topBarBg,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 20, color: topBarText),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: ClipOval(
                      child: widget.message.avatarUrl.isNotEmpty
                          ? Image.network(
                              widget.message.avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                color: widget.message.avatarColor,
                                child: const Icon(Icons.person, color: Colors.white),
                              ),
                            )
                          : Container(
                              color: widget.message.avatarColor,
                              child: const Icon(Icons.person, color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.message.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: topBarText,
                          ),
                        ),
                        Text(
                          '昨日オンライン',
                          style: TextStyle(fontSize: 12, color: topBarSub),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.more_horiz, size: 26, color: topBarText),
                ],
              ),
            ),
            Divider(height: 1, color: dividerColor),

            // 会話リスト
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _chats.length,
                itemBuilder: (context, index) {
                  return ChatBubble(
                    chat: _chats[index],
                    contactAvatarUrl: widget.message.avatarUrl,
                    contactAvatarColor: widget.message.avatarColor,
                    bubbleBgOther: bubbleBgOther,
                    bubbleTextOther: bubbleTextOther,
                  );
                },
              ),
            ),

            // クイック絵文字バー
            Container(
              color: topBarBg,
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _quickEmojis.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _inputController.text += _quickEmojis[index];
                      _inputController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _inputController.text.length),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: Text(
                          _quickEmojis[index],
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(height: 1, color: dividerColor),

            // 入力バー
            Container(
              color: topBarBg,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.graphic_eq, color: topBarSub, size: 26),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (_showMorePanel) setState(() => _showMorePanel = false);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: inputBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: _inputController,
                          focusNode: _focusNode,
                          style: TextStyle(color: inputText, fontSize: 15),
                          decoration: InputDecoration(
                            hintText: 'メッセージを送る...',
                            hintStyle: TextStyle(color: topBarSub, fontSize: 15),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onTap: () => setState(() => _showMorePanel = false),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.sentiment_satisfied_alt_outlined,
                      color: topBarSub,
                      size: 26,
                    ),
                    onPressed: () {},
                  ),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _inputController,
                    builder: (_, value, _) {
                      final hasText = value.text.trim().isNotEmpty;
                      return GestureDetector(
                        onTap: hasText ? _sendMessage : _toggleMorePanel,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasText ? Colors.blue : Colors.transparent,
                            border: hasText
                                ? null
                                : Border.all(color: topBarSub, width: 1.5),
                          ),
                          child: Icon(
                            hasText
                                ? Icons.send
                                : (_showMorePanel ? Icons.close : Icons.add),
                            color: hasText ? Colors.white : topBarSub,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // 追加パネル
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              height: _showMorePanel ? 260 : 0,
              color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF2F2F2),
              child: _showMorePanel
                  ? ChatMorePanel(
                      isDark: isDark,
                      onActionTap: (index) {
                        if (index == 0) {
                          _pickImage(ChatMorePanel.sourceForIndex(0));
                        } else if (index == 1) {
                          _pickImage(ChatMorePanel.sourceForIndex(1));
                        }
                      },
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
