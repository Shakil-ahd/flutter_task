import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/logic/post/bloc/post_bloc.dart';
import 'package:flutter_task/logic/post/bloc/post_event.dart';
import 'package:flutter_task/logic/post/bloc/post_state.dart';
import '../../data/repositories/api_repository.dart';
import '../../logic/auth/bloc/auth_bloc.dart';
import '../../logic/auth/bloc/auth_state.dart';
import '../routes/app_routes.dart';
import '../widgets/post_card.dart';
import '../widgets/loading_shimmer.dart';

import 'user_setting_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // পোস্ট ব্লকে ইনিশিয়াল ডেটা কল করা হচ্ছে
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

  // Native Android এর সাথে যোগাযোগের জন্য চ্যানেল নাম
  static const platform = MethodChannel('com.example.app/device_info');

  @override
  void initState() {
    super.initState();
    // স্ক্রল লিসেনার সেটআপ (Infinite Scroll এর জন্য)
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      // স্ক্রল শেষে পৌঁছালে নতুন পোস্ট লোড হবে
      context.read<PostBloc>().add(FetchPosts());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // ৯০% স্ক্রল হলেই নতুন রিকোয়েস্ট পাঠাবে
    return currentScroll >= (maxScroll * 0.9);
  }

  // --- Feature 4: Native Android MethodChannel Call ---
  Future<void> _getDeviceInfo() async {
    String deviceInfo;
    try {
      // নেটিভ ফাংশন কল করা হচ্ছে
      final String result = await platform.invokeMethod('getDeviceInfo');
      deviceInfo = result;
    } on PlatformException catch (e) {
      deviceInfo = "Failed to get device info: '${e.message}'.";
    }

    if (!mounted) return;
    // ডায়ালগে ইনফো দেখানো
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Device Info (Native)"),
        content: Text(deviceInfo),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // AuthBloc থেকে ইউজারের তথ্য নেওয়া হচ্ছে
    final authState = context.read<AuthBloc>().state;
    String userName = "Guest";
    String? userImage;

    if (authState is AuthSuccess) {
      userName = "${authState.user.firstName} ${authState.user.lastName}";
      userImage = authState.user.image;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // লাইট ব্যাকগ্রাউন্ড কালার
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        titleSpacing: 0,
        // ইউজারের ছবি
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey[200],
            backgroundImage: (userImage != null && userImage.isNotEmpty)
                ? NetworkImage(userImage)
                : null,
            child: (userImage == null || userImage.isEmpty)
                ? const Icon(Icons.person, color: Colors.grey)
                : null,
          ),
        ),
        // ইউজারের নাম
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome back,",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              userName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UserDetailsScreen()),
            ),
          ),
        ],
        // সার্চ বার (App Bar এর নিচে)
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search posts...",
                hintStyle: TextStyle(color: Colors.grey[400]),
                fillColor: Colors.grey[100],
                filled: true,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    // ক্লিয়ার করলে সব পোস্ট আবার লোড হবে
                    context.read<PostBloc>().add(SearchPosts(""));
                  },
                ),
              ),
              // কি-বোর্ডের এন্টার চাপলে সার্চ হবে
              onSubmitted: (query) =>
                  context.read<PostBloc>().add(SearchPosts(query)),
            ),
          ),
        ),
      ),

      // নেটিভ ইনফো দেখার বাটন
      floatingActionButton: FloatingActionButton(
        onPressed: _getDeviceInfo,
        backgroundColor: const Color(0xFF2575FC),
        child: const Icon(Icons.info_outline, color: Colors.white),
      ),

      // পোস্ট লিস্ট এরিয়া
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          // ১. লোডিং স্টেট (প্রথমবার)
          if (state.status == PostStatus.initial && state.posts.isEmpty) {
            return const PostListShimmer(); // শিমার ইফেক্ট
          }

          // ২. এরর স্টেট
          if (state.status == PostStatus.failure && state.posts.isEmpty) {
            return Center(child: Text("Error: ${state.errorMessage}"));
          }

          // ৩. এম্পটি স্টেট
          if (state.status == PostStatus.success && state.posts.isEmpty) {
            return const Center(child: Text("No posts found"));
          }

          // ৪. সাকসেস স্টেট (লিস্ট ভিউ)
          return RefreshIndicator(
            onRefresh: () async {
              context.read<PostBloc>().add(RefreshPosts());
              // UX এর জন্য সামান্য ডিলে
              await Future.delayed(const Duration(seconds: 1));
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              // লোডার দেখানোর জন্য আইটেম কাউন্ট ১ বাড়ানো হলো
              itemCount: state.hasReachedMax
                  ? state.posts.length
                  : state.posts.length + 1,
              itemBuilder: (context, index) {
                // লোডার ইন্ডিকেটর (সবার শেষে)
                if (index >= state.posts.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final post = state.posts[index];
                return PostCard(
                  post: post,
                  onTap: () {
                    // রাউটিং এর মাধ্যমে ডিটেইলস পেজে যাওয়া
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
    );
  }
}
