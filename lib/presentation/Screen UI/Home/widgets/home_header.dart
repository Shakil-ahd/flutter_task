import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/data/models/users_model.dart';
import '../../../../logic/post/bloc/post_bloc.dart';
import '../../../../logic/post/bloc/post_event.dart';
import '../../../Screen UI/setting_screen.dart';

class HomeHeader extends StatelessWidget {
  final UserModel? user;
  final TextEditingController searchController;
  final VoidCallback onProfileTap;

  const HomeHeader({
    Key? key,
    required this.user,
    required this.searchController,
    required this.onProfileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onProfileTap,
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
                            backgroundImage:
                                (user?.image != null && user!.image.isNotEmpty)
                                ? NetworkImage(user!.image)
                                : null,
                            child: (user?.image == null || user!.image.isEmpty)
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
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          Text(
                            user != null
                                ? "${user!.firstName} ${user!.lastName}"
                                : "Guest",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(color: Colors.black26, blurRadius: 2),
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
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingScreen()),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: InputDecoration(
                hintText: "What are you looking for?",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                fillColor: Colors.white.withOpacity(0.25),
                filled: true,
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white),
                  onPressed: () {
                    searchController.clear();
                    context.read<PostBloc>().add(SearchPosts(""));
                    FocusManager.instance.primaryFocus?.unfocus();
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
    );
  }
}
