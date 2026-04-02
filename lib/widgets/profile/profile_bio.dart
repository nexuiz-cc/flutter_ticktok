import 'package:flutter/material.dart';
import '../../common/funny_colors.dart';

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
