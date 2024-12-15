class Endpoints {
  Endpoints._();
  static const int receiveTimeout = 25;
  static const int connectionTimeout = 25;
  static const String accessTokenBaseUrl =
      'https://github.com/login/oauth/access_token';
  static const String githubBaseUrl = 'https://api.github.com';
  static const String userInfoEndpoint = '/user';
  static const String repositoriesEndpoint = '/user/repos';
}
