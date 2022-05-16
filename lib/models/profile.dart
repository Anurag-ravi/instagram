import 'package:instagram/models/post_url.dart';
import 'package:instagram/models/profile_short.dart';

class ProfileModel {
  int profileId;
  String username;
  bool verified;
  int totalPosts;
  int followers;
  int following;
  String name;
  String bio;
  String dp;
  int mutualFriends;
  List<ProfileShort> firstMutual;
  bool meFollowing;
  List<PostURL> posts;
  List<PostURL> tags;

  ProfileModel(
    this.profileId,
    this.username,
    this.verified,
    this.totalPosts,
    this.followers,
    this.following,
    this.name,
    this.bio,
    this.dp,
    this.mutualFriends,
    this.firstMutual,
    this.meFollowing,
    this.posts,
    this.tags);

  factory ProfileModel.fromJson(dynamic json){
    var firstMutualJson = json['first_mutual'] as List;
    List<ProfileShort> _firstMutual = firstMutualJson.map((e) => ProfileShort.fromJson(e)).toList();

    var postsJson = json['posts'] as List;
    List<PostURL> _posts = postsJson.map((e) => PostURL.fromJson(e)).toList();
    
    var tagsJson = json['tags'] as List;
    List<PostURL> _tags = tagsJson.map((e) => PostURL.fromJson(e)).toList();
    
    return ProfileModel(
      json['profile_id'] as int,
      json['username'] as String,
      json['verified'] as bool,
      json['total_posts'] as int,
      json['followers'] as int,
      json['following'] as int,
      json['name'] as String,
      json['bio'] as String,
      json['dp'] as String,
      json['mutual_friends'] as int,
      _firstMutual,
      json['me_following'] as bool,
      _posts,
      _tags,
    );
  }
}