// 動画ごとのUI状態だけを切り出して管理するモデル。
class VideoState {
  bool isLiked;
  int likeCount;
  
  VideoState({
    required this.isLiked,
    required this.likeCount,
  });
}
