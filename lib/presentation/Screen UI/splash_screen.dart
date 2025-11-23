import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/logic/auth/bloc/auth_bloc.dart';
import 'package:flutter_task/logic/auth/bloc/auth_state.dart';
import 'package:flutter_task/presentation/routes/app_routes.dart'
    show AppRouter;
import '../widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool _isAnimationDone = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward().whenComplete(() {
      setState(() {
        _isAnimationDone = true;
      });

      _checkAndNavigate(context.read<AuthBloc>().state);
    });
  }

  void _checkAndNavigate(AuthState state) {
    if (!_isAnimationDone) return;

    if (state is AuthSuccess) {
      Navigator.of(context).pushReplacementNamed(AppRouter.home);
    } else if (state is AuthUnauthenticated ||
        state is AuthInitial ||
        state is AuthFailure) {
      Navigator.of(context).pushReplacementNamed(AppRouter.login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        _checkAndNavigate(state);
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 149, 175, 3),
                Color.fromARGB(255, 0, 89, 255),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: const AppLogo(size: 120),
              ),
              const SizedBox(height: 24),
              const Text(
                "Posts App",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
