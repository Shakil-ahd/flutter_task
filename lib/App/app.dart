import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/data/repositories/api_repository.dart';
import 'package:flutter_task/logic/auth/bloc/auth_bloc.dart';
import 'package:flutter_task/logic/auth/bloc/auth_event.dart';
import 'package:flutter_task/presentation/Screen%20UI/splash_screen.dart';
import 'package:flutter_task/presentation/routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ApiRepository(),
      child: BlocProvider(
        create: (context) =>
            AuthBloc(repository: context.read<ApiRepository>())
              ..add(CheckAuthStatus()), // অ্যাপ চালুর সাথে সাথে অথ চেক হবে

        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Posts App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFF5F7FA),
            fontFamily: 'Roboto', // ফন্ট ফ্যামিলি ডিফাইন করা হলো
          ),
          onGenerateRoute: AppRouter.onGenerateRoute,
          // সরাসরি স্প্ল্যাশ স্ক্রিন সেট করা হলো, কোনো কন্ডিশন ছাড়াই
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
