// 動画表示に必要なメタデータをまとめるモデル。
// VideoPage のフィードや検索フィルタで参照される中心データ構造。

class VideoModel {
  // ─── 識別・メディア ────────────────────────────────
  /// 動画を一意に識別するID（モックデータでは '1'〜'10' の文字列）
  final String id;
  /// ストリーミング再生に使う動画URL
  final String videoUrl;
  /// サムネイル（カバー）画像のURL
  final String coverUrl;
  /// 動画タイトル
  final String title;

  // ─── 投稿者情報 ────────────────────────────────────
  /// 投稿者のユーザー名（@表示に使用）
  final String authorName;
  /// 投稿者アバター画像のURL
  final String authorAvatar;

  // ─── コンテンツ情報 ────────────────────────────────
  /// 動画の説明文（検索フィルタの対象になる）
  final String description;
  /// ハッシュタグ等のキーワード一覧（検索フィルタの対象になる）
  final List<String> keywords;

  // ─── カウント（変更可能） ──────────────────────────
  /// いいね件数（トグル操作で増減する可変フィールド）
  int likeCount;
  /// コメント件数
  final int commentCount;
  /// 保存（コレクト）件数
  final int collectCount;
  /// シェア件数
  final int shareCount;
  /// おすすめ件数（動画下部のバッジに表示）
  final int recommendCount;

  // ─── UI状態 ────────────────────────────────────────
  /// 現在のユーザーがいいね済みかどうか（可変）
  bool isLiked;

  // ─── レイアウト制御 ────────────────────────────────
  /// 表示アスペクト比（幅/高さ）の制御フラグ。
  /// - null   → 縦全画面モード。動画を画面全体に cover 表示し、全画面ボタンを非表示。
  /// - 非null → このフラグが「非null」であることしか見ない（値はChewieControllerに渡さない）。
  ///            VideoPlayerControllerの実際のARでレンダリングし、全画面ボタンを表示する。
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
