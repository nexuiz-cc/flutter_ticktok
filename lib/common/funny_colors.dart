import 'package:flutter/material.dart';

// アプリ全体で共有するカラーパレットをまとめる。
// 全てのウィジェットはこのクラスから色を参照し、
// マジックナンバーをコードに散らばせない設計にする。

class FunnyColors {
  // ─── 基本色 ───────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);     // 純白
  static const Color black = Color(0xFF000000);     // 純黒
  static const Color black54 = Color(0x8A000000);  // 54% 透過黒（サブテキスト等）
  static const Color black87 = Color(0xDD000000);  // 87% 透過黒（プライマリテキスト）
  static const Color white70 = Color(0xB3FFFFFF);  // 70% 透過白（薄いオーバーレイ）
  static const Color grey = Color(0xFF9E9E9E);      // 中間グレー（非選択タブ等）
  static const Color red = Color(0xFFF44336);       // 警告・いいね・バッジ用の赤
  static const Color ironGrey = Color(0xFF484A4C);  // 鉄灰色（ボタン背景等）

  // ─── テーマカラー ──────────────────────────────────
  static const Color bananaYellow = Color(0xFFFFF200);   // バナナイエロー
  static const Color watermelonRed = Color(0xFFFF3B3B);  // スイカ赤
  static const Color avocadoGreen = Color(0xFFB2FF59);   // アボカドグリーン
  static const Color grapePurple = Color(0xFF9B59B6);    // グレープパープル
  static const Color skyBlue = Color(0xFF00CFFF);        // ハッシュタグ等で使うスカイブルー
  static const Color bubblegumPink = Color(0xFFFF69B4);  // バブルガムピンク
  static const Color cheeseOrange = Color(0xFFFFA500);   // チーズオレンジ
  static const Color mintGreen = Color(0xFF98FF98);      // ミントグリーン
  static const Color colaBrown = Color(0xFF6B4226);      // コーラブラウン
  static const Color lemonLime = Color(0xFFEFFF00);      // レモンライム
  static const Color unicornWhite = Color(0xFFFFFFFF);   // ユニコーンホワイト（動画テキスト用）
  static const Color pandaBlack = Color(0xFF222222);     // パンダブラック（動画背景等）
  static const Color rainbow = Color(0xFFE040FB);        // レインボーパープル
  static const Color tomatoSauce = Color(0xFFFF6347);    // トマトソース赤
  static const Color grassGreen = Color(0xFF43A047);     // 草グリーン
  static const Color oceanBlue = Color(0xFF1976D2);      // オーシャンブルー
  static const Color flamingoPink = Color(0xFFFF77A9);   // フラミンゴピンク
  static const Color goldCoin = Color(0xFFFFD700);       // ゴールドコイン
  static const Color ghostGrey = Color(0xFFB0BEC5);      // ゴーストグレー
  static const Color chocolate = Color(0xFF8B4513);      // チョコレートブラウン
  // UI背景用の濃い暗灰色（ナビゲーションバー底面など）
  static const Color darkgrey = Color.fromARGB(255, 40, 40, 40);
}
