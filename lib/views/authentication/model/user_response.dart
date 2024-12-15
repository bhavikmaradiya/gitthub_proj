class UserResponse {
  UserResponse({
    this.login,
    this.id,
    this.nodeId,
    this.avatarUrl,
    this.gravatarId,
    this.url,
    this.htmlUrl,
    this.followersUrl,
    this.followingUrl,
    this.gistsUrl,
    this.starredUrl,
    this.subscriptionsUrl,
    this.organizationsUrl,
    this.reposUrl,
    this.eventsUrl,
    this.receivedEventsUrl,
    this.type,
    this.userViewType,
    this.siteAdmin,
    this.name,
    this.company,
    this.blog,
    this.location,
    this.email,
    this.hireable,
    this.bio,
    this.twitterUsername,
    this.notificationEmail,
    this.publicRepos,
    this.publicGists,
    this.followers,
    this.following,
    this.createdAt,
    this.updatedAt,
    this.privateGists,
    this.totalPrivateRepos,
    this.ownedPrivateRepos,
    this.diskUsage,
    this.collaborators,
    this.twoFactorAuthentication,
  });

  UserResponse.fromJson(dynamic json) {
    login = json['login'];
    id = json['id'];
    nodeId = json['node_id'];
    avatarUrl = json['avatar_url'];
    gravatarId = json['gravatar_id'];
    url = json['url'];
    htmlUrl = json['html_url'];
    followersUrl = json['followers_url'];
    followingUrl = json['following_url'];
    gistsUrl = json['gists_url'];
    starredUrl = json['starred_url'];
    subscriptionsUrl = json['subscriptions_url'];
    organizationsUrl = json['organizations_url'];
    reposUrl = json['repos_url'];
    eventsUrl = json['events_url'];
    receivedEventsUrl = json['received_events_url'];
    type = json['type'];
    userViewType = json['user_view_type'];
    siteAdmin = json['site_admin'];
    name = json['name'];
    company = json['company'];
    blog = json['blog'];
    location = json['location'];
    email = json['email'];
    hireable = json['hireable'];
    bio = json['bio'];
    twitterUsername = json['twitter_username'];
    notificationEmail = json['notification_email'];
    publicRepos = json['public_repos'];
    publicGists = json['public_gists'];
    followers = json['followers'];
    following = json['following'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    privateGists = json['private_gists'];
    totalPrivateRepos = json['total_private_repos'];
    ownedPrivateRepos = json['owned_private_repos'];
    diskUsage = json['disk_usage'];
    collaborators = json['collaborators'];
    twoFactorAuthentication = json['two_factor_authentication'];
  }

  String? login;
  num? id;
  String? nodeId;
  String? avatarUrl;
  String? gravatarId;
  String? url;
  String? htmlUrl;
  String? followersUrl;
  String? followingUrl;
  String? gistsUrl;
  String? starredUrl;
  String? subscriptionsUrl;
  String? organizationsUrl;
  String? reposUrl;
  String? eventsUrl;
  String? receivedEventsUrl;
  String? type;
  String? userViewType;
  bool? siteAdmin;
  String? name;
  dynamic company;
  String? blog;
  dynamic location;
  dynamic email;
  dynamic hireable;
  dynamic bio;
  dynamic twitterUsername;
  dynamic notificationEmail;
  num? publicRepos;
  num? publicGists;
  num? followers;
  num? following;
  String? createdAt;
  String? updatedAt;
  num? privateGists;
  num? totalPrivateRepos;
  num? ownedPrivateRepos;
  num? diskUsage;
  num? collaborators;
  bool? twoFactorAuthentication;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['login'] = login;
    map['id'] = id;
    map['node_id'] = nodeId;
    map['avatar_url'] = avatarUrl;
    map['gravatar_id'] = gravatarId;
    map['url'] = url;
    map['html_url'] = htmlUrl;
    map['followers_url'] = followersUrl;
    map['following_url'] = followingUrl;
    map['gists_url'] = gistsUrl;
    map['starred_url'] = starredUrl;
    map['subscriptions_url'] = subscriptionsUrl;
    map['organizations_url'] = organizationsUrl;
    map['repos_url'] = reposUrl;
    map['events_url'] = eventsUrl;
    map['received_events_url'] = receivedEventsUrl;
    map['type'] = type;
    map['user_view_type'] = userViewType;
    map['site_admin'] = siteAdmin;
    map['name'] = name;
    map['company'] = company;
    map['blog'] = blog;
    map['location'] = location;
    map['email'] = email;
    map['hireable'] = hireable;
    map['bio'] = bio;
    map['twitter_username'] = twitterUsername;
    map['notification_email'] = notificationEmail;
    map['public_repos'] = publicRepos;
    map['public_gists'] = publicGists;
    map['followers'] = followers;
    map['following'] = following;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['private_gists'] = privateGists;
    map['total_private_repos'] = totalPrivateRepos;
    map['owned_private_repos'] = ownedPrivateRepos;
    map['disk_usage'] = diskUsage;
    map['collaborators'] = collaborators;
    map['two_factor_authentication'] = twoFactorAuthentication;
    return map;
  }
}

/*
class Plan {
  Plan({
    this.name,
    this.space,
    this.collaborators,
    this.privateRepos,});

  Plan.fromJson(dynamic json) {
    name = json['name'];
    space = json['space'];
    collaborators = json['collaborators'];
    privateRepos = json['private_repos'];
  }

  String? name;
  num? space;
  num? collaborators;
  num? privateRepos;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['space'] = space;
    map['collaborators'] = collaborators;
    map['private_repos'] = privateRepos;
    return map;
  }

}*/
