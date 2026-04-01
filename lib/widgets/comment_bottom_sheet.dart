import 'package:flutter/material.dart';
import '../models/video_model.dart';
import '../data/mock_comments.dart';

// コメント一覧の表示と投稿入力を行うボトムシート。

class CommentBottomSheet extends StatefulWidget {
  final VideoModel video;
  final VoidCallback? onClose;
  final VoidCallback? onFullscreen;

  const CommentBottomSheet({
    super.key,
    required this.video,
    this.onClose,
    this.onFullscreen,
  });

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final Set<String> _expandedIds = {};

  late List<CommentData> _comments;

  @override
  void initState() {
    super.initState();
    _comments = List.from(mockComments);
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
            user: '自分',
            avatarColor: const Color(0xFF1976D2),
            content: _commentController.text.trim(),
            time: 'たった今',
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
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      text: 'みんなが検索中: ',
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                      children: [
                        TextSpan(
                          text: '人気ワード🔍',
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
                    child: const Icon(
                      Icons.open_in_full,
                      size: 14,
                      color: Colors.black54,
                    ),
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
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${_comments.length} 件のコメント',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),

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

          _buildInputBar(context),
        ],
      ),
    );
  }

  Widget _buildCommentItem(CommentData comment, {int depth = 0}) {
    const int maxDepth = 4;
    final bool isExpanded = _expandedIds.contains(comment.id);
    final double avatarRadius = depth == 0 ? 20.0 : 14.0;
    final double indent = depth * 32.0;

    return Padding(
      padding: EdgeInsets.only(
        left: indent,
        top: depth == 0 ? 12 : 6,
        bottom: 2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: comment.avatarColor,
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: avatarRadius * 0.9,
            ),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.user,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: depth == 0 ? 13 : 12,
                  ),
                ),
                const SizedBox(height: 3),

                Text(
                  comment.content,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: depth == 0 ? 15 : 14,
                  ),
                ),
                const SizedBox(height: 6),

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
                        '返信',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ),
                  ],
                ),

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
                        Container(
                          width: 24,
                          height: 1,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isExpanded
                              ? '返信を閉じる'
                              : '${comment.replies.length} 件の返信を表示',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
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

                if (isExpanded && comment.replies.isNotEmpty)
                  Column(
                    children: comment.replies
                        .map(
                          (reply) => _buildCommentItem(reply, depth: depth + 1),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),

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
                  hintText: '感想を聞かせてください',
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
            child: const Icon(
              Icons.image_outlined,
              color: Colors.black54,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.alternate_email,
              color: Colors.black54,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.sentiment_satisfied_alt_outlined,
              color: Colors.black54,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}
