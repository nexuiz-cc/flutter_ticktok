import 'package:flutter/material.dart';
import 'package:flutter_application/data/mock_videos.dart';
import 'package:flutter_application/widgets/video_item.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: mockVideos.length,
        itemBuilder: (context, index) {
          return VideoItem(video: mockVideos[index]);
        },
      ),
    );
  }
}