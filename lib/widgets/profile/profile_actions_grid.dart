import 'package:flutter/material.dart';
import '../../common/funny_colors.dart';

class ProfileActionsGrid extends StatelessWidget {
  const ProfileActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _ActionIcon(icon: Icons.shopping_bag, label: '注文'),
          _ActionIcon(icon: Icons.history, label: '視聴履歴'),
          _ActionIcon(icon: Icons.account_balance_wallet, label: 'ウォレット'),
          _ActionIcon(icon: Icons.watch_later, label: 'あとで見る'),
          _ActionIcon(icon: Icons.grid_view, label: 'すべて'),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: FunnyColors.black87),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: FunnyColors.black)),
      ],
    );
  }
}
