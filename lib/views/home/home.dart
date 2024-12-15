import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gitthub_proj/config/theme_config.dart';
import 'package:gitthub_proj/localdb/repo/db_repo.dart';

import '../../config/app_config.dart';
import '../../config/light_colors_config.dart';
import '../../const/assets.dart';
import '../../const/dimens.dart';
import '../../const/routes.dart';
import '../../network/network_connectivity.dart';
import '../../widgets/app_search_view.dart';
import '../../widgets/app_tool_bar.dart';
import 'bloc/home_bloc.dart';
import 'model/repositories_response.dart';
import 'widget/list_item_shimmer.dart';
import 'widget/repo_item_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeBloc? _homeBloc;
  late ScrollController _scrollController;
  AppLocalizations? _appLocalizations;

  @override
  void initState() {
    NetworkConnectivity.instance.initialise();
    _scrollController = ScrollController();
    _scrollController.addListener(
      () {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset) {
          if (!_isDisabledPullToRefreshLoadMore()) {
            _homeBloc?.add(FetchRepositoriesEvent());
          }
        }
      },
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appLocalizations ??= AppLocalizations.of(context)!;
    _homeBloc ??= BlocProvider.of<HomeBloc>(context, listen: false);
  }

  void _listenToHomeStates(context, state) {
    if (state is NetworkSwitchState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.isOnline
                ? _appLocalizations!.switchToOnline
                : _appLocalizations!.switchToOffline,
            style: TextStyle(
              color: Colors.white,
              fontSize: Dimens.dimens_15.sp,
            ),
          ),
          duration: const Duration(
            seconds: AppConfig.defaultSnackBarDuration,
          ),
        ),
      );
    } else if (state is LogoutSuccessfulState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _appLocalizations!.logoutSuccess,
            style: TextStyle(
              color: Colors.white,
              fontSize: Dimens.dimens_15.sp,
            ),
          ),
          duration: const Duration(
            seconds: AppConfig.defaultSnackBarDuration,
          ),
        ),
      );
      Navigator.pushReplacementNamed(
        context,
        Routes.splash,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Stack(
          children: [
            ToolBar(
              title: _appLocalizations!.appName,
              onInwardSearch: () {
                _homeBloc?.add(SearchInitializeEvent());
              },
              onLogout: () {
                showDialog(
                    context: context,
                    useSafeArea: true,
                    builder: (dialogContext) {
                      return Center(
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.sizeOf(context).width * 0.07),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: LightColorsConfig.lightBlackColor,
                              borderRadius: BorderRadius.circular(
                                Dimens.dimens_10.r,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff30343a),
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(
                                        Dimens.dimens_10.r,
                                      ),
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: Dimens.dimens_12.h,
                                  ),
                                  child: Text(
                                    _appLocalizations!.logout,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: Dimens.dimens_22.sp,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: Dimens.dimens_15.h,
                                    horizontal: Dimens.dimens_10.w,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        _appLocalizations!.logoutMsg,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              LightColorsConfig.lightWhiteColor,
                                          fontSize: Dimens.dimens_18.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        height: Dimens.dimens_50.h,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: LightColorsConfig
                                                    .lightWhiteColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  Dimens.dimens_10.r,
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    Dimens.dimens_10.r,
                                                  ),
                                                  onTap: () => Navigator.pop(
                                                    dialogContext,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal:
                                                          Dimens.dimens_12.w,
                                                      vertical:
                                                          Dimens.dimens_12.w,
                                                    ),
                                                    child: Text(
                                                      _appLocalizations!.cancel,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            Dimens.dimens_18.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Dimens.dimens_10.w,
                                          ),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: LightColorsConfig
                                                    .lightWhiteColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  Dimens.dimens_10.r,
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    Dimens.dimens_10.r,
                                                  ),
                                                  onTap: () async {
                                                    Navigator.pop(
                                                      dialogContext,
                                                    );
                                                    _homeBloc?.add(
                                                      HomeLogoutEvent(),
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal:
                                                          Dimens.dimens_12.w,
                                                      vertical:
                                                          Dimens.dimens_12.w,
                                                    ),
                                                    child: Text(
                                                      _appLocalizations!.logout,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            Dimens.dimens_18.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
            ),
            _searchWidget(_homeBloc),
          ],
        ),
      ),
      body: BlocListener<HomeBloc, HomeState>(
        listener: _listenToHomeStates,
        listenWhen: (_, current) =>
            current is LogoutSuccessfulState || current is NetworkSwitchState,
        child: SafeArea(
            child: BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (previous, current) =>
              previous != current &&
              (current is HomeLoadingState ||
                  current is HomeRepositoryFoundState ||
                  current is HomeEmptyState ||
                  current is SearchDataState ||
                  current is SearchCompletedState),
          builder: (context, state) {
            if (state is HomeLoadingState && !state.isPagination) {
              return _loadingWidget();
            } else if (state is HomeRepositoryFoundState ||
                state is HomeLoadingState) {
              List<DbRepo> data;
              bool hasMoreData = true;
              if (state is HomeRepositoryFoundState) {
                data = state.repositories;
                hasMoreData = state.hasMoreData;
              } else {
                data = _homeBloc?.getAllRepositories() ?? [];
              }
              if (data.isNotEmpty) {
                return _dataWidget(
                  data,
                  hasMore: hasMoreData,
                  isLoading: state is HomeLoadingState && state.isPagination,
                );
              }
            } else if (state is HomeEmptyState) {
              return _emptyWidget(
                _appLocalizations!.repositoryNotFound,
              );
            } else if (state is SearchDataState) {
              final searchedList = state.searchedRepos;
              if (searchedList.isNotEmpty) {
                return _dataWidget(searchedList);
              } else {
                return _emptyWidget(
                  _appLocalizations!.noRecordWithSearch,
                );
              }
            } else if (state is SearchCompletedState) {
              final data = state.repositories;
              if (data.isNotEmpty) {
                return _dataWidget(
                  data,
                  hasMore: state.hasMore,
                );
              }
            }
            return _emptyWidget(
              _appLocalizations!.repositoryNotFound,
            );
          },
        )),
      ),
    );
  }

  Widget _searchWidget(
    HomeBloc? homeBloc,
  ) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous != current &&
          (current is SearchInitializedState ||
              current is SearchDataState ||
              current is SearchCompletedState),
      builder: (context, state) {
        if (state is SearchInitializedState || state is SearchDataState) {
          return SafeArea(
            child: Container(
              height: double.infinity,
              margin: EdgeInsets.only(
                left: (Dimens.dimens_20 * 2.95).w,
              ),
              child: AppSearchView(
                onTextChange: (searchBy) {
                  homeBloc?.add(
                    SearchTextChangedEvent(
                      searchBy,
                    ),
                  );
                },
                onCloseSearch: () {
                  homeBloc?.add(
                    SearchCloseEvent(),
                  );
                },
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _loadingWidget() {
    return const ListItemShimmer(
      shimmerItemCount: 10,
    );
  }

  bool _isDisabledPullToRefreshLoadMore() {
    return _homeBloc?.isPaginationDisabled ?? false;
  }

  Widget _dataWidget(
    List<DbRepo> repoData, {
    bool? hasMore,
    bool? isLoading,
  }) {
    return ScrollConfiguration(
      behavior: const MaterialScrollBehavior().copyWith(
        overscroll: false,
      ),
      child: RefreshIndicator(
        onRefresh: _isDisabledPullToRefreshLoadMore()
            ? () => Future.value()
            : () async {
                _homeBloc?.add(FetchRepositoriesEvent(loadInitial: true));
              },
        notificationPredicate:
            _isDisabledPullToRefreshLoadMore() ? (_) => false : (_) => true,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          controller: _scrollController,
          itemCount: repoData.length + 1,
          itemBuilder: (context, index) {
            if (index < repoData.length) {
              final currentRepo = repoData[index];
              return Padding(
                padding: EdgeInsets.only(
                  top: index == 0 ? Dimens.dimens_10.h : 0,
                ),
                child: RepoListItem(
                  name: currentRepo.name,
                  description: currentRepo.description ?? '',
                  stars: currentRepo.stars ?? 0,
                  forks: currentRepo.forks ?? 0,
                  lastUsed: currentRepo.lastUpdated,
                ),
              );
            } else {
              if (_isDisabledPullToRefreshLoadMore() ||
                  (hasMore ?? false) == false) {
                return const SizedBox();
              }
              if (hasMore == true && isLoading == true) {
                return Column(
                  children: [
                    LinearProgressIndicator(
                      minHeight: Dimens.dimens_5.h,
                      color: LightColorsConfig.themeColor,
                    ),
                    SizedBox(
                      height: Dimens.dimens_150.h,
                    )
                  ],
                );
              }
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _emptyWidget(
    String message,
  ) {
    return RefreshIndicator(
      onRefresh: _isDisabledPullToRefreshLoadMore()
          ? () => Future.value()
          : () async {
              _homeBloc?.add(FetchRepositoriesEvent(loadInitial: true));
            },
      notificationPredicate:
          _isDisabledPullToRefreshLoadMore() ? (_) => false : (_) => true,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.dimens_20.w,
          vertical: Dimens.dimens_20.h,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Assets.icNoData,
                width: Dimens.dimens_120.w,
                height: Dimens.dimens_120.w,
              ),
              SizedBox(
                height: Dimens.dimens_30.h,
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: LightColorsConfig.lightWhiteColor,
                  fontWeight: FontWeight.w500,
                  fontSize: Dimens.dimens_19.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _homeBloc?.add(
      SearchCloseEvent(),
    );
    super.dispose();
  }
}
