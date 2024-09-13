

class BlogEntity {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String image;
  final List<String> topics;
  final DateTime updatedAt;

  BlogEntity( {
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
    required this.updatedAt,
  });


}
