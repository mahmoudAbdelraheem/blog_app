import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/secrites/app_secrets.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login_usecase.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up_usecase.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependancies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseanonKey,
  );

  //! Register lazy Singletons return only one object throughout the lifetime of the app
  serviceLocator.registerLazySingleton(() => supabase.client);
  //! core folder
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  //! data sources
  //* Register Factories return every time call new object and return it
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        //* search for a registerFactory in serviceLocator with the type of supabaseClient
        supabaseClient: serviceLocator<SupabaseClient>(),
      ),
    )
    //! repositories
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        //* search for a registerFactory in serviceLocator with the type of authRemoteDataSource
        authRemoteDataSource: serviceLocator(),
      ),
    )
    //! use cases
    ..registerFactory(
      () => UserSignUpUseCase(
        authRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLoginUsecase(
        authRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetCurrentUserUsecase(
        authRepository: serviceLocator(),
      ),
    )
    //! blocs
    ..registerLazySingleton(
      //* return a single object from the authBolc throughout the lifetime of the app
      () => AuthBloc(
        userSignUpUseCase: serviceLocator(),
        userLoginUsecase: serviceLocator(),
        getCurrentUserUsecase: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}
