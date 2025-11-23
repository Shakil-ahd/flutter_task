import 'package:equatable/equatable.dart';
import '../../../data/models/post_model.dart';

enum PostStatus { initial, success, failure }

class PostState extends Equatable {
  final PostStatus status;
  final List<PostModel> posts;
  final bool hasReachedMax;
  final String errorMessage;
  final String searchQuery;

  const PostState({
    this.status = PostStatus.initial,
    this.posts = const <PostModel>[],
    this.hasReachedMax = false,
    this.errorMessage = "",
    this.searchQuery = "",
  });

  PostState copyWith({
    PostStatus? status,
    List<PostModel>? posts,
    bool? hasReachedMax,
    String? errorMessage,
    String? searchQuery,
  }) {
    return PostState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [
    status,
    posts,
    hasReachedMax,
    errorMessage,
    searchQuery,
  ];
}
