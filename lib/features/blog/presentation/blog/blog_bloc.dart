import 'dart:async';
import 'dart:io';

import 'package:blog_app/features/blog/domain/usecases/upload_blog_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlogUsecase _uploadBlogUsecase;
  BlogBloc({
    required UploadBlogUsecase uploadBlogUsecase,
  })  : _uploadBlogUsecase = uploadBlogUsecase,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));

    on<BlogUploadEvent>(_uploadBlog);
  }

  FutureOr<void> _uploadBlog(
    BlogUploadEvent event,
    Emitter<BlogState> emit,
  ) async {
    final result = await _uploadBlogUsecase(
      UploadBlogParams(
        userId: event.userId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );

    result.fold(
      (l) => emit(BlogFailure(message: l.message)),
      (r) => emit(BlogSuccess()),
    );
  }
}
