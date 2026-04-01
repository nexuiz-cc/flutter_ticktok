import 'package:flutter/material.dart';
import '../common/funny_colors.dart';

// 動画の読み込み中表示とエラー表示を切り替えるUI。

class VideoLoadingView extends StatelessWidget {
  const VideoLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: FunnyColors.pandaBlack,
      body: Center(
        child: CircularProgressIndicator(color: FunnyColors.unicornWhite),
      ),
    );
  }
}

class VideoErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;
  const VideoErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FunnyColors.pandaBlack,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: FunnyColors.unicornWhite,
              size: 60,
            ),
            const SizedBox(height: 20),
            const Text(
              '動画の読み込みに失敗しました',
              style: TextStyle(color: FunnyColors.unicornWhite, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              errorMessage,
              style: const TextStyle(
                color: FunnyColors.ghostGrey,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: FunnyColors.tomatoSauce,
                foregroundColor: FunnyColors.unicornWhite,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: const Text('再読み込み'),
            ),
          ],
        ),
      ),
    );
  }
}
