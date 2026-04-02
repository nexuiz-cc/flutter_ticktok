import 'package:flutter/material.dart';
import '../../common/funny_colors.dart';

// 自己紹介文を表示する。5行ウィジェット。
// 未記入時はプレースホルダーテキストを表示する。
// 右側のペンアイコンは編集トリガー予定。

/// プロフィール自己紹介文ウィジェット。
class ProfileBio extends StatelessWidget {
  const ProfileBio({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: const [
          Expanded(
            child: Text(
              '自己紹介を追加して、みんなに知ってもらおう...',
              style: TextStyle(color: FunnyColors.black),
            ),
          ),
          Icon(Icons.edit, size: 18, color: FunnyColors.black),
        ],
      ),
    );
  }
}
