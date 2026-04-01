import '../models/video_model.dart';

// フィードと検索画面で使う動画データのモック一覧。

final List<VideoModel> mockVideos = [
  VideoModel(
    id: '1',
    videoUrl:
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    coverUrl:
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.png',
    title: 'ミツバチの蜜集め',
    authorName: '自然の美',
    authorAvatar: 'https://i.pravatar.cc/150?img=1',
    description: '忙しいミツバチが花の間で蜜を集めている',
    keywords: ['ミツバチ', '自然', '蜜集め', '動物'],
    likeCount: 12345,
    commentCount: 543,
    collectCount: 1200,
    shareCount: 89,
    recommendCount: 456,
  ),
  VideoModel(
    id: '2',
    videoUrl:
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    coverUrl:
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.png',
    title: 'チョウが舞う',
    authorName: '昆虫ワールド',
    authorAvatar: 'https://i.pravatar.cc/150?img=2',
    description: '美しいチョウが花の間をひらひらと舞う',
    keywords: ['チョウ', '昆虫', '自然', '花'],
    likeCount: 9876,
    commentCount: 321,
    collectCount: 876,
    shareCount: 45,
    recommendCount: 234,
  ),
  VideoModel(
    id: '3',
    videoUrl:
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    coverUrl:
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg',
    title: 'Big Buck Bunny',
    authorName: 'アニメワールド',
    authorAvatar: 'https://i.pravatar.cc/150?img=3',
    description: '名作アニメ短編、Big Buck Bunny の冒険物語',
    keywords: ['アニメ', '短編', '冒険', 'ウサギ'],
    likeCount: 54321,
    commentCount: 1234,
    collectCount: 2100,
    shareCount: 156,
    recommendCount: 789,
  ),
  VideoModel(
    id: '4',
    videoUrl:
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    coverUrl:
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ElephantsDream.jpg',
    title: 'エレファント・ドリーム',
    authorName: 'クリエイティブアニメ',
    authorAvatar: 'https://i.pravatar.cc/150?img=4',
    description: '幻想的な象のアニメーションで、想像力に満ちている',
    keywords: ['ゾウ', 'アニメ', '幻想', '創作'],
    likeCount: 23456,
    commentCount: 876,
    collectCount: 1500,
    shareCount: 67,
    recommendCount: 345,
  ),
];
