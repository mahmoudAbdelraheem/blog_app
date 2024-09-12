import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/common/entities/user_entity.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLoginUsecase implements UsecCase<UserEntity,UserLoginParams>{
  final AuthRepository authRepository;

  UserLoginUsecase({required this.authRepository});
  @override
  Future<Either<Failures,UserEntity>> call(UserLoginParams params)async {
    
    return await authRepository.loginWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }

}

class UserLoginParams{
  final String email;
  final String password;
  const UserLoginParams({
    required this.email,
    required this.password,
  });
}