import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/data/local/shared_prefs_helper.dart';
import 'package:flutter_task/data/repositories/api_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiRepository repository;
  final SharedPrefsHelper prefsHelper;

  AuthBloc({required this.repository})
    : prefsHelper = SharedPrefsHelper(),
      super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await repository.login(event.email, event.password);
        await prefsHelper.saveToken(user.token);
        await prefsHelper.saveUser(user);
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString().replaceAll("Exception: ", "")));
      }
    });

    on<CheckAuthStatus>((event, emit) async {
      await Future.delayed(const Duration(milliseconds: 50));

      final token = await prefsHelper.getToken();
      final user = await prefsHelper.getUser();

      if (token != null && token.isNotEmpty && user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      await prefsHelper.clearAll();

      emit(AuthUnauthenticated());
    });
  }
}
