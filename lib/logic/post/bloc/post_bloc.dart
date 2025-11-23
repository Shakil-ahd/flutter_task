import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/data/repositories/api_repository.dart';
import 'package:stream_transform/stream_transform.dart';
import 'post_event.dart';
import 'post_state.dart';

const _postLimit = 10;
const _throttleDuration = Duration(milliseconds: 300); // Search throttle

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return events.throttle(duration).switchMap(mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  final ApiRepository repository;

  PostBloc({required this.repository}) : super(const PostState()) {
    on<FetchPosts>(_onFetchPosts); // Normal fetch doesn't need huge throttle
    on<RefreshPosts>(_onRefreshPosts);
    on<SearchPosts>(
      _onSearchPosts,
      transformer: throttleDroppable(_throttleDuration),
    );
  }

  Future<void> _onFetchPosts(FetchPosts event, Emitter<PostState> emit) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == PostStatus.initial) {
        final posts = await repository.getPosts(limit: _postLimit, skip: 0);
        return emit(
          state.copyWith(
            status: PostStatus.success,
            posts: posts,
            hasReachedMax: false,
          ),
        );
      }

      final posts = await repository.getPosts(
        limit: _postLimit,
        skip: state.posts.length,
        searchQuery: state.searchQuery,
      );

      emit(
        posts.isEmpty
            ? state.copyWith(hasReachedMax: true)
            : state.copyWith(
                status: PostStatus.success,
                posts: List.of(state.posts)..addAll(posts),
                hasReachedMax: false,
              ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: PostStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onRefreshPosts(
    RefreshPosts event,
    Emitter<PostState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PostStatus.initial,
        posts: [],
        hasReachedMax: false,
        searchQuery: "",
      ),
    );
    add(FetchPosts());
  }

  Future<void> _onSearchPosts(
    SearchPosts event,
    Emitter<PostState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PostStatus.initial,
        posts: [],
        hasReachedMax: false,
        searchQuery: event.query,
      ),
    );

    try {
      final posts = await repository.getPosts(
        limit: _postLimit,
        skip: 0,
        searchQuery: event.query,
      );

      emit(
        state.copyWith(
          status: PostStatus.success,
          posts: posts,
          hasReachedMax: posts.length < _postLimit,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: PostStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}
