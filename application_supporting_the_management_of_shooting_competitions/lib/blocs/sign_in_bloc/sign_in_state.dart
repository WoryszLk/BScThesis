part of 'sign_in_bloc.dart';

sealed class SignInState extends Equatable {
  const SignInState();
  
  @override
  List<Object> get props => [];
}

final class SignInInitial extends SignInState {}

final class SignOutSuccess extends SignInState {}

final class SignOutFailure extends SignInState {
  final String error;

  const SignOutFailure({required this.error});

  @override 
  List<Object> get props => [error];
}

class SignInSuccess extends SignInState {}
class SignInFailure extends SignInState {
	final String? message;

	const SignInFailure({this.message});
}
class SignInProcess extends SignInState {}