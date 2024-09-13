import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog_entity.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoriesImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;

  BlogRepositoriesImpl({required this.blogRemoteDataSource});
  @override
  Future<Either<Failures, BlogEntity>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String userId,
    required List<String> topics,
  }) async {
   
    try {
       BlogModel blog = BlogModel(
        id: const Uuid().v1(),
        userId: userId,
        title: title,
        content: content,
        image: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );
      //! upload image blog to supabase storage
      final String imageUrl = await blogRemoteDataSource.uploadBlogImage(image: image, blog: blog);
       blog.copyWith(image: imageUrl);
      blogRemoteDataSource.uploadBlog(blog);   
      //! upload blog to supabase database
      final uploadedBlog =  await blogRemoteDataSource.uploadBlog(blog);
      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }
}
