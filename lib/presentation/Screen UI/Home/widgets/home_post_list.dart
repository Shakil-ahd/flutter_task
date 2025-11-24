import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../logic/post/bloc/post_bloc.dart';
import '../../../../logic/post/bloc/post_event.dart';
import '../../../../logic/post/bloc/post_state.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/post_card.dart';
import '../../../widgets/loading_shimmer.dart';

class HomePostList extends StatelessWidget {
  final ScrollController scrollController;

  const HomePostList({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F7FA),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state.status == PostStatus.initial && state.posts.isEmpty) {
              return const PostListShimmer();
            }
            if (state.status == PostStatus.failure && state.posts.isEmpty) {
              return Center(child: Text("Error: ${state.errorMessage}"));
            }
            if (state.status == PostStatus.success && state.posts.isEmpty) {
              return const Center(child: Text("No posts found"));
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<PostBloc>().add(RefreshPosts());
                await Future.delayed(const Duration(seconds: 1));
              },
              color: const Color(0xFF8E2DE2),
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 16,
                  right: 16,
                  bottom: 80,
                ),
                itemCount: state.hasReachedMax
                    ? state.posts.length
                    : state.posts.length + 1,
                itemBuilder: (context, index) {
                  if (index >= state.posts.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final post = state.posts[index];
                  return PostCard(
                    post: post,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRouter.postDetails,
                      arguments: post.id,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
