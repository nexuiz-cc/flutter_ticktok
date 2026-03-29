import 'package:flutter/material.dart';

class VideoActions extends StatelessWidget {
  final int likeCount;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onCollect;
  final VoidCallback onShare;
  final VoidCallback onMusic;

  const VideoActions({
    super.key,
    required this.likeCount,
    required this.isLiked,
    required this.onLike,
    required this.onComment,
    required this.onCollect,
    required this.onShare,
    required this.onMusic,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildActionButton(
          icon: Icons.person_add,
          label: '关注',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('关注功能开发中')),
            );
          },
          color: Colors.red,
        ),
        const SizedBox(height: 8),
        _buildActionButton(
          icon: isLiked ? Icons.favorite : Icons.favorite_border,
          label: _formatCount(likeCount),
          onTap: onLike,
          color: isLiked ? Colors.red : Colors.white,
        ),
        const SizedBox(height: 8),
        _buildActionButton(
          icon: Icons.chat_bubble_outline,
          label: '评论',
          onTap: onComment,
          color: Colors.white,
        ),
        const SizedBox(height: 8),
        _buildActionButton(
          icon: Icons.star_border,
          label: '收藏',
          onTap: onCollect,
          color: Colors.white,
        ),
        const SizedBox(height: 8),
        _buildActionButton(
          icon: Icons.share,
          label: '分享',
          onTap: onShare,
          color: Colors.white,
        ),
        const SizedBox(height: 20),
        _buildActionButton(
          icon: Icons.music_note,
          label: '音乐',
          onTap: onMusic,
          color: Colors.yellow,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}w';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}