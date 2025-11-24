import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/data/services/device_info_services.dart';
import 'package:flutter_task/logic/auth/bloc/auth_bloc.dart';
import 'package:flutter_task/logic/auth/bloc/auth_state.dart';
import 'package:flutter_task/logic/post/bloc/post_bloc.dart';
import 'package:flutter_task/logic/post/bloc/post_event.dart';
import 'package:flutter_task/logic/post/bloc/post_state.dart';
import 'package:flutter_task/presentation/Screen%20UI/setting_screen.dart';
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
  const _HomeView();
  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

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

  void _showUserDetails(String name, String email, String? image) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => Container(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white.withOpacity(0.95),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: (image != null)
                        ? NetworkImage(image)
                        : null,
                    child: (image == null)
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  email,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0C3FC).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Verified User",
                    style: TextStyle(
                      color: Color(0xFF6A11CB),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    String userName = "Guest";
    String userEmail = "";
    String? userImage;

    if (authState is AuthSuccess) {
      userName = "${authState.user.firstName} ${authState.user.lastName}";
      userEmail = authState.user.email;
      userImage = authState.user.image;
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFa18cd1), Color(0xFFfbc2eb)],
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
                        GestureDetector(
                          onTap: () =>
                              _showUserDetails(userName, userEmail, userImage),
                          child: Row(
                            children: [
                              Hero(
                                tag: 'userProfile',
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 22,
                                    backgroundImage: (userImage != null)
                                        ? NetworkImage(userImage)
                                        : null,
                                    child: (userImage == null)
                                        ? const Icon(Icons.person)
                                        : null,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Welcome,",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    userName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
                                builder: (_) => const SettingScreen(),
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
                        hintText: "What are you looking for?",
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                        ),
                        fillColor: Colors.white.withOpacity(0.25),
                        filled: true,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white),
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
                        return const PostListShimmer();
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
                        color: const Color(0xFF8E2DE2),
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
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => DeviceInfoService.showDeviceInfo(context),
        backgroundColor: const Color(0xFF8E2DE2),
        child: const Icon(Icons.info_outline, color: Colors.white),
      ),
    );
  }
}
