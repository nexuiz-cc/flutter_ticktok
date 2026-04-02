import '../models/video_model.dart';

// 説明文とキーワードの両方を対象に動画を絞り込む。
// 大文字・小文字・前後の空白は無視して部分一致で比較する。

/// [videos] から [query] に一致するものだけを返す。
/// - [query] が空文字のとき → 全件をそのままコピーして返す（元のリストを破壊しない）
/// - 一致条件: description への部分一致 OR keywords のいずれかへの部分一致
List<VideoModel> filterVideosByQuery(List<VideoModel> videos, String query) {
  final normalizedQuery = query.trim().toLowerCase();
  // クエリが空 → フィルタ不要なので全件コピーを返す
  if (normalizedQuery.isEmpty) {
    return List<VideoModel>.from(videos);
  }

  return videos.where((video) {
    // 説明文での部分一致チェック
    final matchesDescription = video.description.toLowerCase().contains(
      normalizedQuery,
    );
    // キーワードリストの中に部分一致するものがあるかチェック
    final matchesKeywords = video.keywords.any(
      (keyword) => keyword.toLowerCase().contains(normalizedQuery),
    );

    return matchesDescription || matchesKeywords;
  }).toList();
}
