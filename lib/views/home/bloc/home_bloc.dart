import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/app_config.dart';
import '../../../localdb/isar_service.dart';
import '../../../localdb/repo/db_repo.dart';
import '../../../network/dio_client.dart';
import '../../../network/network_connectivity.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final _dio = DioClient();
  final _isarService = IsarService();
  bool _isLoading = false;
  bool _hasMoreData = false;
  bool _disablePullToRefreshLoadMore = false;
  final List<DbRepo> _repositories = [];
  bool _isOnline = false;
  bool _showOnlyStarredByYou = false;
  String _searchText = '';
  StreamSubscription<bool>? _networkListener;

  bool get isPaginationDisabled => _disablePullToRefreshLoadMore;

  HomeBloc() : super(HomeInitialState()) {
    on<HomeInitialEvent>(_init);
    on<HomeLogoutEvent>(_onLogout);
    on<SwitchStarredFilterEvent>(_onStarredFilter);
    on<FetchRepositoriesEvent>(_onFetchRepos);
    on<SearchInitializeEvent>(_onSearchInitialized);
    on<SearchTextChangedEvent>(_onSearchTextChanged);
    on<SearchCloseEvent>(_onCloseSearch);
    add(HomeInitialEvent());
  }

  void _init(
    HomeInitialEvent event,
    Emitter<HomeState> emit,
  ) async {
    _isOnline = await NetworkConnectivity.hasNetwork();
    _fetchInitialData(emit);
    _listenToNetworkChanges(emit);
    await _networkListener?.asFuture();
  }

  void _onStarredFilter(
    SwitchStarredFilterEvent event,
    Emitter<HomeState> emit,
  ) {
    _showOnlyStarredByYou = !_showOnlyStarredByYou;

    if (_showOnlyStarredByYou) {
      _applyStarredFilter(emit);
    } else {
      emit(
        StarredFilterUpdatedState(
          _showOnlyStarredByYou,
        ),
      );
      _disablePullToRefreshLoadMore = !_isOnline;
      _sortMyRepos();
      emit(
        StarredFilterRemovedState(
          _repositories,
          _hasMoreData,
        ),
      );
    }
  }

  _applyStarredFilter(
    Emitter<HomeState> emit,
  ) {
    _disablePullToRefreshLoadMore = true;
    final starredRepos =
        _repositories.where((e) => e.isStarred == true).toList();
    starredRepos.sort((a, b) {
      if (a.lastUpdated == null || a.lastUpdated!.isEmpty) {
        return b.lastUpdated == null || b.lastUpdated!.isEmpty ? 0 : 1;
      }
      if (b.lastUpdated == null || b.lastUpdated!.isEmpty) {
        return -1;
      }

      final dateA = DateTime.parse(a.lastUpdated!);
      final dateB = DateTime.parse(b.lastUpdated!);
      return dateB.compareTo(dateA); // Sort by descending date
    });
    emit(
      StarredFilterUpdatedState(
        _showOnlyStarredByYou,
        data: starredRepos,
      ),
    );
  }

  _listenToNetworkChanges(
    Emitter<HomeState> emit,
  ) {
    _networkListener = NetworkConnectivity.instance.networkChangeStream
        .listen((isOnline) async {
      print("networkChangeStream $isOnline");
      if (_isOnline != isOnline) {
        _isOnline = isOnline;
        _disablePullToRefreshLoadMore = !_isOnline;
        if (_isOnline) {
          _isLoading = false;
        }
        _fetchInitialData(emit);
        emit(
          NetworkSwitchState(
            _isOnline,
          ),
        );
      }
    });
  }

  _onSearchInitialized(
    SearchInitializeEvent event,
    Emitter<HomeState> emit,
  ) {
    _disablePullToRefreshLoadMore = true;
    emit(SearchInitializedState());
  }

  _onSearchTextChanged(
    SearchTextChangedEvent event,
    Emitter<HomeState> emit,
  ) {
    _searchText = event.searchBy.toString().trim().toLowerCase();
    final List<DbRepo> reposForSearch = [];
    reposForSearch.addAll(_repositories);
    final filterList = reposForSearch
        .where((element) =>
            (!_showOnlyStarredByYou ||
                (_showOnlyStarredByYou && element.isStarred == true)) &&
            ((element.name != null &&
                    element.name!.trim().toLowerCase().contains(_searchText)) ||
                (element.description != null &&
                    element.description!
                        .trim()
                        .toLowerCase()
                        .contains(_searchText))))
        .toList();
    filterList.sort((a, b) {
      if (a.lastUpdated == null || a.lastUpdated!.isEmpty) {
        return b.lastUpdated == null || b.lastUpdated!.isEmpty ? 0 : 1;
      }
      if (b.lastUpdated == null || b.lastUpdated!.isEmpty) {
        return -1;
      }

      final dateA = DateTime.parse(a.lastUpdated!);
      final dateB = DateTime.parse(b.lastUpdated!);
      return dateB.compareTo(dateA); // Sort by descending date
    });
    emit(SearchDataState(filterList));
  }

  _onCloseSearch(
    SearchCloseEvent event,
    Emitter<HomeState> emit,
  ) {
    _searchText = '';

    _disablePullToRefreshLoadMore = !_isOnline;
    emit(
      SearchCompletedState(
        _repositories,
        _hasMoreData,
      ),
    );
    if (_showOnlyStarredByYou) {
      _applyStarredFilter(emit);
    }
  }

  _fetchInitialData(
    Emitter<HomeState> emit,
  ) async {
    if (_isOnline) {
      add(
        FetchRepositoriesEvent(
          loadInitial: true,
        ),
      );
    } else {
      _repositories.clear();
      emit(
        HomeLoadingState(
          isPagination: false,
        ),
      );
      final offlineData = await _isarService.getAllRepos();
      _repositories.addAll(offlineData);
      _sortMyRepos();
      if (_searchText.trim().isNotEmpty) {
        _disablePullToRefreshLoadMore = true;
        add(SearchTextChangedEvent(_searchText));
      } else {
        if (_repositories.isEmpty) {
          emit(HomeEmptyState());
        } else {
          emit(
            HomeRepositoryFoundState(
              repositories: _repositories,
              hasMoreData: false,
            ),
          );
        }
      }
    }
  }

  List<DbRepo> getAllRepositories() {
    return _repositories;
  }

  _onFetchRepos(
    FetchRepositoriesEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (!_isOnline || _isLoading) {
      return;
    }
    final shouldReset = event.loadInitial;
    if (shouldReset || _hasMoreData) {
      _isLoading = true;
      emit(
        HomeLoadingState(
          isPagination: !shouldReset && _repositories.isNotEmpty,
        ),
      );

      if (shouldReset) {
        _repositories.clear();
      }
      int page = (_repositories.length / event.limit).ceil() + 1;
      final responseData = (await _dio.fetchRepository(
            page: page,
            pageLimit: event.limit,
          )) ??
          [];

      _hasMoreData = !(responseData.length < event.limit);
      if (responseData.isNotEmpty) {
        for (int i = 0; i < responseData.length; i++) {
          final currentRepo = responseData[i];

          final index = _repositories.indexWhere(
            (e) => e.id == currentRepo.id,
          );
          if (index == (-1)) {
            _repositories.add(currentRepo);
          }
        }
      }
      _updateLocalDb();
      _isLoading = false;
      if (_searchText.trim().isNotEmpty) {
        _disablePullToRefreshLoadMore = true;
        add(SearchTextChangedEvent(_searchText));
      } else {
        if (_repositories.isEmpty) {
          emit(HomeEmptyState());
        } else {
          _sortMyRepos();
          emit(
            HomeRepositoryFoundState(
              repositories: _repositories,
              hasMoreData: _hasMoreData,
            ),
          );
        }
      }
    }
  }

  _sortMyRepos() {
    _repositories.sort((a, b) {
      if (a.lastUpdated == null || a.lastUpdated!.isEmpty) {
        return b.lastUpdated == null || b.lastUpdated!.isEmpty ? 0 : 1;
      }
      if (b.lastUpdated == null || b.lastUpdated!.isEmpty) {
        return -1;
      }

      final dateA = DateTime.parse(a.lastUpdated!);
      final dateB = DateTime.parse(b.lastUpdated!);
      return dateB.compareTo(dateA);
    });
  }

  Future<void> _onLogout(
    HomeLogoutEvent event,
    Emitter<HomeState> emit,
  ) async {
    _isarService.cleanDb();
    (await SharedPreferences.getInstance()).clear();
    emit(LogoutSuccessfulState());
  }

  void _updateLocalDb() {
    _isarService.updateRepoInfo(_repositories);
  }

  @override
  Future<void> close() async {
    await _networkListener?.cancel();
    return super.close();
  }
}
