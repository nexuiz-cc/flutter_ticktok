import 'package:flutter/material.dart';
import '../common/funny_colors.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_stats.dart';
import '../widgets/profile/profile_bio.dart';
import '../widgets/profile/profile_actions_grid.dart';
import '../widgets/profile/profile_tabs.dart';

// プロフィール画面。上から順に以下の5部分で構成される。
// 1. ProfileHeader  : カバー画像・アバター・ユーザー名
// 2. ProfileStats   : いいね・フォロー・フォロワーのカウント
// 3. ProfileBio     : 自己紹介文
// 4. ProfileActionsGrid : よく使うアクショングリッド
// 5. ProfileTabs    : 投稿・日常・おすすめ等のタブコンテンツ

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  // 各プロフィールコンポーネントを縦並びに配置して画面全体を描画する。
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FunnyColors.white,
      body: SafeArea(
        child: Column(
          children: const [
            ProfileHeader(),
            ProfileStats(),
            ProfileBio(),
            ProfileActionsGrid(),
            Expanded(child: ProfileTabs()),
          ],
        ),
      ),
    );
  }
}
