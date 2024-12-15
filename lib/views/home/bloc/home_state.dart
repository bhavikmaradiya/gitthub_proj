part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeEmptyState extends HomeState {}

class LogoutSuccessfulState extends HomeState {}

class SearchDataState extends HomeState {
  final List<DbRepo> searchedRepos;

  SearchDataState(
    this.searchedRepos,
  );
}

class SearchInitializedState extends HomeState {}

class NetworkSwitchState extends HomeState {
  final bool isOnline;

  NetworkSwitchState(
    this.isOnline,
  );
}

class SearchCompletedState extends HomeState {
  final List<DbRepo> repositories;
  final bool hasMore;

  SearchCompletedState(
    this.repositories,
    this.hasMore,
  );
}

class HomeRepositoryFoundState extends HomeState {
  final List<DbRepo> repositories;
  final bool hasMoreData;

  HomeRepositoryFoundState({
    required this.repositories,
    required this.hasMoreData,
  });
}

class HomeLoadingState extends HomeState {
  final bool isPagination;

  HomeLoadingState({
    required this.isPagination,
  });
}
