import 'package:flutter/material.dart';
import '../../common/funny_colors.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FunnyColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: const [
              _StatItem(label: 'いいね', value: '69'),
              SizedBox(width: 1),
              _StatItem(label: '相互', value: '2'),
              SizedBox(width: 1),
              _StatItem(label: 'フォロー中', value: '362'),
              SizedBox(width: 1),
              _StatItem(label: 'フォロワー', value: '7'),
            ],
          ),
          const Spacer(),
          SizedBox(
            height: 32,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFCCCCCC)),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                foregroundColor: FunnyColors.black,
                backgroundColor: FunnyColors.white,
                textStyle: const TextStyle(fontSize: 14),
              ),
              onPressed: () {},
              child: const Text('プロフィールを編集'),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: FunnyColors.black,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: FunnyColors.black54),
          ),
        ],
      ),
    );
  }
}
