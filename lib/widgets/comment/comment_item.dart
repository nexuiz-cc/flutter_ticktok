import 'package:flutter/material.dart';
import '../../data/mock_comments.dart';

class CommentItem extends StatefulWidget {
  final CommentData comment;
  final int depth;

  const CommentItem({
    super.key,
    required this.comment,
    this.depth = 0,
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    const int maxDepth = 4;
    final comment = widget.comment;
    final depth = widget.depth;
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
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    child: Row(
                      children: [
                        Container(width: 24, height: 1, color: Colors.grey[400]),
                        const SizedBox(width: 8),
                        Text(
                          _isExpanded
                              ? '返信を閉じる'
                              : '${comment.replies.length} 件の返信を表示',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                ],
                if (_isExpanded && comment.replies.isNotEmpty)
                  Column(
                    children: comment.replies
                        .map((reply) => CommentItem(
                              key: ValueKey(reply.id),
                              comment: reply,
                              depth: depth + 1,
                            ))
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
}
