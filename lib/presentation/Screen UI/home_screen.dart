import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/logic/auth/bloc/auth_bloc.dart';
import 'package:flutter_task/logic/auth/bloc/auth_state.dart';
import 'package:flutter_task/logic/post/bloc/post_bloc.dart';
import 'package:flutter_task/logic/post/bloc/post_event.dart';
import 'package:flutter_task/logic/post/bloc/post_state.dart';
import 'package:flutter_task/presentation/Screen%20UI/user_details_screen.dart';
import 'package:flutter_task/presentation/routes/app_routes.dart';
import '../../data/repositories/api_repository.dart';
import '../widgets/post_card.dart';
import '../widgets/loading_shimmer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PostBloc(repository: context.read<ApiRepository>())
            ..add(FetchPosts()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView({Key? key}) : super(key: key);
  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  static const platform = MethodChannel('com.example.app/device_info');

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) context.read<PostBloc>().add(FetchPosts());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> _getDeviceInfo() async {
    String deviceInfo;
    try {
      final String result = await platform.invokeMethod('getDeviceInfo');
      deviceInfo = result;
    } on PlatformException catch (e) {
      deviceInfo = "Failed to get info: '${e.message}'.";
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.perm_device_information, color: Colors.blue),
              SizedBox(width: 10),
              Text("Device Info"),
            ],
          ),
          content: Text(
            deviceInfo,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Close",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    String userName = "Guest";
    String? userImage;

    if (authState is AuthSuccess) {
      userName = "${authState.user.firstName} ${authState.user.lastName}";
      userImage = authState.user.image;
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 149, 175, 3),
              Color.fromARGB(255, 0, 89, 255),
            ],
          ),
        ),
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.white.withOpacity(0.3),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    (userImage != null && userImage.isNotEmpty)
                                    ? NetworkImage(userImage)
                                    : null,
                                child: (userImage == null || userImage.isEmpty)
                                    ? const Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Welcome back,",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const UserDetailsScreen(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search posts...",
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                        ),
                        fillColor: Colors.white.withOpacity(0.2),
                        filled: true,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white70,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white70),
                          onPressed: () {
                            _searchController.clear();
                            context.read<PostBloc>().add(SearchPosts(""));
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 20,
                        ),
                      ),
                      onSubmitted: (query) =>
                          context.read<PostBloc>().add(SearchPosts(query)),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Container(
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
                      if (state.status == PostStatus.initial &&
                          state.posts.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: PostListShimmer(),
                        );
                      }

                      if (state.status == PostStatus.failure &&
                          state.posts.isEmpty) {
                        return Center(
                          child: Text("Error: ${state.errorMessage}"),
                        );
                      }

                      if (state.status == PostStatus.success &&
                          state.posts.isEmpty) {
                        return const Center(child: Text("No posts found"));
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<PostBloc>().add(RefreshPosts());
                          await Future.delayed(const Duration(seconds: 1));
                        },
                        color: const Color.fromARGB(255, 0, 89, 255),
                        backgroundColor: Colors.white,
                        child: ListView.builder(
                          controller: _scrollController,
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
                              return Center(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                ),
                              );
                            }
                            final post = state.posts[index];
                            return PostCard(
                              post: post,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRouter.postDetails,
                                  arguments: post.id,
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getDeviceInfo,
        backgroundColor: const Color.fromARGB(255, 0, 89, 255),
        child: const Icon(Icons.info_outline, color: Colors.white),
      ),
    );
  }
}
