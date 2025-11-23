import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/api_repository.dart';
import '../../data/models/post_model.dart';

class PostDetailScreen extends StatelessWidget {
  final int postId;
  const PostDetailScreen({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post Details")),
      body: FutureBuilder<PostModel>(
        future: context.read<ApiRepository>().getPostDetails(postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading post: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final post = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Chip(
                        avatar: const Icon(Icons.thumb_up, size: 16),
                        label: Text("${post.reactionsLikes}"),
                      ),
                      const SizedBox(width: 10),
                      Chip(
                        avatar: const Icon(Icons.remove_red_eye, size: 16),
                        label: Text("${post.views}"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    post.body,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    "Tags:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: post.tags
                        .map((tag) => Chip(label: Text("#$tag")))
                        .toList(),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
