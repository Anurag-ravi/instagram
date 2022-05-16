class ProfileShort {
  String username;
  String url;

  ProfileShort(this.username, this.url);
  factory ProfileShort.fromJson(dynamic json){
    return ProfileShort(json['username'] as String, json['url'] as String);
  }
}