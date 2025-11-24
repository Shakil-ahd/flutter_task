import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/data/models/users_model.dart';
import 'package:flutter_task/data/repositories/api_repository.dart';
import 'package:flutter_task/data/services/device_info_services.dart';
import 'package:flutter_task/logic/auth/bloc/auth_bloc.dart';
import 'package:flutter_task/logic/auth/bloc/auth_state.dart';
import 'package:flutter_task/logic/post/bloc/post_bloc.dart';
import 'package:flutter_task/logic/post/bloc/post_event.dart';
import 'package:flutter_task/presentation/Screen%20UI/Home/widgets/home_header.dart';
import 'package:flutter_task/presentation/Screen%20UI/Home/widgets/home_post_list.dart';
import 'package:flutter_task/presentation/Screen%20UI/Home/widgets/user_details_dialog.dart';

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

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
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

  void _showUserDetailsDialog(UserModel user) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => Container(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: UserDetailsDialog(user: user),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    UserModel? currentUser;

    if (authState is AuthSuccess) {
      currentUser = authState.user;
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
          ),
        ),
        child: Column(
          children: [
            HomeHeader(
              user: currentUser,
              searchController: _searchController,
              onProfileTap: () {
                if (currentUser != null) {
                  _showUserDetailsDialog(currentUser);
                }
              },
            ),

            Expanded(child: HomePostList(scrollController: _scrollController)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => DeviceInfoService.showDeviceInfo(context),
        backgroundColor: const Color.fromARGB(255, 0, 89, 255),
        child: const Icon(Icons.info_outline, color: Colors.white),
      ),
    );
  }
}
