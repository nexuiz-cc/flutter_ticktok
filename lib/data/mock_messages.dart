import 'package:flutter/material.dart';

// メッセージ画面と詳細画面で使うチャット関連のモックデータ。

class ChatMessage {
  final String id;
  final String content;
  final bool isMe;
  final String time;
  final bool isSystem;
  final String? imagePath;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.isMe,
    this.time = '',
    this.isSystem = false,
    this.imagePath,
  });
}

final Map<String, List<ChatMessage>> mockChatHistory = {
  'm1': [
    ChatMessage(
      id: 'sys1',
      content: '2026-03-20 14:30',
      isMe: false,
      isSystem: true,
    ),
    ChatMessage(id: 'c1', content: '新しい動画みたよ！最高すぎる😭', isMe: false),
    ChatMessage(id: 'c2', content: 'ほんと！？どの動画？', isMe: true),
    ChatMessage(id: 'c3', content: 'さっき投稿されたやつ！もう100回リピートしてる笑', isMe: false),
    ChatMessage(id: 'c4', content: 'わかるwww 私も見た！神すぎた', isMe: true),
    ChatMessage(
      id: 'sys2',
      content: '2026-03-20 15:00',
      isMe: false,
      isSystem: true,
    ),
    ChatMessage(id: 'c5', content: 'そういえばグループのイベントどうする？', isMe: false),
    ChatMessage(id: 'c6', content: '行く行く！絶対行く！', isMe: true),
    ChatMessage(id: 'c7', content: 'よかった！楽しみにしてるね〜', isMe: false),
    ChatMessage(id: 'c8', content: 'こちらこそ！👏', isMe: true),
  ],
  'm2': [
    ChatMessage(
      id: 'sys1',
      content: '2026-03-25 09:00',
      isMe: false,
      isSystem: true,
    ),
    ChatMessage(id: 'c1', content: '[9件] グループ主が新作を公開しました！', isMe: false),
    ChatMessage(id: 'c2', content: 'もう見た？すごいクオリティだよね', isMe: false),
    ChatMessage(id: 'c3', content: 'まだ見てない！今から見る', isMe: true),
    ChatMessage(id: 'c4', content: '絶対好きだと思う！', isMe: false),
  ],
  'm4': [
    ChatMessage(
      id: 'sys1',
      content: '2026-01-29 20:00',
      isMe: false,
      isSystem: true,
    ),
    ChatMessage(id: 'c1', content: 'これ見て！すごいよ', isMe: false),
    ChatMessage(id: 'c2', content: '[動画を共有]', isMe: false),
    ChatMessage(id: 'c3', content: 'え、何これ笑えるwww', isMe: true),
    ChatMessage(id: 'c4', content: 'でしょ！また面白いのあったら送るね', isMe: false),
  ],
  'm6': [
    ChatMessage(
      id: 'sys1',
      content: '2026-03-31 10:00',
      isMe: false,
      isSystem: true,
    ),
    ChatMessage(
      id: 'c1',
      content: 'お互いフォローしました。チャットを始めましょう！',
      isMe: false,
      isSystem: true,
    ),
    ChatMessage(id: 'c2', content: 'はじめまして！よろしくお願いします😊', isMe: true),
  ],
  'm7': [
    ChatMessage(
      id: 'sys1',
      content: '2026-03-30 22:00',
      isMe: false,
      isSystem: true,
    ),
    ChatMessage(id: 'c1', content: '今日も一日お疲れ様！', isMe: true),
    ChatMessage(id: 'c2', content: 'ありがとう！あなたもね〜', isMe: false),
    ChatMessage(id: 'c3', content: 'おやすみ〜また明日ね😊', isMe: false),
    ChatMessage(id: 'c4', content: 'おやすみ！良い夢見てね🌙', isMe: true),
  ],
  'm8': [
    ChatMessage(
      id: 'sys1',
      content: '2026-03-29 18:30',
      isMe: false,
      isSystem: true,
    ),
    ChatMessage(id: 'c1', content: 'これ見て笑いすぎてて', isMe: false),
    ChatMessage(id: 'c2', content: 'その動画笑いすぎてお腹痛いwww', isMe: false),
    ChatMessage(id: 'c3', content: 'どれどれ笑', isMe: true),
    ChatMessage(id: 'c4', content: 'ほんとだwww 天才すぎる', isMe: true),
  ],
  'm11': [
    ChatMessage(
      id: 'sys1',
      content: '2026-03-28 12:00',
      isMe: false,
      isSystem: true,
    ),
    ChatMessage(id: 'c1', content: '明日暇？カフェ行かない？', isMe: false),
    ChatMessage(id: 'c2', content: 'いいね！何時ごろ？', isMe: true),
    ChatMessage(id: 'c3', content: '午後2時くらいはどう？', isMe: false),
    ChatMessage(id: 'c4', content: 'OK！どこのカフェにする？', isMe: true),
    ChatMessage(id: 'c5', content: '駅前の新しいとこ！インスタ映えするらしい😆', isMe: false),
    ChatMessage(id: 'c6', content: '楽しみ！じゃあまた明日ね', isMe: true),
  ],
};

class StoryItem {
  final String name;
  final String avatarUrl;
  final Color avatarColor;
  final bool isAddStory;
  final bool isSettings;
  final bool hasNewStory;

  const StoryItem({
    required this.name,
    required this.avatarUrl,
    this.avatarColor = Colors.grey,
    this.isAddStory = false,
    this.isSettings = false,
    this.hasNewStory = false,
  });
}

class MessageItem {
  final String id;
  final String name;
  final String avatarUrl;
  final Color avatarColor;
  final String lastMessage;
  final String time;
  final bool hasUnread;
  final bool isMuted;
  final bool isLive;
  final bool isMentioned;
  final bool isGroup;
  final bool isInteraction;

  const MessageItem({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.avatarColor = Colors.grey,
    required this.lastMessage,
    required this.time,
    this.hasUnread = false,
    this.isMuted = false,
    this.isLive = false,
    this.isMentioned = false,
    this.isGroup = false,
    this.isInteraction = false,
  });
}

final List<StoryItem> mockStories = [
  StoryItem(
    name: 'デイリー',
    avatarUrl: 'https://i.pravatar.cc/150?img=5',
    hasNewStory: true,
    isAddStory: true,
  ),
  StoryItem(
    name: 'ゆき',
    avatarUrl: 'https://i.pravatar.cc/150?img=9',
    hasNewStory: true,
  ),
  StoryItem(
    name: 'たろう',
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
    hasNewStory: false,
  ),
  StoryItem(name: '設定', avatarUrl: '', isSettings: true),
];

final List<MessageItem> mockMessages = [
  MessageItem(
    id: 'm0',
    name: 'インタラクション',
    avatarUrl: '',
    avatarColor: const Color(0xFFFF4B6E),
    lastMessage: '今週の人気動画ランキング発表！',
    time: '昨日',
    isInteraction: true,
  ),
  MessageItem(
    id: 'm1',
    name: '非公式ファングループ',
    avatarUrl: 'https://i.pravatar.cc/150?img=7',
    lastMessage: '【@メンション】さくら: 新しい動画みた？めちゃくちゃいい！',
    time: 'たった今',
    hasUnread: true,
    isMuted: true,
    isLive: true,
    isMentioned: true,
    isGroup: true,
  ),
  MessageItem(
    id: 'm2',
    name: 'ゆるふわサークル 16',
    avatarUrl: 'https://i.pravatar.cc/150?img=16',
    lastMessage: '[9件] グループ主が新作を公開しました！',
    time: '57分前',
    hasUnread: true,
    isMuted: true,
    isGroup: true,
  ),
  MessageItem(
    id: 'm3',
    name: '田中先生ファン 3',
    avatarUrl: 'https://i.pravatar.cc/150?img=20',
    lastMessage: '【@メンション】今夜の配信で使う資料を…',
    time: '3/22',
    hasUnread: true,
    isMuted: true,
    isMentioned: true,
    isGroup: true,
  ),
  MessageItem(
    id: 'm4',
    name: 'はな',
    avatarUrl: 'https://i.pravatar.cc/150?img=47',
    lastMessage: '[動画を共有]',
    time: '1/29',
    hasUnread: false,
  ),
  MessageItem(
    id: 'm5',
    name: 'ユーザー326651',
    avatarUrl: '',
    avatarColor: const Color(0xFFBDBDBD),
    lastMessage: '相手がメッセージを取り消しました',
    time: '2025/8/13',
    hasUnread: false,
  ),
  MessageItem(
    id: 'm6',
    name: 'けんじ',
    avatarUrl: 'https://i.pravatar.cc/150?img=33',
    avatarColor: const Color(0xFF9E9E9E),
    lastMessage: 'お互いフォローしました。チャットを始めましょう！',
    time: '',
    hasUnread: false,
  ),
  MessageItem(
    id: 'm7',
    name: 'みお',
    avatarUrl: 'https://i.pravatar.cc/150?img=44',
    lastMessage: 'おやすみ〜また明日ね😊',
    time: '月曜日',
    hasUnread: false,
  ),
  MessageItem(
    id: 'm8',
    name: 'こうた',
    avatarUrl: 'https://i.pravatar.cc/150?img=60',
    lastMessage: 'その動画笑いすぎてお腹痛いwww',
    time: '火曜日',
    hasUnread: true,
  ),
  MessageItem(
    id: 'm9',
    name: 'あやか',
    avatarUrl: 'https://i.pravatar.cc/150?img=49',
    lastMessage: '[ステッカーを送信]',
    time: '水曜日',
    hasUnread: false,
  ),
  MessageItem(
    id: 'm10',
    name: 'ゲーム部 42',
    avatarUrl: 'https://i.pravatar.cc/150?img=11',
    lastMessage: '[8件] 新しいイベント始まったよ！',
    time: '木曜日',
    hasUnread: true,
    isMuted: false,
    isGroup: true,
  ),
  MessageItem(
    id: 'm11',
    name: 'りょう',
    avatarUrl: 'https://i.pravatar.cc/150?img=52',
    lastMessage: '明日暇？カフェ行かない？',
    time: '木曜日',
    hasUnread: true,
  ),
  MessageItem(
    id: 'm12',
    name: 'さな',
    avatarUrl: 'https://i.pravatar.cc/150?img=38',
    lastMessage: '[動画を共有]',
    time: '先週',
    hasUnread: false,
  ),
  MessageItem(
    id: 'm13',
    name: '料理好き集まれ！',
    avatarUrl: 'https://i.pravatar.cc/150?img=22',
    lastMessage: '【@メンション】ゆい: この레시피ほしい！',
    time: '先週',
    hasUnread: true,
    isMuted: true,
    isMentioned: true,
    isGroup: true,
  ),
  MessageItem(
    id: 'm14',
    name: 'ひろ',
    avatarUrl: 'https://i.pravatar.cc/150?img=65',
    lastMessage: 'お疲れ！今日もお仕事お疲れ様でした',
    time: '先週',
    hasUnread: false,
  ),
  MessageItem(
    id: 'm15',
    name: 'ユーザー987432',
    avatarUrl: '',
    avatarColor: const Color(0xFFBDBDBD),
    lastMessage: '相手がメッセージを取り消しました',
    time: '2025/12/1',
    hasUnread: false,
  ),
  MessageItem(
    id: 'm16',
    name: 'なな',
    avatarUrl: 'https://i.pravatar.cc/150?img=41',
    lastMessage: '返信ありがとう！また話しかけてね〜',
    time: '2025/11/20',
    hasUnread: false,
  ),
  MessageItem(
    id: 'm17',
    name: 'K-POPオタ友達',
    avatarUrl: 'https://i.pravatar.cc/150?img=3',
    lastMessage: '[5件] 新曲リリースされたよ！！！',
    time: '2025/10/5',
    hasUnread: false,
    isMuted: true,
    isGroup: true,
  ),
  MessageItem(
    id: 'm18',
    name: 'とも',
    avatarUrl: 'https://i.pravatar.cc/150?img=57',
    lastMessage: 'お互いフォローしました。チャットを始めましょう！',
    time: '2025/9/14',
    hasUnread: false,
  ),
];
