import 'package:flutter/material.dart';

import 'package:flutter_task/presentation/Screen%20UI/Home/home_screen.dart';

import 'package:flutter_task/presentation/Screen%20UI/login_screen.dart';

import 'package:flutter_task/presentation/Screen%20UI/post_detail_screen.dart';

import 'package:flutter_task/presentation/Screen%20UI/setting_screen.dart';

class AppRouter {
  static const String login = '/login';
  static const String home = '/home';
  static const String postDetails = '/posts';
  static const String settings = '/settings';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    debugPrint("--------------------------------------------------");
    debugPrint("Incoming Route Name: ${settings.name}");

    final Uri uri = Uri.parse(settings.name ?? "");
    debugPrint("Path Segments: ${uri.pathSegments}");
    debugPrint("--------------------------------------------------");

    if (settings.name == login) {
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
    if (settings.name == home) {
      return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
    if (settings.name == AppRouter.settings) {
      return MaterialPageRoute(builder: (_) => const SettingScreen());
    }

    if (uri.path == postDetails && settings.arguments != null) {
      final int id = settings.arguments as int;
      return MaterialPageRoute(builder: (_) => PostDetailScreen(postId: id));
    }

    if (uri.pathSegments.length == 1) {
      var id = int.tryParse(uri.pathSegments.first);
      if (id != null) {
        debugPrint("✅ Matched Direct ID Path: $id");
        return MaterialPageRoute(builder: (_) => PostDetailScreen(postId: id));
      }
    }

    if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'posts') {
      var id = int.tryParse(uri.pathSegments[1]);
      if (id != null) {
        debugPrint("✅ Matched /posts/ID Path: $id");
        return MaterialPageRoute(builder: (_) => PostDetailScreen(postId: id));
      }
    }

    if (uri.scheme == 'myapp' && uri.host == 'posts') {
      if (uri.pathSegments.isNotEmpty) {
        var id = int.tryParse(uri.pathSegments.first);
        if (id != null) {
          return MaterialPageRoute(
            builder: (_) => PostDetailScreen(postId: id),
          );
        }
      }
    }

    debugPrint("❌ No Route Matched!");
    return null;
  }
}
