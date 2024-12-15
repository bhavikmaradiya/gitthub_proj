import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gitthub_proj/localdb/repo/db_repo.dart';
import 'package:gitthub_proj/views/authentication/model/access_token_response.dart';
import 'package:gitthub_proj/views/authentication/model/user_response.dart';
import 'package:gitthub_proj/views/home/model/repositories_response.dart';

import '../config/app_config.dart';
import 'endpoints.dart';
import 'interceptors/authorization_interceptor.dart';
import 'interceptors/logger_interceptor.dart';
import 'network_connectivity.dart';

class DioClient {
  static const _code200 = 200; // Success

  late final Dio _dio;
  late final Dio _dioAccessTokenApi;

  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: Endpoints.githubBaseUrl,
            connectTimeout: const Duration(
              seconds: Endpoints.connectionTimeout,
            ),
            receiveTimeout: const Duration(
              seconds: Endpoints.receiveTimeout,
            ),
            responseType: ResponseType.json,
            validateStatus: (_) => true,
          ),
        )..interceptors.addAll(
            [
              LoggerInterceptor(),
              AuthorizationInterceptor(),
            ],
          );

  DioClient.exchangeTokenApi()
      : _dioAccessTokenApi = Dio(
          BaseOptions(
            connectTimeout: const Duration(
              seconds: Endpoints.connectionTimeout,
            ),
            headers: {
              'Accept': 'application/json',
            },
            receiveTimeout: const Duration(
              seconds: Endpoints.receiveTimeout,
            ),
            responseType: ResponseType.json,
            validateStatus: (_) => true,
          ),
        )..interceptors.addAll(
            [
              LoggerInterceptor(),
            ],
          );

  Future<AccessTokenResponse?> authenticateAccessToken({
    required String clientId,
    required String clientSecret,
    required String code,
    required String redirectUrl,
  }) async {
    final isOnline = await NetworkConnectivity.hasNetwork();
    if (!isOnline) {
      return null;
    }
    try {
      final response = await _dioAccessTokenApi.get(
        Endpoints.accessTokenBaseUrl,
        queryParameters: {
          "client_id": clientId,
          "client_secret": clientSecret,
          "code": code,
          "redirect_uri": redirectUrl,
        },
      );
      if (response.statusCode == _code200) {
        var data = response.data;
        if (data != null) {
          return AccessTokenResponse.fromJson(data);
        }
        return null;
      } else {
        return null;
      }
    } on DioException catch (err) {
      if (kDebugMode) print(err);
      return null;
    } catch (e) {
      if (kDebugMode) print(e);
      return null;
    }
  }

  Future<UserResponse?> fetchUserInfo() async {
    final isOnline = await NetworkConnectivity.hasNetwork();
    if (!isOnline) {
      return null;
    }
    try {
      final response = await _dio.get(
        Endpoints.userInfoEndpoint,
      );
      if (response.statusCode == _code200) {
        var data = response.data;
        if (data != null) {
          return UserResponse.fromJson(data);
        }
        return null;
      } else {
        return null;
      }
    } on DioException catch (err) {
      if (kDebugMode) print(err);
      return null;
    } catch (e) {
      if (kDebugMode) print(e);
      return null;
    }
  }

  Future<List<DbRepo>?> fetchRepository({
    int page = 0,
    int pageLimit = AppConfig.repositoriesPaginationLoadLimit,
  }) async {
    final isOnline = await NetworkConnectivity.hasNetwork();
    if (!isOnline) {
      return null;
    }
    // ?page=$page&per_page=$perPage
    try {
      final response =
          await _dio.get(Endpoints.repositoriesEndpoint, queryParameters: {
        'page': page,
        'per_page': pageLimit,
        'sort': 'updated',
        'direction': 'desc',
      });
      if (response.statusCode == _code200) {
        var data = response.data;
        if (data != null) {
          return (data as List).map((e) {
            final repo = RepositoriesResponse.fromJson(e);
            return DbRepo()
              ..id = repo.id!.toInt()
              ..name = repo.name
              ..description = repo.description
              ..lastUpdated = repo.updatedAt
              ..stars = repo.stargazersCount?.toInt()
              ..forks = repo.forksCount?.toInt();
          }).toList();
        }
        return null;
      } else {
        return null;
      }
    } on DioException catch (err) {
      if (kDebugMode) print(err);
      return null;
    } catch (e) {
      if (kDebugMode) print(e);
      return null;
    }
  }
}
