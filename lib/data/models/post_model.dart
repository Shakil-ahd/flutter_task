class PostModel {
  final int id;
  final String title;
  final String body;
  final List<String> tags;
  final int reactionsLikes;
  final int reactionsDislikes;
  final int views;
  final int userId;

  PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.reactionsLikes,
    required this.reactionsDislikes,
    required this.views,
    required this.userId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      tags: List<String>.from(json['tags'] ?? []),
      reactionsLikes: json['reactions'] is Map
          ? (json['reactions']['likes'] ?? 0)
          : 0,
      reactionsDislikes: json['reactions'] is Map
          ? (json['reactions']['dislikes'] ?? 0)
          : 0,
      views: json['views'] ?? 0,
      userId: json['userId'],
    );
  }
}
