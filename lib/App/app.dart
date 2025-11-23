import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/data/repositories/api_repository.dart';
import 'package:flutter_task/logic/auth/bloc/auth_bloc.dart';
import 'package:flutter_task/logic/auth/bloc/auth_event.dart';
import 'package:flutter_task/logic/auth/bloc/auth_state.dart';
import 'package:flutter_task/presentation/Screen%20UI/login_screen.dart';
import 'package:flutter_task/presentation/routes/app_routes.dart';
import '../presentation/Screen UI/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ApiRepository(),
      child: BlocProvider(
        create: (context) =>
            AuthBloc(repository: context.read<ApiRepository>())
              ..add(CheckAuthStatus()),

        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Posts App',
          theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),

          onGenerateRoute: AppRouter.onGenerateRoute,
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthSuccess) {
                return const HomeScreen();
              }
              return const LoginScreen();
            },
          ),
        ),
      ),
    );
  }
}
