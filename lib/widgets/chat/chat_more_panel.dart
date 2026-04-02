import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// チャット入力メニューの「+」ボタン押下時に表示される追加アクションパネル。
// 写真・撮影・ビデオ通話など自由に拡張できるグリッドレイアウト。
// ChatDetailPage から AnimatedContainer で高さをアニメーションして表示/非表示する。

/// チャット送信時の追加アクションプアネルユイジェット。
class ChatMorePanel extends StatelessWidget {
  /// ダークテーマかどうか・アイコン・背景色の切り替えに使用
  final bool isDark;
  /// アイテムインデックスを渡すコールバック（親が ImagePicker 操作を実行）
  final void Function(int index) onActionTap;

  const ChatMorePanel({
    super.key,
    required this.isDark,
    required this.onActionTap,
  });

  static const _moreActions = [
    {'icon': Icons.photo_library_outlined, 'label': '写真'},
    {'icon': Icons.camera_alt_outlined, 'label': '撮影'},
    {'icon': Icons.videocam_outlined, 'label': 'ビデオ通話'},
    {'icon': Icons.weekend_outlined, 'label': '一緒に見る'},
    {'icon': Icons.wallet_outlined, 'label': 'ギフト'},
    {'icon': Icons.location_on_outlined, 'label': '位置情報'},
    {'icon': Icons.swap_horiz, 'label': '送金'},
    {'icon': Icons.contact_page_outlined, 'label': '連絡先カード'},
  ];

  // ImageSource を公開して呼び出し側がピッカー操作できるようにする
  static ImageSource sourceForIndex(int index) =>
      index == 1 ? ImageSource.camera : ImageSource.gallery;

  @override
  Widget build(BuildContext context) {
    final panelBg = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF2F2F2);
    final iconBg = isDark ? const Color(0xFF2C2C2C) : Colors.white;
    final iconColor = isDark ? Colors.white70 : const Color(0xFF444444);
    final labelColor = isDark ? Colors.grey[400]! : const Color(0xFF444444);

    return Container(
      color: panelBg,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: _moreActions.length,
              itemBuilder: (context, index) {
                final action = _moreActions[index];
                return GestureDetector(
                  onTap: () => onActionTap(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: iconBg,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          action['icon'] as IconData,
                          color: iconColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        action['label'] as String,
                        style: TextStyle(fontSize: 12, color: labelColor),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 20,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[500] : Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 6,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
