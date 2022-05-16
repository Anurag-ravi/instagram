class ProfileShort {
  int username;
  String url;

  ProfileShort(this.username, this.url);
  factory ProfileShort.fromJson(dynamic json){
    return ProfileShort(json['username'] as int, json['url'] as String);
  }
}