import 'package:flutter/material.dart';

// 评论数据模型
class CommentData {
  final String id;
  final String user;
  final Color avatarColor;
  final String content;
  final String time;
  final String location;
  int likes;
  bool isLiked;
  final List<CommentData> replies;

  CommentData({
    required this.id,
    required this.user,
    required this.avatarColor,
    required this.content,
    required this.time,
    this.location = '',
    this.likes = 0,
    this.isLiked = false,
    List<CommentData>? replies,
  }) : replies = replies ?? [];
}

final List<CommentData> mockComments = [
  CommentData(
    id: 'c1',
    user: 'レモンサワー好き',
    avatarColor: const Color(0xFF1565C0),
    content: 'これ何回聴いても飽きない…もう100回は繰り返してる😭',
    time: '6時間前',
    location: '東京',
    likes: 1243,
    replies: [
      CommentData(
        id: 'c1r1',
        user: '深夜の住人',
        avatarColor: const Color(0xFF6A1B9A),
        content: '同じく無限ループ中、助けて',
        time: '5時間前',
        location: '大阪',
        likes: 87,
        replies: [
          CommentData(
            id: 'c1r1r1',
            user: '夜更かし猫',
            avatarColor: const Color(0xFF00695C),
            content: '深夜2時+1',
            time: '4時間前',
            likes: 23,
            replies: [
              CommentData(
                id: 'c1r1r1r1',
                user: '眠れない.jpg',
                avatarColor: const Color(0xFFBF360C),
                content: '深夜3時+1、明日仕事なのに笑',
                time: '3時間前',
                likes: 11,
                replies: [
                  CommentData(
                    id: 'c1r1r1r1r1',
                    user: '朝まで聴いてた',
                    avatarColor: const Color(0xFF37474F),
                    content: '夜明け+1、通勤中もまだ聴いてる😂',
                    time: '1時間前',
                    likes: 6,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      CommentData(
        id: 'c1r2',
        user: '音楽は永遠',
        avatarColor: const Color(0xFF558B2F),
        content: 'お気に入り登録した！シェアありがとう🙏',
        time: '5時間前',
        location: '京都',
        likes: 34,
      ),
      CommentData(
        id: 'c1r3',
        user: '空の旅人',
        avatarColor: const Color(0xFFE65100),
        content: '曲名教えてください！！',
        time: '4時間前',
        likes: 18,
      ),
    ],
  ),
  CommentData(
    id: 'c2',
    user: '通りすがりの人',
    avatarColor: const Color(0xFF43A047),
    content: 'なぜか急に泣けてきた…自分でもわからない😢',
    time: '3時間前',
    location: '福岡',
    likes: 672,
    replies: [
      CommentData(
        id: 'c2r1',
        user: '同じく涙腺崩壊',
        avatarColor: const Color(0xFFD81B60),
        content: 'わかる、なんか胸にくるよね',
        time: '3時間前',
        location: '札幌',
        likes: 145,
        replies: [
          CommentData(
            id: 'c2r1r1',
            user: '泣かない泣かない',
            avatarColor: const Color(0xFF0277BD),
            content: '私もそう、不思議な感覚',
            time: '2時間前',
            likes: 29,
          ),
        ],
      ),
      CommentData(
        id: 'c2r2',
        user: '感情制御不能',
        avatarColor: const Color(0xFF4E342E),
        content: '最近ストレス溜まってて、この曲が刺さりすぎた',
        time: '2時間前',
        location: '名古屋',
        likes: 88,
        replies: [
          CommentData(
            id: 'c2r2r1',
            user: 'ハグしたい',
            avatarColor: const Color(0xFF33691E),
            content: 'お疲れ様、ゆっくり休んでね🤗',
            time: '1時間前',
            likes: 41,
          ),
        ],
      ),
      CommentData(id: 'c2r3', user: '星に願いを', avatarColor: const Color(0xFF546E7A), content: 'すごく共感できる', time: '2時間前', likes: 15),
      CommentData(id: 'c2r4', user: '月見る人', avatarColor: const Color(0xFF1B5E20), content: 'そっといいね押しとく', time: '1時間前', likes: 7),
    ],
  ),
  CommentData(
    id: 'c3',
    user: '🌙夜更かし部🌙',
    avatarColor: const Color(0xFF8E24AA),
    content: '地元で夜にこれ聴いたら懐かしくて泣いた😭',
    time: '4時間前',
    location: '仙台',
    likes: 318,
    replies: List.generate(
      8,
      (i) => CommentData(
        id: 'c3r$i',
        user: '他郷の旅人${i + 1}',
        avatarColor: Color(0xFF000000 | ((0x3A7BD5 + i * 0x1A3C5E) & 0xFFFFFF)),
        content: ['同じく遠くにいる、ぎゅっ', '私も、すごく帰りたい', '涙が止まらなかった', '一人で頑張るのって大変だよね', '実家の味が恋しい', '今週末帰る！', '自分を褒めてあげよう💪', '踏ん張れ、みんな'][i],
        time: '${i + 1}時間前',
        likes: (8 - i) * 12,
      ),
    ),
  ),
  CommentData(
    id: 'c4',
    user: '毎日ポジティブ',
    avatarColor: const Color(0xFFF57C00),
    content: 'この動画の撮り方めちゃくちゃ上手い、センス抜群📸',
    time: '5時間前',
    location: '横浜',
    likes: 203,
    replies: [
      CommentData(
        id: 'c4r1',
        user: '写真好きな人',
        avatarColor: const Color(0xFF455A64),
        content: 'どんな機材使ってるんですか？気になる！',
        time: '4時間前',
        likes: 56,
        replies: [
          CommentData(
            id: 'c4r1r1',
            user: '投稿者本人',
            avatarColor: const Color(0xFFFF6F00),
            content: '普通のスマホですよ〜自然光がいい感じで笑',
            time: '3時間前',
            likes: 99,
          ),
        ],
      ),
      CommentData(id: 'c4r2', user: '勉強中です', avatarColor: const Color(0xFF4A148C), content: '編集は何のアプリ使いましたか？', time: '3時間前', likes: 22),
      CommentData(id: 'c4r3', user: '構図マニア', avatarColor: const Color(0xFF006064), content: '三分割法の使い方が完璧！', time: '2時間前', likes: 13),
    ],
  ),
  CommentData(
    id: 'c5',
    user: '食う寝る遊ぶ',
    avatarColor: const Color(0xFF00897B),
    content: 'wwwwwwww笑いすぎてお腹痛い🤣🤣🤣',
    time: '7時間前',
    location: '神戸',
    likes: 891,
    replies: [
      CommentData(
        id: 'c5r1',
        user: '一緒に死ぬ',
        avatarColor: const Color(0xFFAD1457),
        content: '笑いが止まらなすぎる',
        time: '7時間前',
        location: '広島',
        likes: 234,
        replies: [
          CommentData(
            id: 'c5r1r1',
            user: '救急搬送中',
            avatarColor: const Color(0xFF1A237E),
            content: '救急車呼んで、笑いすぎて内臓やられた',
            time: '6時間前',
            likes: 78,
            replies: [
              CommentData(
                id: 'c5r1r1r1',
                user: '医師本人',
                avatarColor: const Color(0xFF2E7D32),
                content: '私も救急室でこれ見て笑ってたwww',
                time: '5時間前',
                likes: 156,
              ),
            ],
          ),
        ],
      ),
      CommentData(id: 'c5r2', user: '笑いの星の住人', avatarColor: const Color(0xFF827717), content: 'センスが天才すぎるwww', time: '6時間前', likes: 45),
      CommentData(id: 'c5r3', user: '笑いのツボ浅め', avatarColor: const Color(0xFF4E342E), content: 'もう10回見たのにまだ笑える', time: '5時間前', likes: 31),
    ],
  ),
  CommentData(
    id: 'c6',
    user: 'ゆるく生きたい',
    avatarColor: const Color(0xFF546E7A),
    content: '仕事行きたくない人、ここに集合😭',
    time: '8時間前',
    location: '東京',
    likes: 2341,
    replies: [
      CommentData(
        id: 'c6r1',
        user: '社畜日記',
        avatarColor: const Color(0xFFBF360C),
        content: 'はい！毎日この気持ちで出社してます',
        time: '8時間前',
        location: '埼玉',
        likes: 678,
        replies: [
          CommentData(
            id: 'c6r1r1',
            user: '上司が後ろに',
            avatarColor: const Color(0xFF880E4F),
            content: '君、仕事してないね',
            time: '7時間前',
            likes: 1024,
          ),
        ],
      ),
      CommentData(id: 'c6r2', user: '逃亡準備完了', avatarColor: const Color(0xFF37474F), content: '今日だけで百回辞めたいと思った', time: '7時間前', likes: 89),
      CommentData(id: 'c6r3', user: 'お金よ来い', avatarColor: const Color(0xFF1B5E20), content: 'お金がなければ誰が働くか', time: '6時間前', likes: 567),
    ],
  ),
  CommentData(
    id: 'c7',
    user: '光を追う少年🌟',
    avatarColor: const Color(0xFFF9A825),
    content: '頑張ってる人が一番かっこいい！応援してるよ！💪',
    time: '9時間前',
    location: '京都',
    likes: 189,
  ),
  CommentData(
    id: 'c8',
    user: '初コメの人',
    avatarColor: const Color(0xFF6D4C41),
    content: '初めてコメントしたけど、この内容に一瞬でファンになった！',
    time: '10時間前',
    location: '沖縄',
    likes: 76,
    replies: [
      CommentData(
        id: 'c8r1',
        user: 'ようこそ！',
        avatarColor: const Color(0xFF00838F),
        content: 'いらっしゃい！コメ欄はみんな優しいよ😄',
        time: '10時間前',
        likes: 28,
      ),
    ],
  ),
];