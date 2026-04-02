// 動画ごとのUI状態だけを切り出して管理するモデル。
// VideoModel はイミュータブルなメタデータを保持するが、
// いいね状態など画面操作で変化する値はこのクラスが担う。
// VideoPage は Map<String, VideoState> でID別に管理する。

class VideoState {
  /// 現在のユーザーがこの動画をいいね済みかどうか
  bool isLiked;
  /// 画面に表示するいいね件数（操作に応じてインクリメント/デクリメント）
  int likeCount;

  VideoState({
    required this.isLiked,
    required this.likeCount,
  });
}
