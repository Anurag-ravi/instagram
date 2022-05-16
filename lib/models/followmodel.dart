class FollowModel {
  String username;
  String name;
  String dp;
  bool following;

  FollowModel(this.dp,this.username,this.name,this.following);

  factory FollowModel.fromJson(dynamic json){
    return FollowModel(
      json['url'] as String , 
      json['username'] as String, 
      json['name'] as String,
      json['me_following'] as bool,
    );
  }
}