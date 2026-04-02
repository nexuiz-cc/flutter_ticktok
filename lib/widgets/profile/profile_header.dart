import 'package:flutter/material.dart';
import '../../common/funny_colors.dart';

// プロフィール画面の最上部。
// グラデーションカバー画像の上にアバター・ユーザー名・ ID ・フォローボタンを重ねる。

/// プロフィール上部のカバー+アバターウィジェット。
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 120,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6EC6FF), Color(0xFF2196F3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: FunnyColors.grey,
                backgroundImage: const NetworkImage(
                  'https://randomuser.me/api/portraits/men/32.jpg',
                ),
                child: Container(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'nexuiz1123',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: FunnyColors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'TikTok ID: dyuembzjff9p',
                      style: TextStyle(fontSize: 14, color: FunnyColors.white70),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.person_add_alt_1, color: FunnyColors.white),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
