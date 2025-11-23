import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPosts extends PostEvent {}

class RefreshPosts extends PostEvent {}

class SearchPosts extends PostEvent {
  final String query;
  SearchPosts(this.query);
  @override
  List<Object?> get props => [query];
}
