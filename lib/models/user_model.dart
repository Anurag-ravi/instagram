class User {
  String name;
  String profileImageUrl;

  User(
    this.name,
    this.profileImageUrl,
  );
  factory User.fromJson(dynamic json){
    return User(json['username'] as String,json['authorDp'] as String);
  }
}