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
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString().replaceAll("Exception: ", "")));
      }
    });

    on<CheckAuthStatus>((event, emit) async {
      final token = await prefsHelper.getToken();
      if (token != null && token.isNotEmpty) {
        try {
          final user = await repository.getCurrentUser();
          emit(AuthSuccess(user));
        } catch (e) {
          await prefsHelper.removeToken();
          emit(AuthInitial());
        }
      } else {
        emit(AuthInitial());
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      await prefsHelper.removeToken();
      emit(AuthInitial());
    });
  }
}
