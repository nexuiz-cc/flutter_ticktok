class VideoModel {
  final String id;
  final String videoUrl;
  final String coverUrl;
  final String title;
  final String authorName;
  final String authorAvatar;
  final String description;
  final int likeCount;
  final int commentCount;
  final int collectCount;
  final int shareCount;
  final int recommendCount;

  VideoModel({
    required this.id,
    required this.videoUrl,
    required this.coverUrl,
    required this.title,
    required this.authorName,
    required this.authorAvatar,
    required this.description,
    this.likeCount = 0,
    this.commentCount = 0,
    this.collectCount = 0,
    this.shareCount = 0,
    this.recommendCount = 0,
  });
}