import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/common/entities/user_entity.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUpUseCase implements UsecCase<UserEntity, UserSignUpParams> {
  //! depending on interface in domain layer
  final AuthRepository authRepository;

  UserSignUpUseCase({required this.authRepository});
  @override
  Future<Either<Failures, UserEntity>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailAndPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  final String name;
  final String email;
  final String password;
  const UserSignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
