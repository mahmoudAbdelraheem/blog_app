part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {
  const AppUserState();
}

final class AppUserInitial extends AppUserState {}


final class AppUserLoggedIn extends AppUserState {
  final UserEntity user;

  const AppUserLoggedIn({required this.user});
}

//! core folder can not depend on features folder
//! but features folder can depend on core folder