import 'package:flutter/material.dart';
import '../common/funny_colors.dart';

// プロフィールのヘッダーと各種セクションをまとめて表示する画面。

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FunnyColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const ProfileHeader(),
            const ProfileStats(),
            const ProfileBio(),
            const ProfileActionsGrid(),
            const Expanded(child: ProfileTabs()),
          ],
        ),
      ),
    );
  }
}

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
                backgroundImage: NetworkImage(
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
                      style: TextStyle(
                        fontSize: 14,
                        color: FunnyColors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.person_add_alt_1,
                  color: FunnyColors.white,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

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
                shape: RoundedRectangleBorder(
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
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: FunnyColors.black),
        ),
      ],
    );
  }
}

class ProfileTabs extends StatelessWidget {
  const ProfileTabs({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(height: 1, color: FunnyColors.grey),
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  tabBarTheme: Theme.of(
                    context,
                  ).tabBarTheme.copyWith(dividerColor: Colors.transparent),
                ),
                child: TabBar(
                  labelColor: FunnyColors.black,
                  unselectedLabelColor: FunnyColors.grey,
                  indicator: const _CustomTabIndicator(),
                  indicatorColor: Colors.transparent,
                  indicatorWeight: 0,
                  tabs: const [
                    Tab(text: '投稿'),
                    Tab(text: '日常'),
                    Tab(text: 'おすすめ'),
                    Tab(text: '保存済み'),
                    Tab(text: 'いいね'),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                VideoGrid(),
                Center(child: Text('日常')),
                Center(child: Text('おすすめ')),
                Center(child: Text('保存済み')),
                Center(child: Text('いいね')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomTabIndicator extends Decoration {
  const _CustomTabIndicator();

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomTabIndicatorPainter();
  }
}

class _CustomTabIndicatorPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final double height = configuration.size?.height ?? 0;
    final double indicatorHeight = 3.5;
    final double startX = offset.dx - 4;
    final double endX = startX + 40;
    final double y = offset.dy + height - indicatorHeight + 0.5;
    final Paint paint = Paint()
      ..color = FunnyColors.black
      ..strokeWidth = indicatorHeight
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(startX, y + indicatorHeight / 2),
      Offset(endX, y + indicatorHeight / 2),
      paint,
    );
  }
}

class VideoGrid extends StatelessWidget {
  const VideoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 9 / 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(
              color: FunnyColors.grey,
              child: const Center(
                child: Icon(
                  Icons.play_arrow,
                  size: 40,
                  color: FunnyColors.white,
                ),
              ),
            ),
            Positioned(
              left: 4,
              bottom: 4,
              child: Row(
                children: const [
                  Icon(Icons.play_arrow, size: 14, color: FunnyColors.white),
                  SizedBox(width: 2),
                  Text(
                    '51',
                    style: TextStyle(color: FunnyColors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
