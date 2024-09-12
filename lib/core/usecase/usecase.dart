import 'package:blog_app/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';
abstract interface class UsecCase<SuccessType,Parms>{
  Future<Either<Failures, SuccessType>> call(Parms params);
}



class NoParams {}
