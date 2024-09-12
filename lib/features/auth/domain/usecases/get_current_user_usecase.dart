import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/common/entities/user_entity.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetCurrentUserUsecase implements UsecCase<UserEntity,NoParams>{
  final AuthRepository authRepository;

  GetCurrentUserUsecase({required this.authRepository});
  @override
  Future<Either<Failures, UserEntity>> call(NoParams params) async{
    return await authRepository.getCurrentUserData();
  }

}
