import 'package:flutter/material.dart';
import '../../common/funny_colors.dart';

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
                  tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
                    dividerColor: Colors.transparent,
                  ),
                ),
                child: const TabBar(
                  labelColor: FunnyColors.black,
                  unselectedLabelColor: FunnyColors.grey,
                  indicator: _CustomTabIndicator(),
                  indicatorColor: Colors.transparent,
                  indicatorWeight: 0,
                  tabs: [
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
                const VideoGrid(),
                const Center(child: Text('日常')),
                const Center(child: Text('おすすめ')),
                const Center(child: Text('保存済み')),
                const Center(child: Text('いいね')),
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
    const double indicatorHeight = 3.5;
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
                child: Icon(Icons.play_arrow, size: 40, color: FunnyColors.white),
              ),
            ),
            Positioned(
              left: 4,
              bottom: 4,
              child: Row(
                children: const [
                  Icon(Icons.play_arrow, size: 14, color: FunnyColors.white),
                  SizedBox(width: 2),
                  Text('51', style: TextStyle(color: FunnyColors.white, fontSize: 12)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
