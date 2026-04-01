import '../models/video_model.dart';

// 説明文とキーワードの両方を対象に動画を絞り込む。

List<VideoModel> filterVideosByQuery(List<VideoModel> videos, String query) {
  final normalizedQuery = query.trim().toLowerCase();
  if (normalizedQuery.isEmpty) {
    return List<VideoModel>.from(videos);
  }

  return videos.where((video) {
    final matchesDescription = video.description.toLowerCase().contains(
      normalizedQuery,
    );
    final matchesKeywords = video.keywords.any(
      (keyword) => keyword.toLowerCase().contains(normalizedQuery),
    );

    return matchesDescription || matchesKeywords;
  }).toList();
}
