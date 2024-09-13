import 'dart:async';
import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/common/entities/user_entity.dart';
import 'package:blog_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login_usecase.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUpUseCase _userSignUpUseCase;
  final UserLoginUsecase _userLoginUsecase;
  final GetCurrentUserUsecase _getCurrentUserUsecase;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required UserSignUpUseCase userSignUpUseCase,
    required UserLoginUsecase userLoginUsecase,
    required GetCurrentUserUsecase getCurrentUserUsecase,
    required AppUserCubit appUserCubit,
  })  : _userSignUpUseCase = userSignUpUseCase,
        _userLoginUsecase = userLoginUsecase,
        _getCurrentUserUsecase = getCurrentUserUsecase,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    //! just for emitting auth loading state automatically
    //! when eny event is triggered
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_signUp);
    on<AuthLogin>(_login);
    on<AuthIsUserLoggedIn>(_getUserData);
  }

  FutureOr<void> _signUp(AuthSignUp event, Emitter<AuthState> emit) async {
    // emit(AuthLoading());

    final response = await _userSignUpUseCase(
      UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );
    response.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => _emitAuthSuccess(
        user: user,
        emit: emit,
      ),
    );
  }

  FutureOr<void> _login(AuthLogin event, Emitter<AuthState> emit) async {
    // emit(AuthLoading());
    final response = await _userLoginUsecase(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );
    response.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => _emitAuthSuccess(
        user: user,
        emit: emit,
      ),
    );
  }

  FutureOr<void> _getUserData(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _getCurrentUserUsecase(NoParams());
    response.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => _emitAuthSuccess(
        user: user,
        emit: emit,
      ),
    );
  }

  void _emitAuthSuccess({
    required UserEntity user,
    required Emitter<AuthState> emit,
  }) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }
}
