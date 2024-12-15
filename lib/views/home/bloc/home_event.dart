part of 'home_bloc.dart';

abstract class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}
class HomeLogoutEvent extends HomeEvent {}

class FetchRepositoriesEvent extends HomeEvent {
  final bool loadInitial;
  final int limit;

  FetchRepositoriesEvent({
    this.loadInitial = false,
    this.limit = AppConfig.repositoriesPaginationLoadLimit,
  });
}

class SearchInitializeEvent extends HomeEvent {}

class SearchTextChangedEvent extends HomeEvent {
  final String searchBy;

  SearchTextChangedEvent(
    this.searchBy,
  );
}

class SearchCloseEvent extends HomeEvent {}
