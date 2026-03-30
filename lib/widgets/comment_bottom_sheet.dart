// 评论底部弹窗
import 'package:flutter/material.dart';
import '../models/video_model.dart';

// 评论数据模型
class CommentData {
  final String id;
  final String user;
  final Color avatarColor;
  final String content;
  final String time;
  final String location;
  int likes;
  bool isLiked;
  final List<CommentData> replies;

  CommentData({
    required this.id,
    required this.user,
    required this.avatarColor,
    required this.content,
    required this.time,
    this.location = '',
    this.likes = 0,
    this.isLiked = false,
    List<CommentData>? replies,
  }) : replies = replies ?? [];
}

class CommentBottomSheet extends StatefulWidget {
  final VideoModel video;
  final VoidCallback? onClose;
  final VoidCallback? onFullscreen;

  const CommentBottomSheet({super.key, required this.video, this.onClose, this.onFullscreen});

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  // 记录哪些评论/回复的展开状态
  final Set<String> _expandedIds = {};

  late List<CommentData> _comments;

  @override
  void initState() {
    super.initState();
    _comments = [
      CommentData(
        id: 'c1',
        user: '时言不是盐',
        avatarColor: const Color(0xFF546E7A),
        content: '谁教你这么配乐的啊😂',
        time: '5小时前',
        location: '内蒙古',
        likes: 502,
        replies: [
          CommentData(
            id: 'c1r1',
            user: '小鱼儿',
            avatarColor: const Color(0xFF1565C0),
            content: '哈哈哈太搞笑了',
            time: '4小时前',
            location: '广东',
            likes: 12,
            replies: [
              CommentData(
                id: 'c1r1r1',
                user: '路人甲',
                avatarColor: const Color(0xFF6A1B9A),
                content: '确实，笑死我了',
                time: '3小时前',
                likes: 5,
                replies: [
                  CommentData(
                    id: 'c1r1r1r1',
                    user: '吃瓜群众',
                    avatarColor: const Color(0xFF00695C),
                    content: '跟风+1',
                    time: '2小时前',
                    likes: 2,
                    replies: [
                      CommentData(
                        id: 'c1r1r1r1r1',
                        user: '最后一层',
                        avatarColor: const Color(0xFFE65100),
                        content: '到底了😂',
                        time: '1小时前',
                        likes: 1,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          CommentData(
            id: 'c1r2',
            user: '云朵朵',
            avatarColor: const Color(0xFF558B2F),
            content: '我也想学！',
            time: '4小时前',
            location: '浙江',
            likes: 8,
          ),
        ],
      ),
      CommentData(
        id: 'c2',
        user: '小光2199',
        avatarColor: const Color(0xFF43A047),
        content: '澡堂着火了赶紧跑啊',
        time: '1小时前',
        location: '北京',
        likes: 39,
        replies: [
          CommentData(
            id: 'c2r1',
            user: '笑死不偿命',
            avatarColor: const Color(0xFFD81B60),
            content: '哈哈哈哈哈哈哈',
            time: '1小时前',
            location: '上海',
            likes: 20,
            replies: [
              CommentData(
                id: 'c2r1r1',
                user: '旁观者清',
                avatarColor: const Color(0xFF0277BD),
                content: '你们太坏了😂',
                time: '1小时前',
                likes: 6,
              ),
            ],
          ),
          CommentData(
            id: 'c2r2',
            user: '消防员小李',
            avatarColor: const Color(0xFFBF360C),
            content: '专业建议：先报警',
            time: '30分钟前',
            likes: 15,
            replies: [
              CommentData(
                id: 'c2r2r1',
                user: '赞赞赞',
                avatarColor: const Color(0xFF37474F),
                content: '专业！',
                time: '20分钟前',
                likes: 3,
              ),
            ],
          ),
          CommentData(id: 'c2r3', user: '路人C', avatarColor: const Color(0xFF4E342E), content: '哈哈哈', time: '10分钟前', likes: 1),
          CommentData(id: 'c2r4', user: '路人D', avatarColor: const Color(0xFF546E7A), content: '太好笑了', time: '5分钟前', likes: 2),
          CommentData(id: 'c2r5', user: '路人E', avatarColor: const Color(0xFF1B5E20), content: '笑不活了', time: '刚刚', likes: 0),
        ],
      ),
      CommentData(
        id: 'c3',
        user: '🌈🌈懒散的闲云野鹤✨✨',
        avatarColor: const Color(0xFF8E24AA),
        content: '澡堂着火跳水池里不行嘛😂',
        time: '2小时前',
        location: '北京',
        likes: 24,
        replies: List.generate(
          11,
          (i) => CommentData(
            id: 'c3r$i',
            user: '回复者$i',
            avatarColor: Color(0xFF000000 + (i * 0x112233) % 0xFFFFFF),
            content: '哈哈哈哈 +${i + 1}',
            time: '${i + 1}小时前',
            likes: i * 2,
          ),
        ),
      ),
      CommentData(
        id: 'c4',
        user: '努力赚钱的蛋蛋',
        avatarColor: const Color(0xFFF57C00),
        content: '这是哪场的啊',
        time: '3小时前',
        location: '四川',
        likes: 18,
        replies: [
          CommentData(id: 'c4r1', user: '知情人士', avatarColor: const Color(0xFF455A64), content: '是上海某演出', time: '2小时前', likes: 9),
          CommentData(id: 'c4r2', user: '路人F', avatarColor: const Color(0xFF33691E), content: '我也想知道！', time: '1小时前', likes: 4),
          CommentData(id: 'c4r3', user: '路人G', avatarColor: const Color(0xFF4A148C), content: '求科普', time: '30分钟前', likes: 2),
        ],
      ),
      CommentData(
        id: 'c5',
        user: '迷迷茫茫',
        avatarColor: const Color(0xFF00897B),
        content: '太好看了！！',
        time: '4小时前',
        location: '上海',
        likes: 7,
      ),
    ];
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        _comments.insert(
          0,
          CommentData(
            id: 'new_${DateTime.now().millisecondsSinceEpoch}',
            user: '我',
            avatarColor: const Color(0xFF1976D2),
            content: _commentController.text.trim(),
            time: '刚刚',
          ),
        );
        _commentController.clear();
      });
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // 拖动条
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // 顶部热搜条
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      text: '大家都在搜：',
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                      children: [
                        TextSpan(
                          text: '宁轲🔍',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.onFullscreen != null) {
                      widget.onFullscreen!();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.open_in_full, size: 14, color: Colors.black54),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    if (widget.onClose != null) {
                      widget.onClose!();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.close, size: 14, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),

          // 评论数量
          Text(
            '${_comments.length} 条评论',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),

          // 评论列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                return _buildCommentItem(_comments[index], depth: 0);
              },
            ),
          ),

          Divider(height: 1, color: Colors.grey[200]),

          // 底部输入栏
          _buildInputBar(context),
        ],
      ),
    );
  }

  Widget _buildCommentItem(CommentData comment, {int depth = 0}) {
    const int maxDepth = 4; // 0~4 共5层
    final bool isExpanded = _expandedIds.contains(comment.id);
    final double avatarRadius = depth == 0 ? 20.0 : 14.0;
    final double indent = depth * 32.0;

    return Padding(
      padding: EdgeInsets.only(left: indent, top: depth == 0 ? 12 : 6, bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头像
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: comment.avatarColor,
            child: Icon(Icons.person, color: Colors.white, size: avatarRadius * 0.9),
          ),
          const SizedBox(width: 10),

          // 内容区
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 用户名
                Text(
                  comment.user,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: depth == 0 ? 13 : 12,
                  ),
                ),
                const SizedBox(height: 3),
                // 评论正文
                Text(
                  comment.content,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: depth == 0 ? 15 : 14,
                  ),
                ),
                const SizedBox(height: 6),
                // 时间 · 地点 · 回复
                Row(
                  children: [
                    Text(
                      comment.location.isNotEmpty
                          ? '${comment.time} · ${comment.location}'
                          : comment.time,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        '回复',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ),
                  ],
                ),
                // 展开/折叠回复按钮（未到最大深度才显示）
                if (comment.replies.isNotEmpty && depth < maxDepth) ...[
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          _expandedIds.remove(comment.id);
                        } else {
                          _expandedIds.add(comment.id);
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Container(width: 24, height: 1, color: Colors.grey[400]),
                        const SizedBox(width: 8),
                        Text(
                          isExpanded
                              ? '收起回复'
                              : '展开 ${comment.replies.length} 条回复',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                ],
                // 展开的回复列表（递归）
                if (isExpanded && comment.replies.isNotEmpty)
                  Column(
                    children: comment.replies
                        .map((reply) => _buildCommentItem(reply, depth: depth + 1))
                        .toList(),
                  ),
              ],
            ),
          ),

          // 点赞
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    comment.isLiked = !comment.isLiked;
                    comment.likes += comment.isLiked ? 1 : -1;
                  });
                },
                child: Icon(
                  comment.isLiked ? Icons.favorite : Icons.favorite_border,
                  size: depth == 0 ? 20 : 16,
                  color: comment.isLiked ? Colors.red : Colors.grey[400],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${comment.likes}',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _commentController,
                focusNode: _focusNode,
                style: const TextStyle(color: Colors.black, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: '有什么想法，展开说说',
                  hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onSubmitted: (_) => _addComment(),
              ),
            ),
          ),
          const SizedBox(width: 14),
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.image_outlined, color: Colors.black54, size: 26),
          ),
          const SizedBox(width: 14),
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.alternate_email, color: Colors.black54, size: 26),
          ),
          const SizedBox(width: 14),
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.sentiment_satisfied_alt_outlined, color: Colors.black54, size: 26),
          ),
        ],
      ),
    );
  }
}