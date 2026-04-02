// 動画表示に必要なメタデータをまとめるモデル。
class VideoModel {
  final String id;
  final String videoUrl;
  final String coverUrl;
  final String title;
  final String authorName;
  final String authorAvatar;
  final String description;
  final List<String> keywords;
  int likeCount;
  final int commentCount;
  final int collectCount;
  final int shareCount;
  final int recommendCount;
  bool isLiked;
  // 表示アスペクト比（幅/高さ）。null のとき縦画面全体に表示（全画面ボタン非表示）。
  final double? displayAspectRatio;

  VideoModel({
    required this.id,
    required this.videoUrl,
    required this.coverUrl,
    required this.title,
    required this.authorName,
    required this.authorAvatar,
    required this.description,
    required this.keywords,
    this.likeCount = 0,
    this.commentCount = 0,
    this.collectCount = 0,
    this.shareCount = 0,
    this.recommendCount = 0,
    this.isLiked = false,
    this.displayAspectRatio = 9.0 / 16.0,
  });
}
