import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/common/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {

  Future<Either<Failures, UserEntity>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failures, UserEntity>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Either<Failures, UserEntity>> getCurrentUserData();
}
