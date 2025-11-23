import 'package:equatable/equatable.dart';
import 'package:flutter_task/data/models/users_model.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthSuccess extends AuthState {
  final UserModel user;
  AuthSuccess(this.user);
  @override
  List<Object> get props => [user];
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
  @override
  List<Object> get props => [error];
}
