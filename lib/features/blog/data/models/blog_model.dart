import 'package:blog_app/features/blog/domain/entities/blog_entity.dart';

class BlogModel extends BlogEntity {
  BlogModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.content,
    required super.image,
    required super.topics,
    required super.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'image_url': image,
      'topics': topics,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory BlogModel.fromJson(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      image: map['image_url'] as String,
      topics: List<String>.from(map['topics'] ??[]),
      updatedAt:map['updated_at'] == null ? DateTime.now() : DateTime.parse(map['updated_at']),
    );
  }

  
  BlogModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    String? image,
    List<String>? topics,
    DateTime? updatedAt,
  }) {
    return BlogModel(
      id: id ?? this.id,
      userId:  userId ?? this.userId,
     title: title ?? this.title,
      content:  content ?? this.content,
      image :image ?? this.image,
      topics: topics ?? this.topics,
      updatedAt:  updatedAt ?? this.updatedAt,
    );
  }
}
