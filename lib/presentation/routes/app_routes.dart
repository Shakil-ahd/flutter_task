import 'package:flutter/material.dart';
import 'package:flutter_task/presentation/Screen%20UI/login_screen.dart';
import 'package:flutter_task/presentation/Screen%20UI/post_detail_screen.dart';
import '../Screen UI/home_screen.dart';

class AppRouter {
  static const String login = '/login';
  static const String home = '/home';
  static const String postDetails = '/posts';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final Uri uri = Uri.parse(settings.name ?? "");

    // 1. Named Routes
    if (settings.name == login) {
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
    if (settings.name == home) {
      return MaterialPageRoute(builder: (_) => const HomeScreen());
    }

    // 2. Post Details Logic
    // যদি অ্যাপের ভেতর থেকে pushNamed('/posts', arguments: 123) কল করা হয়
    if (uri.path == postDetails && settings.arguments != null) {
      final int id = settings.arguments as int;
      return MaterialPageRoute(builder: (_) => PostDetailScreen(postId: id));
    }

    // 3. Deep Linking Logic
    // Case A: myapp://posts/1
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
    // Case B: https://yourapp.com/posts/1
    if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'posts') {
      var id = int.tryParse(uri.pathSegments[1]);
      if (id != null) {
        return MaterialPageRoute(builder: (_) => PostDetailScreen(postId: id));
      }
    }

    return null;
  }
}
