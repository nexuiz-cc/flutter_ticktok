import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../data/mock_messages.dart';

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

  // 快捷表情
  static const _quickEmojis = ['👋', '🙏', '😊', '😂', '❤️', '👍', '🔥', '😍'];

  // 功能面板项
  static const _moreActions = [
    {'icon': Icons.photo_library_outlined, 'label': '相册'},
    {'icon': Icons.camera_alt_outlined, 'label': '拍摄'},
    {'icon': Icons.videocam_outlined, 'label': '视频通话'},
    {'icon': Icons.weekend_outlined, 'label': '一起看'},
    {'icon': Icons.wallet_outlined, 'label': '红包'},
    {'icon': Icons.location_on_outlined, 'label': '位置'},
    {'icon': Icons.swap_horiz, 'label': '转账'},
    {'icon': Icons.contact_page_outlined, 'label': '个人名片'},
  ];

  @override
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

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _chats.add(ChatMessage(
        id: 'new_${DateTime.now().millisecondsSinceEpoch}',
        content: text,
        isMe: true,
        time: '',
      ));
      _inputController.clear();
      _showMorePanel = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _toggleMorePanel() {
    setState(() {
      _showMorePanel = !_showMorePanel;
      if (_showMorePanel) {
        _focusNode.unfocus();
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    // 关闭功能面板
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
        _chats.add(ChatMessage(
          id: 'img_${DateTime.now().millisecondsSinceEpoch}',
          content: '',
          isMe: true,
          imagePath: file.path,
        ));
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('画像の取得に失敗しました: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final bubbleBgOther = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF0F0F0);
    final bubbleTextOther = isDark ? Colors.white : Colors.black87;
    final topBarBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final topBarText = isDark ? Colors.white : Colors.black;
    final topBarSub = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final inputBg = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF5F5F5);
    final inputText = isDark ? Colors.white : Colors.black87;
    final dividerColor = isDark ? const Color(0xFF333333) : const Color(0xFFEEEEEE);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部栏
            Container(
              color: topBarBg,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 20, color: topBarText),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  _buildTopAvatar(),
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

            // 消息列表
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _chats.length,
                itemBuilder: (context, index) {
                  return _buildChatBubble(
                    _chats[index],
                    bubbleBgOther,
                    bubbleTextOther,
                  );
                },
              ),
            ),

            // 快捷表情条
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
                        child: Text(_quickEmojis[index], style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(height: 1, color: dividerColor),

            // 输入栏
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
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    icon: Icon(Icons.sentiment_satisfied_alt_outlined, color: topBarSub, size: 26),
                    onPressed: () {},
                  ),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _inputController,
                    builder: (_, value, __) {
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
                            hasText ? Icons.send : (_showMorePanel ? Icons.close : Icons.add),
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

            // 功能面板
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              height: _showMorePanel ? 260 : 0,
              color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF2F2F2),
              child: _showMorePanel ? _buildMorePanel(isDark) : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAvatar() {
    return SizedBox(
      width: 40,
      height: 40,
      child: ClipOval(
        child: widget.message.avatarUrl.isNotEmpty
            ? Image.network(
                widget.message.avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallbackAvatar(40),
              )
            : _fallbackAvatar(40),
      ),
    );
  }

  Widget _fallbackAvatar(double size) {
    return Container(
      width: size,
      height: size,
      color: widget.message.avatarColor,
      child: const Icon(Icons.person, color: Colors.white),
    );
  }

  Widget _buildChatBubble(
    ChatMessage chat,
    Color bubbleBgOther,
    Color bubbleTextOther,
  ) {
    // 系统消息
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
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            SizedBox(
              width: 36,
              height: 36,
              child: ClipOval(
                child: widget.message.avatarUrl.isNotEmpty
                    ? Image.network(
                        widget.message.avatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _fallbackAvatar(36),
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
            // 自己头像（用首字母代替）
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

  Widget _buildMorePanel(bool isDark) {
    final panelBg = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF2F2F2);
    final iconBg = isDark ? const Color(0xFF2C2C2C) : Colors.white;
    final iconColor = isDark ? Colors.white70 : const Color(0xFF444444);
    final labelColor = isDark ? Colors.grey[400]! : const Color(0xFF444444);

    return Container(
      color: panelBg,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          // 8宫格
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: _moreActions.length,
              itemBuilder: (context, index) {
                final action = _moreActions[index];
                return GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      _pickImage(ImageSource.gallery);
                    } else if (index == 1) {
                      _pickImage(ImageSource.camera);
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: iconBg,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          action['icon'] as IconData,
                          color: iconColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        action['label'] as String,
                        style: TextStyle(fontSize: 12, color: labelColor),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // 分页指示器
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 20,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[500] : Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 6,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
