import 'package:flutter/material.dart';
import 'package:flutter_task/presentation/Screen%20UI/home_screen.dart';
import 'package:flutter_task/presentation/Screen%20UI/login_screen.dart';
import 'package:flutter_task/presentation/Screen%20UI/post_detail_screen.dart';

class AppRouter {
  static const String login = '/login';
  static const String home = '/home';
  static const String postDetails = '/posts';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final Uri uri = Uri.parse(settings.name ?? "");

    if (settings.name == login) {
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
    if (settings.name == home) {
      return MaterialPageRoute(builder: (_) => const HomeScreen());
    }

    if (uri.path == postDetails && settings.arguments != null) {
      final int id = settings.arguments as int;
      return MaterialPageRoute(builder: (_) => PostDetailScreen(postId: id));
    }

    if (uri.pathSegments.isNotEmpty &&
        (uri.pathSegments.first == 'posts' || uri.host == 'posts')) {
      var index = uri.pathSegments.indexOf('posts');
      if (index != -1 && index + 1 < uri.pathSegments.length) {
        var id = int.tryParse(uri.pathSegments[index + 1]);
        if (id != null) {
          return MaterialPageRoute(
            builder: (_) => PostDetailScreen(postId: id),
          );
        }
      }
    }

    return null;
  }
}
