import 'package:flutter/material.dart';
import '../common/funny_colors.dart';

class VideoActions extends StatefulWidget {
  final int likeCount;
  final bool isLiked;
  final String authorName;
  final String authorAvatar;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onCollect;
  final VoidCallback onShare;
  final VoidCallback onMusic;

  const VideoActions({
    super.key,
    required this.likeCount,
    required this.isLiked,
    required this.authorName,
    required this.authorAvatar,
    required this.onLike,
    required this.onComment,
    required this.onCollect,
    required this.onShare,
    required this.onMusic,
  });

  @override
  State<VideoActions> createState() => _VideoActionsState();
}

class _VideoActionsState extends State<VideoActions> {
  bool _isFollowing = false;

  Color _avatarColor(String name) {
    const colors = [
      Color(0xFF1565C0), Color(0xFF6A1B9A), Color(0xFF00695C),
      Color(0xFFBF360C), Color(0xFF2E7D32), Color(0xFF0277BD),
      Color(0xFFAD1457), Color(0xFF4E342E), Color(0xFF37474F),
    ];
    return colors[name.codeUnits.fold(0, (a, b) => a + b) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 作者头像 + 关注按钮
        GestureDetector(
          onTap: () => setState(() => _isFollowing = !_isFollowing),
          child: SizedBox(
            width: 48,
            height: 60,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: ClipOval(
                    child: widget.authorAvatar.isNotEmpty
                        ? Image.network(
                            widget.authorAvatar,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildFallbackAvatar(),
                          )
                        : _buildFallbackAvatar(),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isFollowing ? Colors.grey : FunnyColors.red,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Icon(
                      _isFollowing ? Icons.check : Icons.add,
                      color: Colors.white,
                      size: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildActionButton(
          icon: widget.isLiked ? Icons.favorite : Icons.favorite_border,
          label: _formatCount(widget.likeCount),
          onTap: widget.onLike,
          color: widget.isLiked ? FunnyColors.red : FunnyColors.white,
        ),
        const SizedBox(height: 8),
        _buildActionButton(
          icon: Icons.chat_bubble_outline,
          label: '评论',
          onTap: widget.onComment,
          color: FunnyColors.white,
        ),
        const SizedBox(height: 8),
        _buildActionButton(
          icon: Icons.star_border,
          label: '收藏',
          onTap: widget.onCollect,
          color: FunnyColors.white,
        ),
        const SizedBox(height: 8),
        _buildActionButton(
          icon: Icons.share,
          label: '分享',
          onTap: widget.onShare,
          color: FunnyColors.white,
        ),
        const SizedBox(height: 20),
        _buildActionButton(
          icon: Icons.music_note,
          label: '音乐',
          onTap: widget.onMusic,
          color: FunnyColors.bananaYellow,
        ),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget _buildFallbackAvatar() {
    return Container(
      width: 48,
      height: 48,
      color: _avatarColor(widget.authorName),
      child: Center(
        child: Text(
          widget.authorName.isNotEmpty ? widget.authorName[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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